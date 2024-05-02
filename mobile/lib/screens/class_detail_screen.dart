import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart';
import 'package:mobile/widgets/segmented_control.dart';

class ClassDetailScreen extends StatefulWidget {
  final ClassData classDetail;
  const ClassDetailScreen({super.key, required this.classDetail});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  int _selectedIndex = 0;
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xFF3786A8))),
                onPressed: () {},
                child:
                    const Text('Join', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
        body: Column(children: [
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: SegmentedControl(
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
          ),
        ]));
  }
}
