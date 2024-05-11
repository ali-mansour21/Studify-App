import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/api/firebase_api.dart';
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/providers/class_provider.dart';
import 'package:mobile/providers/notification_provider.dart';
import 'package:mobile/screens/categories_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/profile_screen.dart';
import 'package:mobile/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/material_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCU-MVgP1If7umfeTK92a4ZfoCN-p-Q5d0",
              appId: "1:256089037545:android:8e417a08611cb97f05ae78",
              messagingSenderId: "256089037545",
              projectId: "studify-notifications"))
      : await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserData()),
      ChangeNotifierProvider(create: (context) => MaterialsProvider()),
      ChangeNotifierProvider(create: (context) => StudyClassProvider()),
      ChangeNotifierProvider(create: (context) => NotificationProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)),
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/category': (context) => const CategoryScreen(),
        '/profile': (context) => const ProfileScreen()
      },
    );
  }
}
