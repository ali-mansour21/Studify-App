import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:mobile/screens/camera_screen.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  const CustomNavigationBar(
      {super.key, required this.currentIndex, required this.onItemSelected});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  void _onItemTapped(int index) {
    widget.onItemSelected(index);
  }

  Future<void> _openCamera(BuildContext context) async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    // You can now initialize the camera and start the camera stream.
    // Usually, you would navigate to a new screen where you can display
    // the camera feed.
    final cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await cameraController.initialize();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(cameraController: cameraController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
              color: Colors.white,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF3786A8)), // Use the color you want here
              ),
              onPressed: () => _openCamera(context),
              icon: const Icon(
                Icons.add,
                size: 30,
              )),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 30),
          label: '',
        ),
      ],
      currentIndex: widget.currentIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}
