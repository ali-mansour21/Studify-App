import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/services/home_api_service.dart';
import 'package:mobile/services/profile_api.dart';

class MaterialsProvider with ChangeNotifier {
  final HomeApiService _apiService = HomeApiService();
  final ProfileApiService _studentApiService = ProfileApiService();

  List<MaterialItem> _materials = [];
  List<MaterialItem> _studentMaterials = [];
  bool _isLoading = false;

  List<MaterialItem> get materials => _materials;
  List<MaterialItem> get studentMaterials => _studentMaterials;
  bool get isLoading => _isLoading;

  void fetchMaterials(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      _materials = await _apiService.getNotesData(context);
    } catch (e) {
      print("Failed to fetch materials: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void loadMaterials(BuildContext context) async {
    notifyListeners();
    try {
      _materials = await _apiService.getNotesData(context);
    } catch (e) {
      print("Failed to fetch materials: $e");
    } finally {
      notifyListeners();
    }
  }

  void updateMaterials(List<MaterialItem> newMaterials) {
    _materials = newMaterials;
    notifyListeners();
  }

  void fetchStudnetMaterials(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      _studentMaterials = await _studentApiService.getStudentNotesData(context);
    } catch (e) {
      print("Failed to fetch materials: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
