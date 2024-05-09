import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/services/home_api_service.dart';

class MaterialsProvider with ChangeNotifier {
  final HomeApiService _apiService = HomeApiService();

  List<MaterialItem> _materials = [];

  List<MaterialItem> get materials => _materials;

  void setMaterials(List<MaterialItem> materials) {
    _materials = materials;
    notifyListeners();
  }

  Future<void> fetchMaterials() async {
    try {
      _materials = await _apiService.getHomeData();
      notifyListeners();
    } catch (e) {
      print("Failed to fetch materials: $e");
    }
  }
}
