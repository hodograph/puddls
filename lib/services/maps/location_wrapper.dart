import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationWrapper extends ChangeNotifier
{
  LocationData? currentLocation;
  final Location _location = Location();

  LocationWrapper()
  {
    updateCurrentLocation();
  }

  Future<void> updateCurrentLocation() async
  {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }

    if(serviceEnabled)
    {
      permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) 
      {
        permissionGranted = await _location.requestPermission();
      }

      if(permissionGranted != PermissionStatus.denied)
      {
        currentLocation = await _location.getLocation();
      }
    }

    notifyListeners();
  }
}