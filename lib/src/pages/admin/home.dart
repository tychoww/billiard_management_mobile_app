import 'package:billiard_management_mobile_app/src/helpers/user_helper.dart';
import 'package:billiard_management_mobile_app/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../settings/settings_view.dart';

class AdminHomePage extends StatefulWidget {
  static const routeName = 'admin/home';

  final token;
  const AdminHomePage({@required this.token, Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late String phone;
  @override
  void initState() {
    super.initState();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    phone = jwtDecodedToken['phone'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang quản trị'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Phone: $phone',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Xử lý khi nhấn nút Sửa hồ sơ
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(
                      context,
                      LoginPage.routeName,
                    );
                  },
                  child: const SizedBox(
                    width: 150,
                    height: 150,
                    child: Center(
                      child: Text('Đặt bàn'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý khi nhấn nút Kiểm tra bàn của bạn
                  },
                  child: const SizedBox(
                    width: 150,
                    height: 150,
                    child: Center(
                      child: Text('Kiểm tra bàn của bạn'),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  UserHelper.logout(context);
                },
                child: const Text('Đăng xuất'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
