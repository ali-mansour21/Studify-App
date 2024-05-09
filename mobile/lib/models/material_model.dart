import 'package:mobile/models/topic_material.dart';

class MaterialItem {
  final int id;
  final String title;
  final List<NotesTopic> topics;

  MaterialItem({required this.id, required this.title, required this.topics});
  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    var list = json['topics'] as List;
    List<NotesTopic> topicsList =
        list.map((i) => NotesTopic.fromJson(i)).toList();

    return MaterialItem(
      id: json['id'],
      title: json['title'],
      topics: topicsList,
    );
  }
}
