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
  bool isLoading = false;
  void addMessages(List<ChatMessage> newMessages) {
    var isUpdated = false;
    for (var message in newMessages) {
      if (!messages.any((m) => m.id == message.id)) {
        messages.add(message);
        isUpdated = true;
      }
    }
    if (isUpdated) {
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> sendQuestionAndGetResponse(
      int materialID, String question, BuildContext context) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;
    try {
      setLoading(true);
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
        print(data);
        if (data['status'] == 'success' && data['data'] != null) {
          List<ChatMessage> newMessages = (data['data'] as List).map((item) {
            return ChatMessage(
              id: item['id'],
              question: item['question'],
              answer: item['bot_answer'],
            );
          }).toList();
          addMessages(newMessages);
        }
      }
    } catch (e) {
      setLoading(false);
      print('Error sending question and getting response: $e');
    } finally {
      setLoading(false);
    }
  }
}
