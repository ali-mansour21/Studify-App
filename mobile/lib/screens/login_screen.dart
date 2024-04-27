import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(16.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const FlutterLogo(size: 80),
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
            )
          ]),
        ),
      ),
    );
  }
}
