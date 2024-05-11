import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/models/topic_material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;
  final bool showDownloadButton;
  const TopicDetailScreen(
      {super.key, required this.topic, this.showDownloadButton = false});
  Future<void> downloadAndSaveFile(
      BuildContext context, String data, String filename) async {
    try {
      // Check and request storage permissions
      var status = await Permission.storage.request();
      if (status.isGranted) {
        // Get the directory to save the file
        final directory = await getExternalStorageDirectory();
        final file = File('${directory?.path}/$filename');

        await file.writeAsString(data);
        Fluttertoast.showToast(
            msg: 'File successfully downloaded',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color(0xFF3786A8),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Permission needed to download and save the file',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color(0xFF3786A8),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download the file: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          if (showDownloadButton)
            IconButton(
              icon: const Icon(
                Icons.file_download,
                size: 24,
              ),
              onPressed: () => downloadAndSaveFile(context, topic.content,
                  "${topic.title.replaceAll(' ', '_')}.txt"),
            ),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
            )),
        title: Text(
          topic.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: double.infinity,
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
                  topic.content,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
