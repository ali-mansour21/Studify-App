import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart' as model;
import 'package:mobile/screens/class_material_screen.dart';
import 'package:mobile/services/class_methods.dart';
import 'package:mobile/widgets/mainbutton.dart';
import 'package:mobile/widgets/navigation_bar.dart';
import 'package:mobile/widgets/segmented_control.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClassDetailScreen extends StatefulWidget {
  final model.ClassData classDetail;
  bool isInClass;
  ClassDetailScreen(
      {super.key, required this.classDetail, this.isInClass = false});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  final ClassOperations _apiService = ClassOperations();
  final TextEditingController classCodeController = TextEditingController();
  int _selectedIndex = 0;
  int _currentIndex = 0;
  bool _isLoading = false;
  void _showJoinClassDialog() {
    showDialog(
      context: context,
      barrierDismissible: !_isLoading,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Join Class", style: TextStyle(fontSize: 18)),
          content: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
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
                        controller: classCodeController,
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
                        onPressed: () async {
                          final classCode = classCodeController.text;
                          if (classCode.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please enter class code",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          }
                          Map<String, String> result = await _apiService
                              .enrollWithClassCode(context, classCode);
                          setState(() {
                            _isLoading = false;
                          });
                          if (result['status'] == 'success') {
                            setState(() {
                              widget.isInClass = true;
                            });
                          }
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: result['message'] ?? 'Failed to join class',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 5,
                              backgroundColor: const Color(0xFF3786A8),
                              textColor: Colors.white,
                              fontSize: 16.0);
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
                              style: TextStyle(
                                  decoration: TextDecoration.underline)),
                          onPressed: () async {
                            Navigator.pop(context);
                            setState(() {
                              _isLoading = true;
                            });
                            Map<String, String> result =
                                await _apiService.requestJoinClass(
                                    context, widget.classDetail.id);
                            Fluttertoast.showToast(
                                msg:
                                    result['message'] ?? 'Failed to join class',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: const Color(0xFF3786A8),
                                textColor: Colors.white,
                                fontSize: 16.0);
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          },
                        )
                      ]),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle the navigation based on the selected index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // This is handled inside CustomNavigationBar
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
      default:
        break;
    }
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
          if (!widget.isInClass)
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                const SizedBox(height: 10),
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
                  selectedColor: const Color(0xFF3786A8),
                  unselectedColor: Colors.white,
                  borderColor: const Color(0xFF3786A8),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(child: content[_selectedIndex]),
              ],
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3786A8),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
          currentIndex: _currentIndex, onItemSelected: _onItemSelected),
    );
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
          trailing: widget.isInClass
              ? const Icon(Icons.chevron_right, color: Colors.grey)
              : null,
          onTap: widget.isInClass
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassMaterialDetailScreen(
                        material: material,
                      ),
                    ),
                  );
                }
              : null,
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
