import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final String imagePath;
  final String title;
  const AuthLayout({
    super.key,
    required this.child,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Card(
          color: const Color(0xFFFFFFFF),
          margin: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                imagePath,
                width: 270,
                height: 230,
              ),
              const SizedBox(height: 20),
              Text(title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              child, // Insert the custom child widget here
            ],
          ),
        ),
      ),
    );
  }
}
