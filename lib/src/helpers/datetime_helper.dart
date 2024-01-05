import 'package:flutter/material.dart';

class DateTimeConverter {
  // Chuyển đổi giá trị từ MongoDB về DateTime và TimeOfDay
  static Map<String, dynamic> fromMongoDB(String mongoDBDate) {
    DateTime dateTime = DateTime.parse(mongoDBDate);
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);

    return {'dateTime': dateTime, 'timeOfDay': timeOfDay};
  }

  // Chuyển đổi giá trị từ DateTime và TimeOfDay thành chuỗi MongoDB
  static String toMongoDB(DateTime dateTime, TimeOfDay timeOfDay) {
    DateTime fullDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    return fullDateTime.toIso8601String();
  }
}
