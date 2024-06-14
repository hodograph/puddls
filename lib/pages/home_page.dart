import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puddls/pages/account_page.dart';
import 'package:puddls/pages/notifications_page.dart';
import 'package:puddls/pages/puddl_page.dart';

class HomePage extends StatefulWidget{
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{

  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
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