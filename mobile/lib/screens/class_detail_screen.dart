import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart' as model;
import 'package:mobile/screens/class_material_screen.dart';
import 'package:mobile/widgets/mainbutton.dart';
import 'package:mobile/widgets/segmented_control.dart';

class ClassDetailScreen extends StatefulWidget {
  final model.ClassData classDetail;
  const ClassDetailScreen({super.key, required this.classDetail});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  int _selectedIndex = 0;
  void _showJoinClassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Join Class", style: TextStyle(fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Enter Class Code",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 300,
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Class Code',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 10,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: MainButton(
                  buttonColor: const Color(0xFF3786A8),
                  buttonText: "Submit",
                  onPressed: () {
                    // Submission logic here
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const Divider(height: 30, thickness: 2),
              Center(
                child: Column(children: [
                  const Text("Don't have a code?",
                      style: TextStyle(fontSize: 16)),
                  TextButton(
                    child: const Text('Request to join',
                        style: TextStyle(decoration: TextDecoration.underline)),
                    onPressed: () {},
                  )
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

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
                onPressed: _showJoinClassDialog,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF3786A8),
                ),
                child: const Text(
                  'Join',
                  style: TextStyle(color: Colors.white),
                ),
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
              fontSize: 16,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassMaterialDetailScreen(
                  material: material,
                ),
              ),
            );
          },
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
    List<model.Person> teachers =
        people.where((person) => person.role == 'Teacher').toList();
    List<model.Person> students =
        people.where((person) => person.role == 'Student').toList();

    return ListView(
      children: [
        _buildRoleSection('Teachers', teachers),
        _buildRoleSection('Students', students),
      ],
    );
  }

  Widget _buildRoleSection(String title, List<model.Person> people) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: people.length,
          itemBuilder: (context, index) {
            final person = people[index];
            return ListTile(
              leading: const Icon(Icons.account_circle, size: 40.0),
              title: Text(person.name),
            );
          },
          separatorBuilder: (context, index) => const Divider(height: 1),
        ),
      ],
    );
  }
}
