// Trong file UserAPI.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class UserAPI {
  static Future<http.Response> loginRequest(
      String phone, String password) async {
    var reqBody = {"phone": phone, "password": password};

    return http.post(
      Uri.parse(LOGIN_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
  }
}
