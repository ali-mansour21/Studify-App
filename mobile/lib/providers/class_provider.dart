import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart';
import 'package:mobile/services/home_api_service.dart';

class StudyClassProvider with ChangeNotifier {
  final HomeApiService _apiService = HomeApiService();
  List<ClassData> _studyClasses = [];
  bool _isLoading = false;

  List<ClassData> get studyClasses => _studyClasses;
  bool get is_loading => _isLoading;
  Future<void> loadClasses(BuildContext context) async {
    try {
      _studyClasses = await _apiService.getClassesData(context);
      notifyListeners();
    } catch (e) {
      print('Failed to load classes: $e');
    }
  }
}
