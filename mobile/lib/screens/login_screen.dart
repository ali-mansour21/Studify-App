import 'package:flutter/material.dart';
import 'package:mobile/widgets/auth_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child:   Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Image.asset(
              'assets/Studify-logo.png',
              width: 270,
              height: 230,
            ),
            const SizedBox(height: 20),
            const Text('Welcome Back', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            const ElevatedButton(
              onPressed: null,
              child: Text('Login'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                'New user? Sign Up',
                style: TextStyle(color: Colors.black),
              ),
            );
          ]),
        ), imagePath: 'assets/Studify-logo.png', title: "Welcome Back"),
  }
}
