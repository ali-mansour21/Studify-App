import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart';
import 'package:mobile/services/home_api_service.dart';

class StudyClassProvider with ChangeNotifier {
  final HomeApiService _apiService = HomeApiService();
  List<ClassData> _studyClasses = [];
  bool _isLoading = false;

  List<ClassData> get studyClasses => _studyClasses;
  bool get is_loading => _isLoading;
  void fetchClasses(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      _studyClasses = await _apiService.getClassesData(context);
    } catch (e) {
      print("Failed to fetch classes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
