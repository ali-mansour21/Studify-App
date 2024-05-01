import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/widgets/customtextformfield.dart';
import 'package:mobile/widgets/mainbutton.dart';
import 'package:mobile/widgets/profile_screen_layout.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3786A8),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Edit Profile",
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
      body: ProfileLayout(
        height: 600,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -65,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        _imageFile == null ? null : FileImage(_imageFile!),
                    child: _imageFile == null
                        ? const Text('AM',
                            style: TextStyle(fontSize: 24, color: Colors.white))
                        : null,
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
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 40),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const CustomTextFormField(
                  iconData: Icons.person,
                  labelText: "Ali Mansour",
                ),
                const SizedBox(height: 8),
                const CustomTextFormField(
                  iconData: Icons.email,
                  labelText: "ali@gmail.com",
                ),
                const SizedBox(height: 8),
                const CustomTextFormField(
                  iconData: Icons.lock,
                  labelText: "password",
                ),
                const SizedBox(height: 30),
                MainButton(
                  buttonColor: const Color(0xFF3786A8),
                  buttonText: "Save",
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
