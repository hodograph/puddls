import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class PolylineWrapper extends ChangeNotifier
{
  final remoteConfig = FirebaseRemoteConfig.instance;
  final _polyline = PolylinePoints();

  String? _apiKey;

  PolylineWrapper()
  {
    initializePolyline();
  }

  void initializePolyline() async
  {
    await remoteConfig.fetchAndActivate();
    remoteConfig.onConfigUpdated.listen((event) async
    {
      await remoteConfig.activate();
      updatePolyline();
    });

    updatePolyline();
  }

  void updatePolyline()
  {
    // The API keys are stored in firebase. They'll still be accessible within the app but at least they're not stored in git.
    _apiKey = remoteConfig.getString("maps_directions");

    notifyListeners();
  }

  bool isReady()
  {
    return _apiKey != null;
  }

  Future<List<PolylineResult>> getRouteWithAlternatives(double originLat, double originLng, double destLat, double destLng) async
  {
    List<PolylineResult> result = <PolylineResult>[];

    if(_apiKey != null)
    {
      result = await _polyline.getRouteWithAlternatives(request: PolylineRequest(apiKey: _apiKey!,
        origin: PointLatLng(originLat, originLng),
        destination: PointLatLng(destLat, destLng),
        mode: TravelMode.driving,
        wayPoints: const [], 
        avoidHighways: false, 
        avoidTolls: false, 
        avoidFerries: true, 
        optimizeWaypoints: false, 
        alternatives: true));
    }

    return result;
  }
}