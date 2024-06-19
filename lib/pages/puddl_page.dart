import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:puddls/pages/drive_puddl_form.dart';
import 'package:puddls/pages/ride_puddl_form.dart';

class PuddlPage extends StatefulWidget
{
  const PuddlPage({super.key});

  @override
  State<PuddlPage> createState() => _PuddlePage();
}

class _PuddlePage extends State<PuddlPage>
{
  final isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.drive_eta),
                text: "Driving",
              ),
              Tab(
                icon: Icon(Icons.people),
                text: "Riding"
              ),
              Tab(
                icon: Icon(Icons.remove_red_eye),
                text: "Watching"
              )
            ],
          )
        ),
        body: const TabBarView(
          children: [
            Center( child: Text("You are not currently hosting any puddls")),
            Center( child: Text("You are not currently planning to ride in any puddls")),
            Center( child: Text("You are not currently watching any puddls"))
          ],
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          openCloseDial: isDialOpen,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.drive_eta, size: 30,),
              label: "Drive",
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DrivePuddlForm())
              ),
            ),
            SpeedDialChild(
              child: const Icon(Icons.people, size: 30,),
              label: "Ride",
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RidePuddlForm())
              ),
            ),
          ],
        ),
      ),
    );
  }
}