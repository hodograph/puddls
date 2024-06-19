import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:provider/provider.dart';
import 'package:puddls/components/date_time_selector.dart';
import 'package:puddls/components/place_lookup.dart';
import 'package:puddls/components/spin_edit.dart';
import 'package:puddls/services/maps/location_wrapper.dart';
import 'package:puddls/services/maps/places_wrapper.dart';

class DrivePuddlForm extends StatefulWidget
{
  const DrivePuddlForm({super.key});

  @override
  State<DrivePuddlForm> createState() => _DrivePuddlForm();
}

class _DrivePuddlForm extends State<DrivePuddlForm>
{
  Place? origin;
  
  Place? destination;

  DateTime leaveTime = DateTime.now();

  DateTime minSelectableRange = DateTime.now();
  DateTime maxSelectableRange = DateTime.now().add( const Duration(days: 365));

  bool allDay = false;

  String? timezone;
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<PlacesWrapper>(create: (_) => PlacesWrapper()),
        ListenableProvider<LocationWrapper>(create: (_) => LocationWrapper()),
      ],
      builder: (context, widget) => SafeArea
      (
        child: Scaffold
        (
          appBar: AppBar
          (
            title: const Text("Start Drive"),
            centerTitle: true,
          ),
          body: SingleChildScrollView
          (
            child:  Padding
            (
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  // Start
                  PlaceLookup
                  (
                    onSelected: (option) async
                    {
                      origin = option;
                    },
                    label: "Origin",
                  ),

                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 15),

                  // Destination
                  PlaceLookup
                  (
                    onSelected: (option) async
                    {
                      destination = option;
                    },
                    label: "Destination",
                  ),

                  const SizedBox(height: 15),
                  const Divider(),

                  Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: 
                    [
                      const Text("Departure Time", style: TextStyle(fontSize: 18),),
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
                    onChange: (value) => setState(() => leaveTime = value),
                    defaultTime: leaveTime,
                  ),

                  const Divider(),

                  const Text("Luggage Space", style: TextStyle(fontSize: 18)),

                  const SizedBox(height: 15),
                  SpinEdit
                  (
                    onChange: (value) {}, 
                    label: "Personal items",
                    minValue: 0,
                  ),

                  const SizedBox(height: 15),
                  SpinEdit
                  (
                    onChange: (value) {}, 
                    label: "Carry-ons",
                    minValue: 0,
                  ),

                  const SizedBox(height: 15),
                  SpinEdit
                  (
                    onChange: (value) {}, 
                    label: "Checked Bags",
                    minValue: 0,
                  ),

                  const Divider(),

                  const Text("Passengers", style: TextStyle(fontSize: 18)),

                  const SizedBox(height: 15),
                  SpinEdit
                  (
                    onChange: (value) {}, 
                    label: "Passengers",
                    minValue: 1,
                    initialValue: 1,
                  ),

                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 
                    [
                      FilledButton
                      (
                        child: const Row
                        (
                          children: 
                          [ 
                            Text("Pick Route"),
                            Icon(Icons.navigate_next_rounded)
                          ]
                        ),
                        onPressed: () {},
                      ),
                    ]
                  )
                ],
              )
            )
          )
        )
      )
    );
  }
}