import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart' as model;
import 'package:mobile/models/messages/chat_model.dart';
import 'package:mobile/providers/chat_message_provider.dart';
import 'package:mobile/screens/assignment_detail_screen.dart';
import 'package:mobile/screens/topic_detail_screen.dart';
import 'package:mobile/widgets/segmented_control.dart';
import 'package:provider/provider.dart';

class ClassMaterialDetailScreen extends StatefulWidget {
  final model.Material material;
  const ClassMaterialDetailScreen({super.key, required this.material});

  @override
  State<ClassMaterialDetailScreen> createState() =>
      _ClassMaterialDetailScreenState();
}

class _ClassMaterialDetailScreenState extends State<ClassMaterialDetailScreen> {
  int _selectedIndex = 0;

  void showChatDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    ScrollController _scrollController = ScrollController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Consumer<ChatProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(10),
                        itemCount: provider.messages.length,
                        itemBuilder: (context, index) {
                          final message = provider.messages[index];
                          return ListTile(
                            title: Text(message.question),
                            subtitle: Text(message.answer),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFF3786A8)),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            Provider.of<ChatProvider>(context, listen: false)
                                .sendQuestionAndGetResponse(widget.material.id,
                                    _controller.text, context);
                            _controller.clear();
                            Future.microtask(() => _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent +
                                      100,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                ));
                          }
                        },
                      ),
                      hintText: "Type your question here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      _buildTopicList(widget.material.topics),
      _buildAssignmentList(widget.material.assignments),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.material.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.question_answer),
            onPressed: () => showChatDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: SegmentedControl(
                labels: const ['Topics', 'Assignments'],
                onSegmentChosen: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                width: 105,
                height: 35,
                groupValue: _selectedIndex,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: content[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}

Widget _buildTopicList(List<model.ClassTopic> topics) {
  return ListView.separated(
    itemCount: topics.length,
    itemBuilder: (context, index) {
      final topic = topics[index];
      return ListTile(
        title: Text(
          topic.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicDetailScreen(
                topic: topic,
              ),
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

Widget _buildAssignmentList(List<model.Assignment> assignments) {
  return ListView.separated(
    itemCount: assignments.length,
    itemBuilder: (context, index) {
      final assignment = assignments[index];
      return ListTile(
        title: Text(
          assignment.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AssignmentDetailScreen(
                assignment: assignment,
              ),
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
