import 'package:flutter/material.dart';

class TopicListWidget extends StatelessWidget {
  final List<String> topics;
  const TopicListWidget({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            topics[index],
            style: const TextStyle(color: Colors.black),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          onTap: () {
            // Handle the tap here
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
