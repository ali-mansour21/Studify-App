import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart' as model;
import 'package:mobile/screens/topic_detail_screen.dart';
import 'package:mobile/widgets/segmented_control.dart';

class ClassDetailScreen extends StatefulWidget {
  final model.ClassData classDetail;
  const ClassDetailScreen({super.key, required this.classDetail});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      _buildMaterialList(widget.classDetail.materials),
      _buildPeopleList(widget.classDetail.people),
    ];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(widget.classDetail.title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF3786A8),
                ),
                child: const Text('Join'),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 30),
              SegmentedControl(
                labels: const ['Material', 'People'],
                onSegmentChosen: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                width: 105,
                height: 35,
                groupValue: _selectedIndex,
              ),
              Expanded(child: content[_selectedIndex]),
            ],
          ),
        ));
  }

  Widget _buildMaterialList(List<model.Material> materials) {
    return ListView.separated(
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        return ListTile(
          title: Text(
            material.title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16, // Example size, adjust as necessary
            ),
          ),
          subtitle: Text(
            material.description,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          onTap: () {},
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey.shade300,
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        );
      },
    );
  }

  Widget _buildPeopleList(List<model.Person> people) {
    return ListView.builder(
      itemCount: people.length,
      itemBuilder: (context, index) {
        final person = people[index];
        return ListTile(
          title: Text(person.name),
          subtitle: Text(person.role),
        );
      },
    );
  }
}
