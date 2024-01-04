import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class FoodAPI {
  static Future<http.Response> getAllFoodRequest() async {
    var response = await http.get(
      Uri.parse(FOOD_API_URL),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> filterFoodTypeRequest(foodType) async {
    print("$FOOD_API_URL/filter?foodtype=$foodType");
    var response = await http.get(
      Uri.parse("$FOOD_API_URL/filter?foodtype=$foodType"),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> addNewFoodRequest(
      String foodName, String foodType, int price) async {
    var reqBody = {"name": foodName, "foodType": foodType, "price": price};

    var response = await http.post(
      Uri.parse(FOOD_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static Future<http.Response> updateFoodRequest(
      String id, String foodName, String foodType, int price) async {
    var reqBody = {"name": foodName, "foodType": foodType, "price": price};

    var response = await http.put(
      Uri.parse(
          '$FOOD_API_URL/$id'), // Assuming the API supports updating by ID
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static Future<http.Response> deleteFoodRequest(String id) async {
    var response = await http.delete(
      Uri.parse('$FOOD_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }
}
