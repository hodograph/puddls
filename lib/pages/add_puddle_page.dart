import 'package:flutter/material.dart';

class AddPuddlePage extends StatefulWidget
{
  const AddPuddlePage({super.key});

  @override
  State<AddPuddlePage> createState() => _AddPuddlePage();
}

class _AddPuddlePage extends State<AddPuddlePage>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Puddl"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField
                (
                  items: const [
                    DropdownMenuItem(child: Text("Host")),
                    DropdownMenuItem(child: Text("Rider")),
                  ], 
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    helperText: "puddl type"
                  ),
                )
              ],
            )
          )
        )
      )
    );
  }
}