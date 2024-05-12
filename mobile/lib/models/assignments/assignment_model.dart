import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentModel with ChangeNotifier {
  bool _isSubmitted = false;
  String _feedback = '';

  bool get isSubmitted => _isSubmitted;
  String get feedback => _feedback;

  Future<void> submitAssignment(int id, String feedback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('feedback_$id', feedback);
    _feedback = feedback;
    _isSubmitted = true;
    notifyListeners();
  }

  Future<void> loadFeedback(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedFeedback = prefs.getString('feedback_$id');
    if (savedFeedback != null) {
      _feedback = savedFeedback;
      _isSubmitted = true;
      notifyListeners();
    }
  }
}
