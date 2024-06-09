import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puddls/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget{
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
{

  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  void signUp() async
  {
    if(passwordController.text != passwordConfirmationController.text)
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
    }
    else
    {
      final authService = Provider.of<AuthService>(context, listen: false);
      try
      {
        await authService.signUpWithEmailAndPassword(emailController.text, passwordController.text);
      }
      catch(e) 
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
  
  @override
  Widget build(BuildContext context){

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                // Login Icon
                Icon(Icons.login,
                  size: 80),

                const SizedBox(height: 25),

                // Header message  
                const Text("Create Account",
                  style: TextStyle(fontSize: 16)),

                const SizedBox(height: 25),

                // Email field
                TextField(
                  controller: emailController, 
                  decoration: InputDecoration(hintText: 'Email'),
                  obscureText: false),

                const SizedBox(height: 10),

                // Password field
                TextField(
                  controller: passwordController, 
                  decoration: InputDecoration(hintText: 'Password'),
                  obscureText: true),

                const SizedBox(height: 10),

                // Password field
                TextField(
                  controller: passwordConfirmationController, 
                  decoration: InputDecoration(hintText: 'Confirm Password'),
                  obscureText: true),

                const SizedBox(height: 25),
                
                // Sign up button
                FilledButton(
                  onPressed: signUp,
                  child: Text('Sign Up')
                ),
                
                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member?"),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: widget.onTap, 
                      child: Text("Login now")
                    )
                  ],
                )

                // Register button
              ],
            ),
          ),
        ),
      )
    );
  }
}