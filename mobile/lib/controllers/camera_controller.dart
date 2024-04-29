import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
