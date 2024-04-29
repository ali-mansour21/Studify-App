import 'package:flutter/material.dart';
import 'package:mobile/models/topic_material.dart';
import 'package:mobile/screens/topic_detail_screen.dart';

class TopicListWidget extends StatelessWidget {
  final List<Topic> topics;
  const TopicListWidget({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index]; // Get the Topic object at this index
        return ListTile(
          title: Text(
            topic.title, // Use the title property of the Topic object
            style: const TextStyle(color: Colors.black),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          onTap: () {
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopicDetailScreen(topic: topic),
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey.shade300,
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        );
      },
    );
  }
}
