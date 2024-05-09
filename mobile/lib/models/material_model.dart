import 'package:flutter/material.dart';
import 'package:mobile/models/topic_material.dart';

class MaterialItemProvider with ChangeNotifier {
  int _id;
  String _title;
  List<NotesTopic> _topics;

  MaterialItemProvider(
      {required int id,
      required String title,
      required List<NotesTopic> topics})
      : _id = id,
        _title = title,
        _topics = topics;

  int get id => _id;
  String get title => _title;
  List<NotesTopic> get topics => _topics;

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  void updateTopics(List<NotesTopic> newTopics) {
    _topics = newTopics;
    notifyListeners();
  }
}
