import 'package:billiard_management_mobile_app/src/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class UserHelper {
  static Future<void> logout(BuildContext context) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
    });

    // Navigate back to the login page
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }
}
