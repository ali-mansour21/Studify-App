import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/users/user_data.dart';
import 'package:provider/provider.dart';
import '../utilities/configure.dart';

class AuthApiService {
  final String baseUrl = API_BASE_URL;
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

  Future<dynamic> sendSelectedCategories(
      List<int> selectedCategories, BuildContext context) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories/select'),
        body: json.encode({'categories': selectedCategories}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to fetch home data: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }
}
