import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puddls/components/place_lookup.dart';
import 'package:puddls/services/maps/location_wrapper.dart';
import 'package:puddls/services/maps/places_wrapper.dart';
import 'package:time_range_picker/time_range_picker.dart';

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
  DateTime maxSelectableRange = DateTime.now().add( const Duration(days: 365));

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

                  // Destination
                  PlaceLookup(
                    onSelected: (option) async
                    {
                      end = option;
                    },
                    label: "Dropoff",
                  ),
                  const SizedBox(height: 25),

                  // Pickup time
                  // Row
                  // (
                  //   children: 
                  //   [
                  //     Text(DateFormat("MMMM dd").format(beginRange)),
                  //     const Icon(Icons.arrow_forward_rounded),
                  //     Text(DateFormat("MMMM dd").format(endRange)),
                  //   ],
                  // ),
                  // // CalendarDatePicker2WithActionButtons
                  // // (
                  // //   value: const[],
                  // //   config: CalendarDatePicker2WithActionButtonsConfig(
                  // //     calendarType: CalendarDatePicker2Type.range
                  // //   )
                  // // ),
                  // ElevatedButton
                  // (
                  //   onPressed: () async{
                  //     TimeRange? result = await showTimeRangePicker
                  //     (
                  //       context: context,
                  //       use24HourFormat: false,
                  //       strokeColor: Theme.of(context).indicatorColor,
                  //       handlerColor: Theme.of(context).indicatorColor,
                  //       labels: [
                  //         "12 am",
                  //         "3 am",
                  //         "6 am",
                  //         "9 am",
                  //         "12 pm",
                  //         "3 pm",
                  //         "6 pm",
                  //         "9 pm"
                  //       ].asMap().entries.map((e) {
                  //         return ClockLabel.fromIndex(
                  //             idx: e.key, length: 8, text: e.value);
                  //       }).toList()
                  //     );
                  //   },
                  //   child: const Text("Set Time")
                  // )
                ],
              )
            )
          )
        )
      )
    );
  }
}