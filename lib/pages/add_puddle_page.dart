import 'package:flutter/material.dart';

class AddPuddlePage extends StatefulWidget
{
  const AddPuddlePage({super.key});

  @override
  State<AddPuddlePage> createState() => _AddPuddlePage();
}

class _AddPuddlePage extends State<AddPuddlePage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Puddl"),
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("Todo: Make puddl form")
            ],
          )
        )
      )
    );
  }
}