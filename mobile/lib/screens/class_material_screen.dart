import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart' as model;
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                        }
                      });

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(10),
                        itemCount: provider.messages.length +
                            (provider.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= provider.messages.length) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                        color: Colors.green),
                                    SizedBox(width: 10),
                                    Text("Loading...",
                                        style: TextStyle(color: Colors.green)),
                                  ],
                                ),
                              ),
                            );
                          }

                          final message = provider.messages[index];
                          Widget questionWidget = Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                message.question,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );

                          if (message.answer.isNotEmpty) {
                            Widget answerWidget = Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3786A8),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  message.answer,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );

                            return Column(
                              children: [questionWidget, answerWidget],
                            );
                          } else {
                            return questionWidget;
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 75,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon:
                              const Icon(Icons.send, color: Color(0xFF3786A8)),
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              final provider = Provider.of<ChatProvider>(
                                  context,
                                  listen: false);
                              provider.sendQuestionAndGetResponse(
                                  widget.material.id,
                                  _controller.text,
                                  context);
                              _controller.clear();
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
                )
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
            const SizedBox(height: 10),
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
            const SizedBox(height: 30),
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
