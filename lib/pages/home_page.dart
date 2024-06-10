import 'package:flutter/material.dart';
import 'package:puddls/pages/account_page.dart';
import 'package:puddls/pages/notifications_page.dart';
import 'package:puddls/pages/puddl_page.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{

  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      bottomNavigationBar: NavigationBar(onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(icon: Icon(Icons.notifications), label: 'Notifications'),
        NavigationDestination(icon: Icon(Icons.car_rental), label: 'Puddl'),
        NavigationDestination(icon: Icon(Icons.account_circle), label: 'Me')
      ]),
      body: <Widget>[
        const NotificationsPage(),
        const PuddlPage(),
        const AccountPage()
      ][currentPageIndex]
    );
  }
}