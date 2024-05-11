import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile/models/topic_material.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Topic assignment;
  const AssignmentDetailScreen({Key? key, required this.assignment})
      : super(key: key);

  @override
  _AssignmentDetailScreenState createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  String _fileName = "";

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 600,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Upload Your Work",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3786A8),
                    ),
                    icon: const Icon(Icons.file_upload, color: Colors.white),
                    label: Text(
                      _fileName.isEmpty ? "Select File" : "Change File",
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        PlatformFile file = result.files.first;
                        setState(() {
                          _fileName =
                              file.name; // Update the file name in the state
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _fileName,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Expanded(
                child: SizedBox(
                  height: 50,
                  child: Center(
                    child:
                        Text("AI response or other details will be shown here"),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // submission logic here
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: const Color(0xFF3786A8)),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, size: 24),
        ),
        title: Text(
          widget.assignment.title,
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
                  widget.assignment.content,
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
          color: Colors.grey[200],
          height: 70,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.keyboard_arrow_up, color: Color(0xFF3786A8), size: 24),
              Text('Add your work',
                  style: TextStyle(color: Color(0xFF3786A8), fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
