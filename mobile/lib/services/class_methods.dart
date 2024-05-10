import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/models/users/user_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ClassOperations {
  final String baseUrl = "http://192.168.0.104:8001/api";
  Future<Map<String, String>> requestJoinClass(
      BuildContext context, int id) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request_join_class'),
        body: json.encode({'class_id': id}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return {'status': data['status'], 'message': data['message']};
      } else {
        return {
          'status': 'error',
          'message': 'Failed to send join request: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Exception occurred: $e'};
    }
  }
}
