import 'package:flutter/material.dart';
import 'package:puddls/pages/add_puddle_page.dart';

class PuddlPage extends StatefulWidget
{
  const PuddlPage({super.key});

  @override
  State<PuddlPage> createState() => _PuddlePage();
}

class _PuddlePage extends State<PuddlPage>
{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.drive_eta),
                text: "Host",
              ),
              Tab(
                icon: Icon(Icons.safety_divider),
                text: "Rider"
              )
            ],
          )
        ),
        body: const TabBarView(
          children: [
            Center( child: Text("You are not currently hosting any puddls")),
            Center( child: Text("You are not currently planning to ride in any puddls"))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddPuddlePage())
          ),
          child: const Icon(Icons.add)
        ),
      ),
    );
  }
}