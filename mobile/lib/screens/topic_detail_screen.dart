import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/topic_material.dart'; // Make sure this path is correct
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/screens/pdf_view_screen.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;
  final bool isStudent;

  const TopicDetailScreen(
      {super.key, required this.topic, this.isStudent = false});

  Future<String> downloadAndSaveFile(
      BuildContext context, String url, String filename) async {
    String filePath = '';
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        Fluttertoast.showToast(
            msg: 'Storage permission is required to save files',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return filePath;
      }
       void openPDF(BuildContext context, String filePath) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PDFViewPage(filePath)),
        );
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        filePath = '${directory?.path}/$filename';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        Fluttertoast.showToast(
            msg: 'File successfully downloaded',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color(0xFF3786A8),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        throw Exception('Failed to download file from server');
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
              title: const Text('Preview File'),
              content: const Text('Would you like to preview the file now?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(topic.title, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          if (isStudent)
            IconButton(
              icon: const Icon(Icons.file_download, color: Colors.black),
              onPressed: () => downloadAndSaveFile(
                  context,
                  'data:text/plain;charset=utf-8,${Uri.encodeComponent(topic.content)}',
                  "${topic.title.replaceAll(' ', '_')}.txt"),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(topic.content, style: const TextStyle(fontSize: 16)),
           if (isStudent && topic.attachmentUrl != null)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.file_download),
                  label: const Text("Download and Optionally View Attachment"),
                  onPressed: () async {
                    final String filePath = await downloadAndSaveFile(
                        context,
                        topic.attachmentUrl!,
                        "Attachment_${topic.title.replaceAll(' ', '_')}.pdf");

                    bool shouldPreview = await _showConfirmationDialog(context);
                    if (shouldPreview) {
                      openPDF(context, filePath);
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
