import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xFFFFFFFF)),
            ),
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(46, 0, 0, 0),
            )),
        elevation: 0,
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xFF3786A8), Color(0xFF3786A8)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
        ),
      ),
    );
  }
}
