import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart' as model;

class ClassMaterialDetailScreen extends StatefulWidget {
  final model.Material material;
  const ClassMaterialDetailScreen({super.key, required this.material});

  @override
  State<ClassMaterialDetailScreen> createState() =>
      _ClassMaterialDetailScreenState();
}

class _ClassMaterialDetailScreenState extends State<ClassMaterialDetailScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.material.title),
      ),
    );
  }
}
