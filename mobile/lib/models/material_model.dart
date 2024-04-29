import 'package:mobile/models/topic_material.dart';

class MaterialItem {
  final int id;
  final String title;
  final List<Topic> topics;

  MaterialItem({required this.id, required this.title, required this.topics});
}
