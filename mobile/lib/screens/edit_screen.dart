import 'package:flutter/material.dart';
import 'package:mobile/widgets/profile_screen_layout.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3786A8),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3786A8), Color(0xFF3786A8)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: ProfileLayout(
        height: 600,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const Positioned(
                top: -65,
                left: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 60,
                  child: Text('AM',
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                ),
              ),
              Positioned(
                top: -65,
                left: 0,
                right: 0,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
