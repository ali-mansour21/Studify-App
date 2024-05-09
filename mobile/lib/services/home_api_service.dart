import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/models/material_model.dart';
import 'package:provider/provider.dart';

class HomeApiService {
  final String baseUrl = "http://192.168.0.104:8001/api";

  Future<List<MaterialItem>> getHomeData(BuildContext context) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/resources'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data['data']);
        if (data['status'] == 'success' &&
            data['data'] != null &&
            data['data']['recommended_notes'] != null) {
          List<dynamic> notesJson = data['data']['recommended_notes'];
          List<MaterialItem> studentNotes = notesJson
              .map((dynamic item) => MaterialItem.fromJson(item))
              .cast<MaterialItem>()
              .toList();
          return studentNotes;
        } else {
          throw Exception("No notes data found or failed status");
        }
      } else {
        throw Exception(
            'Failed to load materials. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }
}
