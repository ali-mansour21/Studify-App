import 'package:flutter/material.dart';
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/services/auth_api_service.dart';
import 'package:mobile/widgets/auth_layout.dart';
import 'package:mobile/widgets/customtextformfield.dart';
import 'package:mobile/widgets/mainbutton.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthApiService _apiService = AuthApiService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await _apiService.login(email, password);
      if (result != null) {
        String jwtToken = result['authorization']['token'];
        String name = result['user']['name'];
        Provider.of<UserData>(context, listen: false)
            .setUserData(name, jwtToken);
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Fluttertoast.showToast(
            msg: "Failed to login, Incorrect email or password ",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Failed to login, please try again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
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
        title: "Welcome Back",
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              Column(
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
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF3786A8)),
                        ),
                        SizedBox(
                            height:
                                20), // Adjust spacing based on design preference
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
