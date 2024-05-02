import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/models/topic_material.dart';
import 'package:mobile/widgets/material_card.dart';

class StudentMaterialScreen extends StatelessWidget {
  const StudentMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MaterialItem> materials = [
      MaterialItem(
        id: 1,
        title: 'Material 1',
        topics: [
          NotesTopic(id: 1, title: 'Topic 1', content: 'Content for topic 1'),
          NotesTopic(id: 2, title: 'Topic 2', content: 'Content for topic 2'),
        ],
      ),
      MaterialItem(
        id: 2,
        title: 'Material 2',
        topics: [
          NotesTopic(id: 1, title: 'Topic 1', content: 'Content for topic 1'),
          NotesTopic(id: 2, title: 'Topic 2', content: 'Content for topic 2'),
        ],
      ),
      MaterialItem(
        id: 2,
        title: 'Material 2',
        topics: [
          NotesTopic(id: 1, title: 'Topic 1', content: 'Content for topic 1'),
          NotesTopic(id: 2, title: 'Topic 2', content: 'Content for topic 2'),
        ],
      ),
      MaterialItem(
        id: 2,
        title: 'Material 2',
        topics: [
          NotesTopic(id: 1, title: 'Topic 1', content: 'Content for topic 1'),
          NotesTopic(id: 2, title: 'Topic 2', content: 'Content for topic 2'),
        ],
      ),
    ];
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
