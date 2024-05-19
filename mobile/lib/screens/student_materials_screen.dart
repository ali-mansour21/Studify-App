import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';
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
          'Notes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: materials.isEmpty
          ? const Center(
              child: Text(
                'No notes available.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: materials.length,
              itemBuilder: (context, index) =>
                  MaterialCard(materialItem: materials[index]),
            ),
    );
  }
}
