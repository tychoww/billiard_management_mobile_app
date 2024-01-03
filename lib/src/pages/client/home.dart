import 'package:billiard_management_mobile_app/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../settings/settings_view.dart';

class ClientHomePage extends StatefulWidget {
  static const routeName = 'client/home';

  // ignore: prefer_typing_uninitialized_variables
  final token;
  const ClientHomePage({@required this.token, Key? key}) : super(key: key);

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
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
        automaticallyImplyLeading: false,
        title: const Text('Trang chủ'),
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
                  padding: EdgeInsets.all(16.0),
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
          ],
        ),
      ),
    );
  }
}
