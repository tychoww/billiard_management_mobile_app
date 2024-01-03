import 'package:billiard_management_mobile_app/src/pages/admin/table/table_listview.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultFooter.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../settings/settings_view.dart';

class AdminHomePage extends StatefulWidget {
  static const routeName = 'admin/home';

  // ignore: prefer_typing_uninitialized_variables
  final token;
  const AdminHomePage({@required this.token, Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late String phone;
  late String fullname;
  @override
  void initState() {
    super.initState();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    phone = jwtDecodedToken['phone'];
    fullname = jwtDecodedToken['fullname'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Expanded(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(255, 136, 200, 247),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Xin chào: $fullname ($phone)',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      iconSize: 20,
                      onPressed: () {
                        // Xử lý khi nhấn nút Sửa hồ sơ
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Body
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.restorablePushNamed(
                          context,
                          AdminTableListView.routeName,
                        );
                      },
                      child: const Text('Quản lý bàn'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút Quản lý bàn
                      },
                      child: const Text('Đơn đặt bàn'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút Quản lý đồ ăn
                      },
                      child: const Text('Quản lý đồ ăn'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút Quản lý hoá đơn
                      },
                      child: const Text('Quản lý hoá đơn'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút Quản lý người dùng
                      },
                      child: const Text('Thống kê'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút Quản lý người dùng
                      },
                      child: const Text('Quản lý người dùng'),
                    ),
                  ],
                ),
              ),
            ),
            // Footer
            const DefaultFooter(footerText: 'Phần mềm quản lý quán bi-a'),
          ],
        ),
      ),
    );
  }
}
