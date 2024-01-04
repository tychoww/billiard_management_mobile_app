import 'package:billiard_management_mobile_app/src/api/user_api.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultFooter.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultHeader.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/dialog.dart';
import 'package:billiard_management_mobile_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class AdminUserListView extends StatefulWidget {
  static const routeName = 'admin/user';
  const AdminUserListView({Key? key}) : super(key: key);

  @override
  State<AdminUserListView> createState() => _AdminUserListViewState();
}

class _AdminUserListViewState extends State<AdminUserListView> {
  List? userList;

  @override
  void initState() {
    super.initState();
    _getUserList();
  }

  void _getUserList() async {
    try {
      var response = await UserAPI.getAllUserRequest();
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        userList = jsonResponse;
      });
    } catch (error) {
      print("Error fetching user list: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
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
            DefaultHeader(
              title: 'Danh sách người dùng',
              onAdd: () {
                // Add logic to show user form dialog
              },
            ),
            // Body
            Expanded(
              flex: 8,
              child: userList == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: userList!.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1.0,
                                color: Color.fromARGB(255, 130, 127, 127),
                              ),
                            ),
                          ),
                          child: ListTile(
                            title: Text(userList![index]['fullname']),
                            subtitle: Text('Role: ${userList![index]['role']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Add logic to show user form dialog for editing
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    Response response;
                                    response = await UserAPI.deleteUserRequest(
                                        userList![index]['_id']);
                                    if (response.statusCode == 200) {
                                      Future.delayed(Duration.zero, () {
                                        String fullName =
                                            userList![index]['fullname'];
                                        CustomDialog.showSuccessDialog(
                                            context, "Đã xoá $fullName");
                                      });
                                      _getUserList();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
            ),
            // Footer
            const DefaultFooter(footerText: 'Phần mềm quản lý quán bi-a'),
          ],
        ),
      ),
    );
  }
}
