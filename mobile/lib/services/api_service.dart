import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.0.104:8001/api";
  Future<dynamic> login(String email, String password) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/student_login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            'email': email,
            'password': password,
          }));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login: $response.body');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<dynamic> register(
      String name, String email, String password, String firebaseAccess) async {
    final response = await http.post(
      Uri.parse('$baseUrl/student_register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'firebase_access': firebaseAccess
      }),
    );
  }
}
