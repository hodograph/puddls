import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:provider/provider.dart';
import 'package:puddls/components/date_time_selector.dart';
import 'package:puddls/components/place_lookup.dart';
import 'package:puddls/components/spin_edit.dart';
import 'package:puddls/models/ride.dart';
import 'package:puddls/services/maps/location_wrapper.dart';
import 'package:puddls/services/maps/places_wrapper.dart';

class RidePuddlForm extends StatefulWidget
{
  const RidePuddlForm({super.key});

  @override
  State<RidePuddlForm> createState() => _RidePuddlForm();
}

class _RidePuddlForm extends State<RidePuddlForm>
{
  Place? origin;
  
  Place? destination;

  DateTime beginRange = DateTime.now();
  DateTime endRange = DateTime.now().add( const Duration(minutes: 15));

  DateTime minSelectableRange = DateTime.now();
  DateTime maxSelectableRange = DateTime.now().add( const Duration(days: 365));

  int personalItems = 0;
  int carryOns = 0;
  int checkedBags = 0;
  int passengers = 1;

  bool allDay = false;

  String? timezone;

  void submitRide(LocationWrapper location)
  {
    if(beginRange.isBefore(endRange))
    {
      if(destination != null)
      {
        if(destination != origin)
        {
          // Default origin lat/lng to current location.
          double originLat = location.currentLocation!.latitude!;
          double originLng = location.currentLocation!.longitude!;

          // If origin is not null that means there is a different start location than the current user location.
          if(origin != null)
          {
            originLat = origin!.latLng!.lat;
            originLng = origin!.latLng!.lng;
          }

          Ride ride = Ride
          (
            destinationLat: destination!.latLng!.lat,
            destinationLng: destination!.latLng!.lng,
            originLat: originLat,
            originLng: originLng,
            rider: FirebaseAuth.instance.currentUser!.uid,
            startPickupRange: beginRange,
            endPickupRange: allDay ? endRange.add(const Duration(hours: 24)) : endRange,
            personalItems: personalItems,
            carryOns: carryOns,
            checkedBags: checkedBags,
            passengers: passengers
          );

          // TODO: submit ride.
        }
        else 
        {
          // Alert destination and origin are the same place.
          ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Warning: Pickup and Dropoff location are the same place.")));
        }
      }
      else
      {
        // Alert destination is current location.
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Warning: Dropoff location is your current location.")));
      }
    }
    else
    {
      // Alert range is invalid.
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Warning: Pickup range end time is before the start.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<PlacesWrapper>(create: (_) => PlacesWrapper()),
        ListenableProvider<LocationWrapper>(create: (_) => LocationWrapper()),
      ],
      builder: (context, widget) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Start Ride"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  // Start
                  PlaceLookup(
                    onSelected: (option) async
                    {
                      origin = option;
                    },
                    label: "Pickup",
                  ),

                  const SizedBox(height: 15),

                  // Destination
                  PlaceLookup(
                    onSelected: (option) async
                    {
                      destination = option;
                    },
                    label: "Dropoff",
                  ),

                  const SizedBox(height: 10),
                  const Divider(),

                  Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: 
                    [
                      const Text("Pickup Range", style: TextStyle(fontSize: 18),),
                      Row(
                        children: [
                          const Text("All-day", style: TextStyle(fontSize: 18),),
                          Switch
                          (
                            value: allDay, 
                            onChanged: (value) => setState(() 
                            {
                              allDay = value;
                            })
                          )
                        ],
                      )
                    ],
                  ),
                  DateTimeSelector
                  (
                    allDay: allDay,
                    onChange: (value) => setState(() => beginRange = value),
                    defaultTime: beginRange,
                  ),
                  DateTimeSelector
                  (
                    allDay: allDay,
                    onChange: (value) => setState(() => endRange = value),
                    defaultTime: endRange,
                  ),

                  const Divider(),

                  const Text("Luggage", style: TextStyle(fontSize: 18)),

                  const SizedBox(height: 15),
                  SpinEdit
                  (
                    onChange: (value) => personalItems = value,
                    label: "Personal item",
                    minValue: 0,
                    initialValue: personalItems,
                  ),

                  const SizedBox(height: 15),
                  SpinEdit
                  (
                    onChange: (value) => carryOns = value, 
                    label: "Carry-on",
                    minValue: 0,
                    initialValue: carryOns,
                  ),

                  const SizedBox(height: 15),
                  SpinEdit
                  (
                    onChange: (value) => checkedBags = value, 
                    label: "Checked Bag",
                    minValue: 0,
                    initialValue: checkedBags,
                  ),

                  const SizedBox(height: 10),
                  const Divider(),

                  const Text("Passengers", style: TextStyle(fontSize: 18)),

                  const SizedBox(height: 15),
                  SpinEdit
                  (
                    onChange: (value) => passengers = value, 
                    label: "Passengers",
                    minValue: 1,
                    initialValue: passengers,
                  ),

                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 
                    [
                      FilledButton
                      (
                        child: const Text("Submit"),
                        onPressed: () => submitRide(context.read<LocationWrapper>()),
                      ),
                    ]
                  )
                  
                ],
              )
            )
          ),
        )
      )
    );
  }
}