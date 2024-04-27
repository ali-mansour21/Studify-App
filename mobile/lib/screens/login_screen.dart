import 'package:flutter/material.dart';
import 'package:mobile/widgets/auth_layout.dart';
import 'package:mobile/widgets/customtextformfield.dart';
import 'package:mobile/widgets/mainbutton.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AuthLayout(
        imagePath: 'assets/Studify-logo.png', // Path to logo image
        title: "Welcome Back", // Page title
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CustomTextFormField(
                labelText: "Email",
                iconData: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const CustomTextFormField(
                labelText: "Password",
                iconData: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              MainButton(
                  buttonColor: Colors.black,
                  buttonText: "Log in",
                  onPressed: () {}),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'New user? Sign Up',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}
