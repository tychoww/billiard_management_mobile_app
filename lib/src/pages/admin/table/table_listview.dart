import 'dart:convert';

import 'package:billiard_management_mobile_app/src/api/table_api.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultFooter.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultHeader.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/dialog.dart';
import 'package:billiard_management_mobile_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:http/src/response.dart';

class AdminTableListView extends StatefulWidget {
  static const routeName = 'admin/table';
  const AdminTableListView({Key? key}) : super(key: key);

  @override
  State<AdminTableListView> createState() => _AdminTableListViewState();
}

class _AdminTableListViewState extends State<AdminTableListView> {
  List? tableList;

  @override
  void initState() {
    super.initState();
    getTableList();
  }

  void getTableList() async {
    try {
      var response = await TableAPI.getAllTableRequest();
      var jsonResponse = jsonDecode(response.body);
      tableList = jsonResponse['data'];
      setState(() {});
    } catch (error) {
      // ignore: avoid_print
      print("Error fetching table list: $error");
      // Handle error gracefully if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý bàn chơi'),
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
                title: 'Danh sách bàn',
                onAdd: () {
                  _showTableFormDialog(context, null);
                }),
            // Body
            Expanded(
              flex: 8,
              child: tableList == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: tableList!.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: tableList![index]['isOpen']
                                ? Colors.limeAccent
                                : Colors.grey,
                            border: const Border(
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: Color.fromARGB(255, 130, 127, 127)),
                            ),
                          ),
                          child: ListTile(
                            title: Text(tableList![index]['name']),
                            subtitle: Text(
                                tableList![index]['isOpen'] ? 'Mở' : 'Đóng'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showTableFormDialog(
                                        context, tableList![index]['_id']);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    // Xử lý khi nhấn nút Xóa
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Thêm món'),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Footer
            const DefaultFooter(footerText: 'Phần mềm quản lý quán bi-a'),
          ],
        ),
      ),
    );
  }

  // Form nhập liệu cho bảng
  void _showTableFormDialog(BuildContext context, index) {
    final TextEditingController tableNameController = TextEditingController();
    final TextEditingController tablePriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Thêm bàn' : 'Cập nhật bàn'),
          content: Column(
            children: <Widget>[
              TextField(
                controller: tableNameController,
                decoration: const InputDecoration(hintText: "Tên bàn"),
                onChanged: (value) {
                  // Cập nhật tên bảng
                },
              ),
              TextField(
                inputFormatters: <TextInputFormatter>[
                  // Chỉ cho phép nhập các ký tự số
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: tablePriceController,
                decoration:
                    const InputDecoration(hintText: "Giá giờ chơi / giờ"),
                onChanged: (value) {
                  // Cập nhật trạng thái
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Lưu'),
              onPressed: () async {
                final tableName = tableNameController.text;
                final pricePerHour = tablePriceController.text;
                if (tableName.isNotEmpty && pricePerHour.isNotEmpty) {
                  Response response;
                  if (index == null) {
                    // Thêm mới
                    response = await TableAPI.addNewTableRequest(
                        tableName, pricePerHour);
                  } else {
                    // Cập nhật
                    response = await TableAPI.updateTableRequest(
                        index, tableName, pricePerHour);
                  }
                  if (response.statusCode == 200) {
                    // Use Future.delayed to get the context after a short delay
                    Future.delayed(Duration.zero, () {
                      CustomDialog.showSuccessDialog(
                          context,
                          index == null
                              ? 'Thêm mới bàn thành công'
                              : 'Cập nhật bàn thành công');
                    });
                    tableNameController.text = "";
                    tablePriceController.text = "";
                  }
                } else {
                  CustomDialog.showErrorDialog(
                      context, "Vui lòng điền đầy đủ thông tin!");
                }
              },
            ),
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Form nhập liệu để thêm món ăn
  void _showFoodFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm món ăn'),
          content: Column(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(hintText: "Tên món ăn"),
                onChanged: (value) {
                  // Cập nhật tên món ăn
                },
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Giá"),
                onChanged: (value) {
                  // Cập nhật giá
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                // Lưu thông tin món ăn
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
