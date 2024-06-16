import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:provider/provider.dart';
import 'package:puddls/components/date_time_selector.dart';
import 'package:puddls/components/place_lookup.dart';
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
  Place? start;
  
  Place? end;

  DateTime beginRange = DateTime.now();
  DateTime endRange = DateTime.now().add( const Duration(minutes: 15));

  DateTime minSelectableRange = DateTime.now();
  DateTime maxSelectableRange = DateTime.now().add( const Duration(days: 365));

  bool allDay = false;

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
                      start = option;
                    },
                    label: "Pickup",
                  ),
                  const SizedBox(height: 25),
                  const Divider(),

                  // Destination
                  PlaceLookup(
                    onSelected: (option) async
                    {
                      end = option;
                    },
                    label: "Dropoff",
                  ),
                  const SizedBox(height: 25),

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
                    onChange: (value) => beginRange = value,
                    defaultTime: beginRange,
                  ),
                  DateTimeSelector
                  (
                    allDay: allDay,
                    onChange: (value) => endRange = value,
                    defaultTime: endRange,
                  ),
                ],
              )
            )
          )
        )
      )
    );
  }
}