import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puddls/services/auth/auth_service.dart';

class AccountPage extends StatefulWidget
{
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage>
{
  void onPressed()
  {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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

                const SizedBox(height: 25,),
                FilledButton(
                  onPressed: onPressed, 
                  child: const Text("Log Out")
                )
              ],
            )
          )
        )
      )
    );
  }
}