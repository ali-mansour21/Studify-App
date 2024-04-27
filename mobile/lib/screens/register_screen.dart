import 'package:flutter/material.dart';

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
                          const SizedBox(height: 20),
                          const Text(
                            "Let’s Get Started",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                prefixIcon: Icon(
                                  Icons.person,
                                ),
                              ),
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black45, width: 2.0),
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Keeps the border radius consistent when focused
                                ),
                                prefixIcon: const Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () {
                                // Sign up button logic
                              },
                              child: const Text("Sign up")),
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
