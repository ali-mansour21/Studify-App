import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/services/home_api_service.dart';
import 'package:mobile/services/profile_api.dart';
import 'package:flutter/scheduler.dart';

class MaterialsProvider with ChangeNotifier {
  final HomeApiService _apiService = HomeApiService();
  final ProfileApiService _studentApiService = ProfileApiService();

  List<MaterialItem> _materials = [];
  List<MaterialItem> _studentMaterials = [];
  bool _isLoading = false;

  List<MaterialItem> get materials => _materials;
  List<MaterialItem> get studentMaterials => _studentMaterials;
  bool get isLoading => _isLoading;

  Future<void> fetchMaterials(BuildContext context) async {
    _isLoading = true;
    _notifyListenersSafely();
    try {
      _materials = await _apiService.getNotesData(context);
    } catch (e) {
      print("Failed to fetch materials: $e");
    } finally {
      _isLoading = false;
      _notifyListenersSafely();
    }
  }

  void loadMaterials(BuildContext context) async {
    notifyListeners();
    try {
      _materials = await _apiService.getNotesData(context);
    } catch (e) {
      print("Failed to fetch materials: $e");
    } finally {
      _notifyListenersSafely();
    }
  }

  void updateMaterials(List<MaterialItem> newMaterials) {
    _materials = newMaterials;
    _notifyListenersSafely();
  }

  void fetchStudnetMaterials(BuildContext context) async {
    _isLoading = true;
    _notifyListenersSafely();
    try {
      _studentMaterials = await _studentApiService.getStudentNotesData(context);
    } catch (e) {
      print("Failed to fetch materials: $e");
    } finally {
      _isLoading = false;
      _notifyListenersSafely();
    }
  }

  void _notifyListenersSafely() {
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      notifyListeners();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }
}
