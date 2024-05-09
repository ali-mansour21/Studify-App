import 'package:mobile/models/topic_material.dart';

class MaterialItem {
  final int id;
  final String title;
  final List<NotesTopic> topics;

  MaterialItem({required this.id, required this.title, required this.topics});
  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    List<dynamic>? topicsData = json['topics'];
    List<NotesTopic> topicsList = [];

    if (topicsData != null) {
      topicsList = topicsData
          .map((topicJson) => NotesTopic.fromJson(topicJson))
          .toList();
    }

    return MaterialItem(
      id: json['id'],
      title: json['title'],
      topics: topicsList,
    );
  }
}
