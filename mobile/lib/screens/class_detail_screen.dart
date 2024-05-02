import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart';

class ClassDetailScreen extends StatefulWidget {
  final ClassData classDetail;
  const ClassDetailScreen({super.key, required this.classDetail});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.classDetail.title),
      ),
    );
  }
}
