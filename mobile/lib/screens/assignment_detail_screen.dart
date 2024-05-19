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
  bool _isExpanded = false;
  double dialogWidth = 600;
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  String _feedback = '';

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

    setState(() {
      _isUploading = true;
      _isLoading = true;
    });

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
          String feedback = decodedResponse['data']['feedback'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('feedback_${widget.assignment.id}', feedback);

          Provider.of<AssignmentsModel>(context, listen: false)
              .getAssignmentModel(widget.assignment.id)
              .submitAssignment(widget.assignment.id, feedback);
          setState(() {
            _feedback = feedback;
          });
        } else {
          Fluttertoast.showToast(
              msg: 'Failed to submit assignment',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Failed to submit assignment',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error submitting assignment: $e',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        _isUploading = false;
        _isLoading = false;
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
    var assignmentModel = Provider.of<AssignmentsModel>(context, listen: false)
        .getAssignmentModel(widget.assignment.id);
    return Scaffold(
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
      body: GestureDetector(
        onTap: () {
          if (_isExpanded) {
            setState(() {
              _isExpanded = false;
            });
          }
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
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
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
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
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: _isExpanded ? 60 : 600,
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    setState(() {
                      _isExpanded = true;
                    });
                  } else if (details.primaryVelocity! > 0) {
                    setState(() {
                      _isExpanded = false;
                    });
                  }
                },
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          size: 28,
                          color: const Color(0xFF3786A8),
                        ),
                        if (!_isExpanded)
                          const Text(
                            'Add your work',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3786A8),
                            ),
                          ),
                        if (_isExpanded)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 5,
                                        child: ElevatedButton.icon(
                                          icon: Icon(
                                            Icons.attach_file,
                                            color: _feedback.isNotEmpty
                                                ? Colors.black.withOpacity(0.4)
                                                : Colors.white,
                                          ),
                                          label: Text(
                                            _feedback.isNotEmpty
                                                ? "File Submitted"
                                                : (_fileName.isEmpty
                                                    ? "Select File"
                                                    : "Change File"),
                                            style: TextStyle(
                                              color: _feedback.isNotEmpty
                                                  ? Colors.black
                                                      .withOpacity(0.4)
                                                  : Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          onPressed: _feedback.isNotEmpty
                                              ? null
                                              : _pickFile,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                _feedback.isNotEmpty
                                                    ? Colors.grey
                                                    : const Color(0xFF3786A8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Flexible(
                                        flex: 3,
                                        child: Text(
                                          _fileName.isNotEmpty ? _fileName : "",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Center(
                                    child: _isLoading
                                        ? const CircularProgressIndicator()
                                        : SingleChildScrollView(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                _feedback,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_isExpanded)
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _feedback.isNotEmpty
                                      ? Colors.grey
                                      : const Color(0xFF3786A8),
                                ),
                                onPressed: _feedback.isNotEmpty
                                    ? null
                                    : () {
                                        _uploadFile(context);
                                      },
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: _feedback.isNotEmpty
                                          ? Colors.black.withOpacity(0.4)
                                          : Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
