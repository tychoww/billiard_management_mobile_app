import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class BookingAPI {
  static Future<http.Response> getAllBookingsRequest() async {
    print(BOOKING_API_URL);
    var response = await http.get(
      Uri.parse(BOOKING_API_URL),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> addNewBookingRequest(
      phone, fullname, arrivalTime) async {
    var reqBody = {
      "phone": phone,
      "fullname": fullname,
      "arrivalTime": arrivalTime
    };

    var response = await http.post(
      Uri.parse(BOOKING_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static Future<http.Response> updateBookingRequest(
      id, userId, arrivalTime) async {
    var reqBody = {"userID": userId, "arrivalTime": arrivalTime};

    var response = await http.put(
      Uri.parse('$BOOKING_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static Future<http.Response> deleteBookingRequest(id) async {
    var response = await http.delete(
      Uri.parse('$BOOKING_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }
}
