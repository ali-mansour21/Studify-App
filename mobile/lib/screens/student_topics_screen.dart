import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';

import 'package:mobile/widgets/topic_layout.dart';

class StudentTopicScreen extends StatelessWidget {
  final MaterialItem material;
  const StudentTopicScreen({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          material.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: TopicListWidget(topics: material.topics),
    );
  }
}
