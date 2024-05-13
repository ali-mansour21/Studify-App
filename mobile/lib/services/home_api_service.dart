import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/classes/class_data.dart';
import 'package:mobile/models/notifications/notification_model.dart';
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/models/material_model.dart';
import 'package:provider/provider.dart';
import '../utilities/configure.dart';
class HomeApiService {
  final String baseUrl = API_BASE_URL;

  Future<List<MaterialItem>> getNotesData(BuildContext context) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/resources'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
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

  Future<List<ClassData>> getClassesData(BuildContext context) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/resources'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success' &&
            data['data'] != null &&
            data['data']['recommended_classes'] != null) {
          List<dynamic> jsonData = data['data']['recommended_classes'];
          return jsonData
              .map((classJson) => ClassData.fromJson(classJson))
              .toList();
        } else {
          throw Exception('No classes data found or failed status');
        }
      } else {
        throw Exception(
            'Failed to load classes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }

  Future<List<UserNotification>> getNotifications(BuildContext context) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          List<dynamic> jsonData = data['data'];
          return jsonData
              .map((notificationJson) =>
                  UserNotification.fromJson(notificationJson))
              .toList();
        } else {
          throw Exception('No classes data found or failed status');
        }
      } else {
        throw Exception(
            'Failed to load classes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }
}
