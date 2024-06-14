import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puddls/models/user.dart' as puddle_user;
import 'package:puddls/services/auth/auth_service.dart';
import 'package:puddls/services/firestore/user_firestore.dart';

class AccountPage extends StatefulWidget
{
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage>
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserFirestoreService _userFirestoreService = UserFirestoreService();
  late String _currentUserId;

  @override
  void initState() 
  {
    super.initState();
    _currentUserId = _firebaseAuth.currentUser!.uid;
  }

  void onPressed()
  {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  void updateName(puddle_user.User user)
  {
    final displayNameController = TextEditingController(text: user.displayName);
    showDialog
    (
      context: context, 
      builder: (context) =>
        AlertDialog(
          content: TextField(
            controller: displayNameController,
            decoration: const InputDecoration(hintText: 'Full Name'),
          ),
          actions: [
            ElevatedButton
            (
              onPressed: () 
              {
                user.displayName = displayNameController.text;
                _userFirestoreService.addOrUpdateUser(user);
                Navigator.pop(context);
              }, 
              child: const Text("Save")
            )
          ],
        )
    );
  }

  Widget _buildFromUser(puddle_user.User user)
  {
    return SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [

                  const SizedBox(height: 25,),
                  const Icon(
                    Icons.account_circle,
                    size: 80,
                  ),

                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Invisible button for consistent spacing
                      const IconButton
                      (
                        onPressed: null, 
                        icon: Icon(Icons.edit),
                        disabledColor: Colors.transparent,
                        enableFeedback: false,
                      ),
                      Text(user.displayName ?? user.email),
                      IconButton
                      (
                        onPressed: () => updateName(user), 
                        icon: const Icon(Icons.edit)
                      )
                    ],
                  ),

                  const SizedBox(height: 25,),
                  FilledButton(
                    onPressed: onPressed, 
                    child: const Text("Log Out")
                  )
                ],
              )
            )
          )
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>
      (
        stream: _userFirestoreService.listenToUser(_currentUserId),
        builder: (context, snapshot) 
        {
          Widget widget;
          if(snapshot.hasError)
          {
            widget = const Center(child: Text("Something went wrong :/"));
          }
          else if(snapshot.connectionState == ConnectionState.waiting)
          {
            widget = const Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasData)
          {
            widget = _buildFromUser(snapshot.data!.data() as puddle_user.User);
          }
          else
          {
            widget = const Center(child: Text("Something went wrong :/"));
          }
          return widget;
        }
      )
    );
  }
}