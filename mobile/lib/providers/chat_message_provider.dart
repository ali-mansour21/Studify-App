import 'package:flutter/foundation.dart';
import 'package:mobile/models/messages/chat_model.dart';

class ChatProvider with ChangeNotifier{
  List<ChatMessage> messages = [];

  void updateMessages(List<ChatMessage> newMessages) {
    if (messages.length != newMessages.length ||
        !listEquals(messages, newMessages)) {
      messages = newMessages;
      notifyListeners();
    }
  }
}