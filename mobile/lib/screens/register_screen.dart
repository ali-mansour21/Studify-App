import 'package:flutter/material.dart';
import 'package:mobile/api/firebase_api.dart';
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/widgets/auth_layout.dart';
import 'package:mobile/widgets/customtextformfield.dart';
import 'package:mobile/widgets/mainbutton.dart';
import 'package:mobile/services/auth_api_service.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthApiService _apiService = AuthApiService();
  final FirebaseApi _getToken = FirebaseApi();
  bool _isLoading = false;

  void _register() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    String? firebaseAccess = await _getToken.getFcmToken();
    setState(() {
      _isLoading = true;
    });
    try {
      final result =
          await _apiService.register(name, email, password, firebaseAccess);
      if (result != null) {
        String jwtToken = result['authorization']['token'];
        Provider.of<UserData>(context, listen: false)
            .setUserData(name, jwtToken);
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/category', (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(
            msg: "Failed to create new account",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Failed to create new account",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      imagePath: 'assets/Studify-logo.png',
      title: "Let's Get Started",
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 70,
                    child: CustomTextFormField(
                      controller: _nameController,
                      labelText: "Name",
                      iconData: Icons.person,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: CustomTextFormField(
                      controller: _emailController,
                      labelText: "Email",
                      iconData: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: CustomTextFormField(
                      controller: _passwordController,
                      labelText: "Password",
                      iconData: Icons.lock,
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MainButton(
                    buttonColor: const Color(0xFF3786A8),
                    buttonText: "Sign Up",
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
              if (_isLoading)
                Positioned(
                  top: -10,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.2,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF3786A8)),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
            ],
          )),
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
