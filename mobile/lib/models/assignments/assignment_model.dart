import 'package:flutter/material.dart';

class AssignmentModel with ChangeNotifier {
  bool _isSubmitted = false;
  String _feedback = '';

  bool get isSubmitted => _isSubmitted;
  String get feedback => _feedback;

  void submitAssignment(String feedback) {
    _feedback = feedback;
    _isSubmitted = true;
    notifyListeners();
  }

  void loadFeedback(String feedback) {
    _feedback = feedback;
    _isSubmitted = true;
    notifyListeners();
  }
}
