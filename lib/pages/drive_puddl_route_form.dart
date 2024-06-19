import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:puddls/models/drive.dart';
import 'package:puddls/services/maps/polyline_wrapper.dart';

class DrivePuddlRouteForm extends StatefulWidget
{
  final Drive drive;
  const DrivePuddlRouteForm({super.key, required this.drive});

  @override
  State<StatefulWidget> createState() => _DrivePuddlRouteForm();
}

class _DrivePuddlRouteForm extends State<DrivePuddlRouteForm>
{
  Map<PolylineId, Polyline> polylines = {};
  final PolylineWrapper _polylineWrapper = PolylineWrapper();

  
  Map<PolylineId, PolylineResult> polylineInfos = {};
  
  final List<String> ids = ["A", "B", "C", "D"];

  Drive? drive;

  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;

  late PolylineId selectedRoute;

  @override
  void initState() 
  {
    drive = widget.drive;
    selectedRoute = PolylineId(ids[0]);
    super.initState();
  }

  Future _populateRoutes() async
  {
    // Only query if its the first state update.
    if(polylines.isEmpty)
    {
      List<PolylineResult> routes = await _polylineWrapper.getRouteWithAlternatives
      (
        widget.drive.originLat, 
        widget.drive.originLng,
        widget.drive.destinationLat,
        widget.drive.destinationLng
      );

      int index = 0;
      for(PolylineResult route in routes)
      {
        if(route.points.isNotEmpty)
        {
          List<LatLng> points = <LatLng>[];
          for(PointLatLng point in route.points)
          {
            points.add(LatLng(point.latitude, point.longitude));
          }

          PolylineId id = PolylineId(ids[index]);
          polylines[id] = Polyline(polylineId: id,
            color: Colors.grey,
            points: points,
            width: 5);

          polylineInfos[id] = route;

          index++;
          if(index >= ids.length)
          {
            break;
          }
        }
      }
      if(mounted)
      {
        setState(() {});
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);

    List<LatLng> coords = <LatLng>[];
    coords.add(LatLng(drive!.originLat, drive!.originLng));
    coords.add(LatLng(drive!.destinationLat, drive!.destinationLng));

    for(Polyline polyline in polylines.values)
    {
      coords.addAll(polyline.points);
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(boundsFromLatLngList(coords), 100));
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  Set<Polyline> getPolylines()
  {
    List<Polyline> polylineList = polylines.values.toList();

    if(polylineList.isNotEmpty)
    {
      // remove selected route and readd to change properties like color and zindex.
      polylineList.removeWhere((x) => x.polylineId == selectedRoute);
      Polyline selectedPolyline = polylines[selectedRoute]!;
      polylineList.add(Polyline
      (
        polylineId: selectedPolyline.polylineId,
        color: Colors.blue,
        points: selectedPolyline.points,
        width: 5,
        zIndex: ids.length
      )); 
    }

    return Set.from(polylineList);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea
    (
      child: Scaffold
      (
        appBar: AppBar
        (
          title: const Text("Select Route"),
          centerTitle: true,
        ),
        body: 
        MultiProvider
        (
          providers: 
          [
            ListenableProvider<PolylineWrapper>(create: (_) => PolylineWrapper()),
          ],
          builder: (context, widget)
          {
            if(context.watch<PolylineWrapper>().isReady())
            {
              _populateRoutes();

              return Column
              (
                children: 
                [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .60,
                    child:GoogleMap
                    (
                      onMapCreated: (controller) => _onMapCreated(controller),
                      initialCameraPosition: CameraPosition
                      (
                        target: LatLng(drive!.originLat, drive!.originLng),
                        zoom: 13
                      ),
                      markers: 
                      {
                        Marker
                        (
                          markerId: const MarkerId("origin"),
                          position: LatLng(drive!.originLat, drive!.originLng)
                        ),
                        Marker
                        (
                          markerId: const MarkerId("destination"),
                          position: LatLng(drive!.destinationLat, drive!.destinationLng)
                        )
                      },
                      polylines: getPolylines(),
                    )
                  ),
                  Expanded
                  (
                    child: ListView.builder
                    (
                      scrollDirection: Axis.vertical,
                      itemCount: polylines.length,
                      itemBuilder: (context, index)
                      {
                        PolylineId id = PolylineId(ids[index]);
                        Polyline polyline = polylines[id]!;
                        PolylineResult polylineInfo = polylineInfos[id]!;

                        return ListTile
                        (
                          selectedTileColor: Theme.of(context).focusColor,
                          selected: selectedRoute == id,
                          onTap: () => setState(() {
                            selectedRoute = id;
                          }),
                          title: Text(polyline.polylineId.value),
                          subtitle: Row
                          (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: 
                            [
                              Text("Distance: ${polylineInfo.distance}"),
                              Text("Time: ${polylineInfo.duration}")
                            ],
                          ),
                        );
                      }
                    )
                  )
                ],
              );
            }
            else
            {
              return const Center( child: CircularProgressIndicator());
            }
          }
        )
      )
    );
  }
}