// Trong file UserAPI.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class UserAPI {
  static Future<http.Response> loginRequest(
      String phone, String password) async {
    var reqBody = {"phone": phone, "password": password};

    var response = await http.post(
      Uri.parse(LOGIN_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    return response;
  }

  static Future<http.Response> registerUserRequest(
      String fullname, String phone, String password) async {
    var reqBody = {"fullname": fullname, "phone": phone, "password": password};

    var response = await http.post(
      Uri.parse(USER_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    return response;
  }
}
