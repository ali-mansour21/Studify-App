import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart' as model;
import 'package:mobile/widgets/segmented_control.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: SegmentedControl(
                labels: const ['Topics', 'Assignments'],
                onSegmentChosen: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                width: 105,
                height: 35,
                groupValue: _selectedIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
