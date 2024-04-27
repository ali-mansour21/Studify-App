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
    // Calculate the screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Make sure the scaffold resizes when keyboard is shown
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          // This enables scrolling
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height -
                  MediaQuery.of(context)
                      .viewInsets
                      .bottom, // Adjust the height according to the keyboard presence
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    imagePath,
                    width: 270,
                    height: 230,
                  ),
                  const SizedBox(height: 20),
                  Text(title, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  child, // The child passed in as parameter
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
