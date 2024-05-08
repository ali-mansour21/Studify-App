import 'package:flutter/material.dart';
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/widgets/auth_layout.dart';
import 'package:mobile/widgets/customtextformfield.dart';
import 'package:mobile/widgets/mainbutton.dart';
import 'package:mobile/services/api_service.dart';
import 'package:provider/provider.dart'; // Import your ApiService

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService();

  void _register() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    String? firebaseAccess = await _notificationService.getFirebaseToken();

    try {
      final result =
          await _apiService.register(name, email, password, firebaseAccess);
      String jwtToken = result['authorization']['token'];
      Provider.of<UserData>(context, listen: false).setUserData(name, jwtToken);
      Navigator.of(context).pushReplacementNamed('/category');
    } catch (error) {
      print('The returned error is: $error');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Error: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      imagePath: 'assets/Studify-logo.png',
      title: "Let's Get Started",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextFormField(
              controller: _nameController,
              labelText: "Name",
              iconData: Icons.person,
            ),
            CustomTextFormField(
              controller: _emailController,
              labelText: "Email",
              iconData: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextFormField(
              controller: _passwordController,
              labelText: "Password",
              iconData: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            MainButton(
              buttonColor: const Color(0xFF3786A8),
              buttonText: "Sign up",
              onPressed: _register,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text(
                "Have an account? LogIn",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
