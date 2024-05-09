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
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<dynamic> register(String name, String email, String password,
      String? firebaseAccess) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/student_register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'firebase_token': firebaseAccess
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body);
        throw Exception('Validation failed: ${errors['errors']}');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<dynamic> getAllCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == 'success' &&
            decodedResponse.containsKey('data')) {
          return decodedResponse['data'];
        } else {
          throw Exception('Unexpected JSON structure: ${response.body}');
        }
      } else {
        throw Exception(
            'Failed to fetch categories: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get all categories: $e');
    }
  }
}
