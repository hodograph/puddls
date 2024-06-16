import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:provider/provider.dart';
import 'package:puddls/services/maps/location_wrapper.dart';
import 'package:puddls/services/maps/places_wrapper.dart';

class PlaceLookup extends StatefulWidget
{
  final AutocompleteOnSelected<Place>? onSelected;
  final String label;
  final bool showMap;
  const PlaceLookup({super.key, required this.onSelected, required this.label, this.showMap = true});

  @override
  State<PlaceLookup> createState() => _PlaceLookup(); 
}

class _PlaceLookup extends State<PlaceLookup>
{
  Place? position;
  
  final Completer<maps.GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    final PlacesWrapper places = Provider.of<PlacesWrapper>(context, listen: false);
    final LocationWrapper location = context.watch<LocationWrapper>();

    return Column(
      children: 
      [
        Autocomplete<AutocompletePrediction>(
          optionsBuilder: (TextEditingValue textEditingValue) async
          {
            Iterable<AutocompletePrediction> options = [];
            if(textEditingValue.text != "")
            {
              final response = await places.places.findAutocompletePredictions(textEditingValue.text);
              options = response.predictions;
            }

            return options;
          },
          displayStringForOption: (option) 
          {
            return option.fullText;
          },
          onSelected: (option) async
          {
            var place = await places.places.fetchPlace(option.placeId, fields: [PlaceField.Location]);
            position = place.place!;

            if(widget.showMap){
              maps.GoogleMapController googleMapController = await _controller.future;
              googleMapController.animateCamera
              (
                maps.CameraUpdate.newCameraPosition
                (
                  maps.CameraPosition
                  (
                    target: maps.LatLng(position!.latLng!.lat, position!.latLng!.lng),
                    zoom: 13
                  )
                )
              );
            }

            setState(() {});
            widget.onSelected!(position!);
          },
          fieldViewBuilder:(context, textEditingController, focusNode, onFieldSubmitted) 
          {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              onFieldSubmitted: (str) => onFieldSubmitted(),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                labelText: widget.label,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            );
          },
        ),
        Visibility
        (
          visible: widget.showMap,
          child: const SizedBox(height: 5,),
        ),
        Visibility
        (
          visible: widget.showMap,
          child: SizedBox
          (
            height: 200,
            child: location.currentLocation == null ?
              const Center(child: CircularProgressIndicator()) :
              ClipRRect
              (
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30), 
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                child: maps.GoogleMap
                  (
                    initialCameraPosition: maps.CameraPosition
                    (
                      target: position == null ? 
                        maps.LatLng(location.currentLocation!.latitude!, location.currentLocation!.longitude!) : 
                        maps.LatLng(position!.latLng!.lat, position!.latLng!.lng),
                      zoom: 13
                    ),
                    markers: {
                      maps.Marker
                      (
                        markerId: const maps.MarkerId("Start"),
                        position: position == null ? 
                          maps.LatLng(location.currentLocation!.latitude!, location.currentLocation!.longitude!) : 
                          maps.LatLng(position!.latLng!.lat, position!.latLng!.lng)
                      )
                    },
                    onMapCreated: (mapController) => _controller.complete(mapController),
                  ),
              ),
          ),
        )
      ]
    );
  }
}