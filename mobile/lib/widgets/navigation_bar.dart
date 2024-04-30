import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/camera_screen.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  void _onItemTapped(int index) {
    widget.onItemSelected(index);
    switch (index) {
      case 0:
        // Navigate to home
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        _openCamera(context);
        break;
      case 2:
        // Navigate to profile
        Navigator.pushNamed(context, '/profile');
        break;
      default:
        break;
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
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
