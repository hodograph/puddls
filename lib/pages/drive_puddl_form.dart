import 'package:flutter/material.dart';

class DrivePuddlForm extends StatefulWidget
{
  const DrivePuddlForm({super.key});

  @override
  State<DrivePuddlForm> createState() => _DrivePuddlForm();
}

class _DrivePuddlForm extends State<DrivePuddlForm>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drive"),
        centerTitle: true,
      ),
    );
  }
}