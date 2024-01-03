import 'dart:convert';

import 'package:billiard_management_mobile_app/src/api/user_api.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/settings_view.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  bool _isValid = false;
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _checkValidity() {
    final String fullname = _fullnameController.text;
    final String phone = _phoneController.text;
    final String password = _passwordController.text;

    if (fullname.length >= 3 && phone.length >= 8 && password.length >= 5) {
      _isValid = true;
    } else {
      _isValid = false;
    }

    setState(() {});
  }

  void _register(String fullname, String phone, String password) async {
    final fullname = _fullnameController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;

    var response = await UserAPI.registerUserRequest(fullname, phone, password);

    if (response.statusCode == 409) {
      // Tài khoản đã tồn tại
      // ignore: use_build_context_synchronously
      CustomDialog.showErrorDialog(
          context, 'Tài khoản đã tồn tại. Vui lòng chọn tài khoản khác.');
    }

    var jsonResponse = jsonDecode(response.body);
    var dataResponse = jsonResponse['data'];
    // ignore: use_build_context_synchronously
    CustomDialog.showSuccessDialog(
        context,
        // ignore: prefer_interpolation_to_compose_strings
        'Đăng ký thành công với số điện thoại: ' + dataResponse['phone']);

    _clearAll();
  }

  void _clearAll() {
    _fullnameController.text = "";
    _phoneController.text = "";
    _passwordController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _fullnameController,
                onChanged: (_) => _checkValidity(),
                decoration: const InputDecoration(labelText: "Họ tên"),
              ),
              const SizedBox(height: 16),
              TextField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  // Chỉ cho phép nhập các ký tự số
                ],
                controller: _phoneController,
                onChanged: (_) => _checkValidity(),
                decoration: const InputDecoration(labelText: "Số điện thoại"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                onChanged: (_) => _checkValidity(),
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mật khẩu"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isValid
                    ? () => _register(_fullnameController.text,
                        _phoneController.text, _passwordController.text)
                    : null,
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
