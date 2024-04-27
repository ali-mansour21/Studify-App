import 'package:flutter/material.dart';
import 'package:mobile/widgets/customtextformfield.dart';
import 'package:mobile/widgets/mainbutton.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const FlutterLogo(size: 80),
                          const SizedBox(height: 30),
                          const Text(
                            "Let’s Get Started",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          const CustomTextFormField(
                              labelText: "Name", iconData: Icons.person),
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
                              onPressed: () {}),
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
                    const Spacer(), // Use another Spacer to push the Card to the middle
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
