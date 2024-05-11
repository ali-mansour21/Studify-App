import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart';
import 'package:mobile/screens/class_detail_screen.dart';

class StudentClassScreen extends StatelessWidget {
  final List<ClassData> studentClasses;

  const StudentClassScreen({super.key, required this.studentClasses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Classes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: studentClasses.isEmpty
            ? const Center(
                child: Text(
                  'No materials available.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ListView.builder(
                      itemCount: studentClasses.length,
                      itemBuilder: (context, index) {
                        final classData = studentClasses[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.class_,
                              color: Colors.blue,
                              size: 50,
                            ),
                            title: Text(classData.title),
                            subtitle: Text(classData.description),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ClassDetailScreen(
                                          classDetail: classData,
                                          isInClass: true,
                                        )),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )),
                ],
              ));
  }
}
