import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/auth_api_service.dart';
import 'package:mobile/widgets/mainbutton.dart';

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;
  const CameraScreen({super.key, required this.cameraController});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<dynamic> categoryData = [];
  bool isLoading = true;
  final AuthApiService _apiService = AuthApiService();
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
      fetchCategories();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchCategories() async {
    try {
      final List<dynamic> categories = await _apiService.getAllCategories();
      print(categories);
      setState(() {
        categoryData = categories;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load categories: $e')));
    }
  }

  Future<void> _takePicture() async {
    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      final XFile image = await _controller.takePicture();
      _showCaptureOptions();
    } catch (e) {
      print(e);
    }
  }

  void _showCaptureOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: const Text('Add New Material'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showNewMaterialForm();
                  },
                ),
                ListTile(
                  title: const Text('Add to Existing Material'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showExistingMaterialForm();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _showNewMaterialForm() {}
  void _showExistingMaterialForm() {}
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
