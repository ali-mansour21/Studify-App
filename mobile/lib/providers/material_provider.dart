import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/services/home_api_service.dart';

class MaterialsProvider with ChangeNotifier {
  final HomeApiService _apiService = HomeApiService();

  List<MaterialItem> _materials = [];
  bool _isLoading = false;

  List<MaterialItem> get materials => _materials;
  bool get isLoading => _isLoading;

  void fetchMaterials(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      _materials = await _apiService.getHomeData(context);
    } catch (e) {
      print("Failed to fetch materials: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
