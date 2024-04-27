import 'package:flutter/material.dart';
import 'package:mobile/widgets/auth_layout.dart';
import 'package:mobile/widgets/customtextformfield.dart';
import 'package:mobile/widgets/mainbutton.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      imagePath:
          'assets/Studify-logo.png', // Update with your actual logo image path
      title: "Let’s Get Started",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CustomTextFormField(
              labelText: "Name",
              iconData: Icons.person,
            ),
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
              buttonColor: Colors.black45,
              buttonText: "Sign up",
              onPressed: () {
                // Insert sign-up logic here
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text(
                "Have an account? LogIn",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
