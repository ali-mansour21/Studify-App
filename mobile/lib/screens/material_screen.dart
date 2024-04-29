import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';

class MaterialScreen extends StatelessWidget {
  final MaterialItem material;
  const MaterialScreen({super.key, required this.material});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, "/home");
          },
        ),
        title: Text(
          material.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
