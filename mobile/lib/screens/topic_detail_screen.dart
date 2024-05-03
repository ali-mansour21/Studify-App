import 'package:flutter/material.dart';
import 'package:mobile/models/topic_material.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;
  final bool showDownloadButton;
  const TopicDetailScreen(
      {super.key, required this.topic, this.showDownloadButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () {},
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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'this is the text for the document, this is the text for the document...',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
