import 'package:flutter/material.dart';
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/services/auth_api_service.dart';
import 'package:mobile/widgets/auth_layout.dart';
import 'package:mobile/widgets/customtextformfield.dart';
import 'package:mobile/widgets/mainbutton.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthApiService _apiService = AuthApiService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final result = await _apiService.login(email, password);

      String jwtToken = result['authorization']['token'];
      String name = result['user']['name'];
      Provider.of<UserData>(context, listen: false).setUserData(name, jwtToken);
      Navigator.of(context).pushReplacementNamed('/home');
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
      title: "Welcome Back",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                buttonText: "Login",
                onPressed: _login),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                'New user? Sign Up',
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
