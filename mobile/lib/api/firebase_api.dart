import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message.notification?.title);
  print(message.notification?.body);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FcmToken = await _firebaseMessaging.getToken();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    print('fcm token: $FcmToken');
  }
  Future<String?> getFcmToken() async{
    return await _firebaseMessaging.getToken();
  }
}
