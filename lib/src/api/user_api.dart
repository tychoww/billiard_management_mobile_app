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

  static Future<http.Response> getAllUserRequest() async {
    var response = await http.get(
      Uri.parse(USER_API_URL),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> updateUserRequest(String id, String fullname,
      String phone, String password, String role) async {
    var reqBody = {
      "fullname": fullname,
      "phone": phone,
      "password": password,
      "role": role,
    };

    var response = await http.put(
      Uri.parse(
          '$USER_API_URL/$id'), // Assuming the API supports updating by ID
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static Future<http.Response> deleteUserRequest(String id) async {
    print('$USER_API_URL/$id');
    var response = await http.delete(
      Uri.parse('$USER_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }
}
