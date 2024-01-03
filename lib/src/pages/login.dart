// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:billiard_management_mobile_app/src/api/user_api.dart';
import 'package:billiard_management_mobile_app/src/pages/admin/home.dart';
import 'package:billiard_management_mobile_app/src/pages/client/home.dart';
import 'package:billiard_management_mobile_app/src/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/settings_view.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late SharedPreferences prefs;
  late String role;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _login() async {
    final phone = _phoneController.text;
    final password = _passwordController.text;

    if (_phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var response = await UserAPI.loginRequest(phone, password);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var myToken = jsonResponse['token'];
        // Lưu token vào bộ nhớ
        prefs.setString('token', myToken);

        // giả mã token
        Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);

        // kiểm tra quyền trước khi chuyển trang
        role = jwtDecodedToken['role'];
        if (role == "admin" || role == "staff") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminHomePage(token: myToken)));
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClientHomePage(token: myToken)));
      } else {
        print('Something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      // body: Text("OK"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Đăng nhập'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.restorablePushNamed(
                    context,
                    SignUpPage.routeName,
                  );
                },
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
