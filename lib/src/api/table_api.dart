// Trong file UserAPI.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class TableAPI {
  static Future<http.Response> getAllTableRequest() async {
    var response = await http.get(
      Uri.parse(TABLE_API_URL),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> addNewTableRequest(
      tableName, pricePerHour) async {
    var reqBody = {"name": tableName, "pricePerHour": pricePerHour};

    var response = await http.post(
      Uri.parse(TABLE_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static Future<http.Response> updateTableRequest(
      id, tableName, pricePerHour) async {
    var reqBody = {"name": tableName, "pricePerHour": pricePerHour};

    var response = await http.post(
      Uri.parse(TABLE_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }
}
