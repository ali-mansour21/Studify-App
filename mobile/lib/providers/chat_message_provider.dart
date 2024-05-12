import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/models/messages/chat_model.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/users/user_data.dart';
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  final String baseUrl = "http://192.168.0.104:8001/api";

  List<ChatMessage> messages = [];

  void updateMessages(List<ChatMessage> newMessages) {
    if (messages.length != newMessages.length ||
        !listEquals(messages, newMessages)) {
      messages = newMessages;
      notifyListeners();
    }
  }

  Future<void> sendQuestionAndGetResponse(
      int materialID, String question, BuildContext context) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;

    await Future.delayed(const Duration(seconds: 1));
    final response = await http.post(Uri.parse('$baseUrl/student_faq'),
        body: json.encode({'material_id': materialID, 'question': question}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'success' && data['data'] != null) {
        ChatMessage newMessage = ChatMessage(
            id: data['id'], question: data['question'], answer: data['answer']);
        updateMessages([...messages, newMessage]);
      }
    }
  }
}
