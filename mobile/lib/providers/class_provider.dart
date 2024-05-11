import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart';
import 'package:mobile/services/home_api_service.dart';
import 'package:mobile/services/profile_api.dart';

class StudyClassProvider with ChangeNotifier {
  final HomeApiService _apiService = HomeApiService();
  final ProfileApiService _profileApiService = ProfileApiService();
  List<ClassData> _studyClasses = [];
  List<ClassData> _studentStudyClasses = [];
  bool _isLoading = false;

  List<ClassData> get studyClasses => _studyClasses;
  List<ClassData> get studentStudyClass => _studentStudyClasses;
  bool get is_loading => _isLoading;
  Future<void> loadClasses(BuildContext context) async {
    try {
      _studyClasses = await _apiService.getClassesData(context);
      notifyListeners();
    } catch (e) {
      print('Failed to load classes: $e');
    }
  }

  Future<void> loadStudentClasses(BuildContext context) async {
    try {
      _studentStudyClasses =
          await _profileApiService.getStudentClassesData(context);
      notifyListeners();
    } catch (e) {
      print('Failed to load classes: $e');
    }
  }
}
