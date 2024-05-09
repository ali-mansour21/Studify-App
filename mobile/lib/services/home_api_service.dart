import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/models/topic_material.dart';
import 'package:provider/provider.dart';

class HomeApiService {
  final String baseUrl = "http://192.168.0.104:8001/api";

  Future<List<MaterialItem>> getHomeData(BuildContext context) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/home'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<MaterialItem> materials = body.map((dynamic item) {
          return MaterialItem.fromJson(item);
        }).toList();
        return materials;
      } else {
        throw Exception(
            'Failed to load materials. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }
}
