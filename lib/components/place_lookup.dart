import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:puddls/services/maps/location_wrapper.dart';
import 'package:puddls/services/maps/places_wrapper.dart';

class PlaceLookup extends StatefulWidget
{
  final ValueChanged<Place?> onSelected;
  final String label;
  const PlaceLookup({super.key, required this.onSelected, required this.label});

  @override
  State<PlaceLookup> createState() => _PlaceLookup(); 
}

class _PlaceLookup extends State<PlaceLookup>
{
  Place? position;
  
  final Completer<maps.GoogleMapController> _controller = Completer();
  
  bool isOpen = false;

  String? _darkMapStyle;

  @override
  void initState() 
  {
    super.initState();
    _loadMapStyle();
  }

  Future _loadMapStyle() async
  {
    _darkMapStyle = await rootBundle.loadString("assets/json/dark_mode_style.json");
  }

  Future<void> updateValueChanged(LocationData currentLocation) async
  {
    maps.GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera
    (
      maps.CameraUpdate.newCameraPosition
      (
        maps.CameraPosition
        (
          target: maps.LatLng
          (
            position?.latLng?.lat ?? currentLocation.latitude!,
            position?.latLng?.lng ?? currentLocation.longitude!),
          zoom: 13
        )
      )
    );

    setState(() {});
    widget.onSelected(position);
  }

  @override
  Widget build(BuildContext context) {
    final PlacesWrapper places = Provider.of<PlacesWrapper>(context, listen: false);
    final LocationWrapper location = context.watch<LocationWrapper>();
    return ExpansionPanelList
    (
      expansionCallback: (panelIndex, expanded) => setState((){ isOpen = expanded; }),
      children: [
        ExpansionPanel
        (
          headerBuilder: (context, isOpen)
          {
            return Autocomplete<AutocompletePrediction>
            (
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
                position = place.place;

                updateValueChanged(location.currentLocation!);
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
                    hintText: "Current Location",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: IconButton
                    (
                      onPressed: () 
                      {
                        textEditingController.clear();
                        position = null;
                        updateValueChanged(location.currentLocation!);
                      },
                      icon: const Icon(Icons.clear),

                    )
                  ),
                );
              },
            );
          }, 
          body: SizedBox
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
                    onMapCreated: (mapController) 
                    {
                       _controller.complete(mapController);
                       if(Theme.of(context).brightness == Brightness.dark)
                       {
                          mapController.setMapStyle(_darkMapStyle);
                       }
                    },
                  ),
              ),
          ),
          isExpanded: isOpen
        ),
      ]
    );
  }
}