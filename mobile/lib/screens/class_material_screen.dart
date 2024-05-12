import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart' as model;
import 'package:mobile/models/messages/chat_model.dart';
import 'package:mobile/screens/assignment_detail_screen.dart';
import 'package:mobile/screens/topic_detail_screen.dart';
import 'package:mobile/widgets/segmented_control.dart';

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
    List<ChatMessage> messages = [];
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
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: message.isUser
                                ? Colors.white
                                : Colors.green[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color:
                                  message.isUser ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
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
                            // Adding user message
                            messages.add(ChatMessage(
                                text: _controller.text, isUser: true));
                            _controller.clear();
                            // Simulate an AI response
                            Future.delayed(const Duration(seconds: 1), () {
                              messages.add(ChatMessage(
                                  text:
                                      "AI Response to '${messages.last.text}'",
                                  isUser: false));
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent +
                                    100,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                              );
                              (context as Element).markNeedsBuild();
                            });
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent + 100,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                            );
                            (context as Element).markNeedsBuild();
                          }
                        },
                      ),
                      hintText: "Type your message here",
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

Future<void> sendQuestionAndGetResponse(String question, int materialId,
    List<ChatMessage> messages, ScrollController scrollController ,BuildContext context) async {
      
  await Future.delayed(const Duration(seconds: 1));
  messages.add(ChatMessage(text: question, isUser: true)); // User's question
  // Simulate receiving an answer from the server
  messages.add(ChatMessage(
      text: "AI Response to '$question'", isUser: false)); // AI's answer

  // Ensuring we update the UI on the main thread
  if (scrollController.hasClients) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  (context as Element)
      .markNeedsBuild(); // This ensures the UI rebuilds to display the new messages
}
