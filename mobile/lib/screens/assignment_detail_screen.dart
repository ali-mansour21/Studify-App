import 'package:flutter/material.dart';
import 'package:mobile/models/topic_material.dart';

class AssignmentDetailScreen extends StatelessWidget {
  final Topic assignment;
  const AssignmentDetailScreen({super.key, required this.assignment});
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 500,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("More Details",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              const Text("Assignment data"),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
        ),
        title: Text(
          assignment.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  assignment.content,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            _showBottomSheet(context);
          }
        },
        onTap: () => _showBottomSheet(context),
        child: Container(
          width: double.infinity,
          color: Colors.black26,
          height: 70,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 24),
              Text('Add your work',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
