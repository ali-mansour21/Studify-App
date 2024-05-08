import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String _userName = '';
  String _jwtToken = '';
  String get userName => _userName;
  String get jwtToken => _jwtToken;
  void setUserData(String userName, String jwtToken) {
    _userName = userName;
    _jwtToken = jwtToken;
    notifyListeners();
  }
}
