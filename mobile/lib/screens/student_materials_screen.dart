import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/models/topic_material.dart';
import 'package:mobile/widgets/material_card.dart';

class StudentMaterialScreen extends StatelessWidget {
  final List<MaterialItem> materials;

  const StudentMaterialScreen({super.key, required this.materials});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Materials',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        itemCount: materials.length,
        itemBuilder: (context, index) =>
            MaterialCard(materialItem: materials[index]),
      ),
    );
  }
}
