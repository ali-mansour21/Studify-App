import 'package:flutter/material.dart';

abstract class Topic {
  String get title;
  String get content;
}

class NotesTopicProvider with ChangeNotifier implements Topic {
  int _id;
  String _title;
  String _content;

  NotesTopicProvider(
      {required int id, required String title, required String content})
      : _id = id,
        _title = title,
        _content = content;

  int get id => _id;
  String get title => _title;
  String get content => _content;

  // Method to update the title and notify listeners
  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  // Method to update the content and notify listeners
  void updateContent(String newContent) {
    _content = newContent;
    notifyListeners();
  }
}
