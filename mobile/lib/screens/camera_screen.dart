import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/widgets/mainbutton.dart';

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;
  const CameraScreen({super.key, required this.cameraController});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.cameraController;
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      final XFile image = await _controller.takePicture();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                currentFocus.unfocus();
              },
              child: AlertDialog(
                title: const Text(
                  "Create a new material",
                  style: TextStyle(fontSize: 18),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      const SizedBox(
                        width: 300,
                        height: 45,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Material',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        width: 300,
                        height: 45,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Topic',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 300,
                        height: 45,
                        child: MainButton(
                            buttonColor: const Color(0xFF3786A8),
                            buttonText: "Create",
                            onPressed: () {}),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Take a photo for your summary",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CameraPreview(_controller),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                  elevation: MaterialStatePropertyAll(0)),
              onPressed: _takePicture,
              child: const Icon(
                Icons.camera,
                size: 50,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
