import 'dart:html';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/categories/category_model.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/providers/material_provider.dart';
import 'package:mobile/services/auth_api_service.dart';
import 'package:mobile/utilities/configure.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;
  const CameraScreen({super.key, required this.cameraController});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<MaterialCategory> categories = [];
  int? _selectedCategoryId;
  bool isLoading = true;
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
      final List<dynamic> fetchedCategories =
          await AuthApiService().getAllCategories();
      setState(() {
        categories =
            fetchedCategories.map((e) => MaterialCategory.fromJson(e)).toList();
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
      return;
    }

    try {
      final XFile image = await _controller.takePicture();

      io.File imgFile = io.File(image.path);
      img.Image? originalImage = img.decodeImage(await imgFile.readAsBytes());
      img.Image bwImage = img.grayscale(originalImage!);

      await imgFile.writeAsBytes(img.encodeJpg(bwImage));

      _showCaptureOptions();
    } catch (e) {
      print(e);
    }
  }

Future<void> _addNewMaterial(io.File imgFile, String materialTitle,
      int categoryId, String topicTitle) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;

    try {
      final uri = Uri.parse('$API_BASE_URL/resources');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['material_title'] = materialTitle
        ..fields['category_id'] = categoryId.toString()
        ..fields['topic_title'] = topicTitle
        ..files.add(await http.MultipartFile.fromPath('image', imgFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "New material added successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: const Color(0xFF3786A8),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to add new material.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error adding new material",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _addToExistingMaterial(
      io.File imgFile, int materialId, String topicTitle) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;

    try {
      final uri = Uri.parse('$API_BASE_URL/resources');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['material_id'] = materialId.toString()
        ..fields['topic_title'] = topicTitle
        ..files.add(await http.MultipartFile.fromPath('image', imageFile));

      final response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Material updated successfully!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color(0xFF3786A8),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Failed to update material.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error updating material.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
void _showCaptureOptions(io.File imgFile) {
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
                  _showNewMaterialForm(imgFile);
                },
              ),
              ListTile(
                title: const Text('Add to Existing Material'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showExistingMaterialForm(imgFile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNewMaterialForm(io.File imgFile) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Add New Material',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Material Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map<DropdownMenuItem<int>>((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedCategoryId = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Topic Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF3786A8)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save',
                    style: TextStyle(color: Color(0xFF3786A8))),
                onPressed: () {
                  // Implement the save functionality here
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showExistingMaterialForm(File imageFile) {
    var provider = Provider.of<MaterialsProvider>(context, listen: false);
    List<MaterialItem> materials = provider.studentMaterials;
    int? selectedMaterialId;
    TextEditingController topicController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select Existing Material',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButtonFormField<int>(
                  value: selectedMaterialId,
                  items: materials
                      .map<DropdownMenuItem<int>>((MaterialItem material) {
                    return DropdownMenuItem<int>(
                      value: material.id,
                      child: SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(material.title),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedMaterialId = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Material',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: topicController,
                    decoration: const InputDecoration(
                      labelText: 'Topic Title',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF3786A8))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Save',
                style: TextStyle(color: Color(0xFF3786A8)),
              ),
           onPressed: () async {
                if (selectedMaterialId != null &&
                    topicController.text.isNotEmpty) {
                  await _addToExistingMaterial(
                    imageFile,
                    selectedMaterialId!,
                    topicController.text,
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
