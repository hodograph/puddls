import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class PlacesWrapper extends ChangeNotifier
{
  final remoteConfig = FirebaseRemoteConfig.instance;
  late FlutterGooglePlacesSdk places;

  PlacesWrapper()
  {
    initializePlaces();
  }

  void initializePlaces() async
  {
    await remoteConfig.fetchAndActivate();
    remoteConfig.onConfigUpdated.listen((event) async
    {
      await remoteConfig.activate();
      updatePlaces();
    });

    updatePlaces();
  }

  void updatePlaces()
  {
    // The API keys are stored in firebase. They'll still be accessible within the app but at least they're not stored in git.
    String? apiKey;
    if(Platform.isAndroid)
    {
      apiKey = remoteConfig.getString("maps_places_android");
    }

    places = FlutterGooglePlacesSdk(apiKey!);
    notifyListeners();
  }
}