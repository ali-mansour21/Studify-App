import 'package:flutter/widgets.dart';
import 'package:mobile/models/notifications/notification_model.dart';
import 'package:mobile/services/home_api_service.dart';

class NotificationProvider with ChangeNotifier {
  final HomeApiService _apiService = HomeApiService();
  List<UserNotification> _notifications = [];
  bool _isLoading = false;
  List<UserNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  Future<void> getNotifications(BuildContext context) async {
    try {
      _notifications = await _apiService.getNotifications(context);
      notifyListeners();
    } catch (e) {
      print('Failed to load classes: $e');
    }
  }
}
