import 'package:billiard_management_mobile_app/src/pages/client/booking/booking_listview.dart';
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
  late String currentUserPhone;
  late String currentUserFullName;
  late String currentUserID;
  @override
  void initState() {
    super.initState();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    currentUserPhone = jwtDecodedToken['phone'];
    currentUserFullName = jwtDecodedToken['fullname'];
    currentUserID = jwtDecodedToken['_id'];
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
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Xin chào: $currentUserFullName ($currentUserPhone)',
                    style: const TextStyle(fontSize: 15),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(
                      context,
                      ClientBookingListView.routeName,
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
                const SizedBox(height: 20)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
