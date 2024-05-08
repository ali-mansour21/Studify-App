import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initialize() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        sendTokenToServer(token);
      }
    }
  }

  void sendTokenToServer(String token) {
    print("FCM Token: $token");
  }
}
