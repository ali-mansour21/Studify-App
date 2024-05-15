import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:mobile/models/classes/class_data.dart';
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/providers/assignment_provider.dart';
import 'package:mobile/screens/pdf_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utilities/configure.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Assignment assignment;
  const AssignmentDetailScreen({Key? key, required this.assignment})
      : super(key: key);

  @override
  _AssignmentDetailScreenState createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  final String baseUrl = API_BASE_URL;
  bool _isLoading = false;
  String _fileName = "";
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  String _response = "";

  Future<void> _uploadFile(BuildContext context) async {
    if (_selectedFile == null) {
      Fluttertoast.showToast(
          msg: 'Select a file to upload',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    String token = Provider.of<UserData>(context, listen: false).jwtToken;
    var uri = Uri.parse('$baseUrl/submit_assignment');
    var request = http.MultipartRequest('POST', uri)
      ..fields['assignment_id'] = widget.assignment.id.toString()
      ..files.add(await http.MultipartFile.fromPath(
        'solution',
        _selectedFile!.path!,
        filename: basename(_selectedFile!.name),
      ))
      ..headers.addAll({'Authorization': 'Bearer $token'});

    setState(() => _isUploading = true);

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(responseBody);
        if (decodedResponse['status'] == 'success') {
          Fluttertoast.showToast(
              msg: 'Assignment Submitted Successfully',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 5,
              backgroundColor: const Color(0xFF3786A8),
              textColor: Colors.white,
              fontSize: 16.0);
          String feedback = decodedResponse['date']['feedback'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('feedback_${widget.assignment.id}', feedback);

          Provider.of<AssignmentsModel>(context, listen: false)
              .getAssignmentModel(widget.assignment.id)
              .submitAssignment(widget.assignment.id, feedback);
          setState(() {
            _response = '\n\nFeedback:\n$feedback';
          });
        } else {
          setState(() {
            _response = 'File upload failed: ${decodedResponse['message']}';
          });
        }
      } else {
        setState(() {
          _response =
              'Failed to upload file: Server responded with status code ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error during file upload: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _fileName = file.name;
        _selectedFile = file;
      });
    } else {
      print("No file selected");
    }
  }

  void _showBottomSheet(BuildContext context) {
    var assignmentModel = Provider.of<AssignmentsModel>(context, listen: false)
        .getAssignmentModel(widget.assignment.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                          backgroundColor: assignmentModel.isSubmitted
                              ? Colors.grey
                              : const Color(0xFF3786A8),
                        ),
                        icon:
                            const Icon(Icons.file_upload, color: Colors.white),
                        label: Text(
                          assignmentModel.isSubmitted
                              ? "File Submitted"
                              : (_fileName.isEmpty
                                  ? "Select File"
                                  : "Change File"),
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: assignmentModel.isSubmitted
                            ? null
                            : () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  PlatformFile file = result.files.first;
                                  setState(() {
                                    _fileName = file.name;
                                    _selectedFile = file;
                                  });
                                  print(_selectedFile);
                                } else {
                                  print("No file selected");
                                }
                              },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _fileName,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          assignmentModel.feedback.isNotEmpty
                              ? assignmentModel.feedback
                              : "",
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: assignmentModel.isSubmitted
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await _uploadFile(context);
                              setState(() {
                                _isLoading = false;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: assignmentModel.isSubmitted
                            ? Colors.grey
                            : const Color(0xFF3786A8),
                      ),
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
      },
    );
  }

  void _launchURL(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Fluttertoast.showToast(
          msg: 'Could not open the file',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Preview PDF'),
              content: const Text('Would you like to preview the PDF?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<String> downloadAndSaveFile(
      BuildContext context, String url, String filename) async {
    String filePath = '';
    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final directory = await getApplicationDocumentsDirectory();
          filePath = '${directory.path}/$filename';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          Fluttertoast.showToast(
              msg: 'File downloaded successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          throw Exception('Failed to download file from server');
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Permission needed to download and save the file',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color(0xFF3786A8),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error downloading the file: $e',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return filePath;
  }

  void openPDF(BuildContext context, String filePath) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PDFViewPage(filePath)),
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
            SingleChildScrollView(
              child: Text(
                widget.assignment.content,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            if (widget.assignment.attachmentUrl != null)
              Container(
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.file_present),
                  label: const Text("Download Attachment"),
                  onPressed: () async {
                    if (widget.assignment.attachmentUrl != null) {
                      final String filePath = await downloadAndSaveFile(
                          context,
                          widget.assignment.attachmentUrl!,
                          "${widget.assignment.title.replaceAll(' ', '_')}.pdf");

                      bool shouldPreview =
                          await _showConfirmationDialog(context);
                      if (shouldPreview) {
                        openPDF(context, filePath);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "No attachment available",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
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
