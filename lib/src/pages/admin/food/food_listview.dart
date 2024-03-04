import 'dart:convert';

import 'package:billiard_management_mobile_app/src/api/food_api.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultFooter.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultHeader.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/dialog.dart';
import 'package:billiard_management_mobile_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:http/src/response.dart';

class AdminFoodListView extends StatefulWidget {
  static const routeName = 'admin/food';
  const AdminFoodListView({Key? key}) : super(key: key);

  @override
  State<AdminFoodListView> createState() => _AdminFoodListViewState();
}

class _AdminFoodListViewState extends State<AdminFoodListView> {
  List? foodList;
  String? selectedFoodType;

  @override
  void initState() {
    super.initState();
    _getFoodList("all");
  }

  void _getFoodList(String newValue) async {
    try {
      setState(() {
        selectedFoodType = newValue;
      });

      if (selectedFoodType == 'all') {
        var response = await FoodAPI.getAllFoodRequest();
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          foodList = jsonResponse['data'];
        });
      } else {
        var response = await FoodAPI.filterFoodTypeRequest(selectedFoodType);
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        setState(() {
          foodList = jsonResponse['data'];
        });
      }
    } catch (error) {
      print("Error filtering food list: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý món ăn'),
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
              title: 'Danh sách món ăn',
              onAdd: () {
                _showFoodFormDialog(context);
              },
            ),
            // Dropdown for Food Types
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: selectedFoodType,
                  onChanged: (String? newValue) {
                    _getFoodList(newValue!);
                  },
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'all',
                      child: Text('Tất cả'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'eating',
                      child: Text('Đồ ăn'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'drinking',
                      child: Text('Đồ uống'),
                    ),
                  ],
                  hint: const Text('Chọn loại đồ ăn'),
                ),
              ),
            ),
            // Body
            Expanded(
              flex: 8,
              child: foodList == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: foodList!.length,
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
                            title: Text(foodList![index]['name']),
                            subtitle:
                                Text('Price: ${foodList![index]['price']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showFoodFormDialog(context,
                                        foodID: foodList![index]['_id'],
                                        foodName: foodList![index]['name'],
                                        foodType: foodList![index]['foodType'],
                                        foodPrice: foodList![index]['price']);
                                    _getFoodList("all");
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    Response response;
                                    response = await FoodAPI.deleteFoodRequest(
                                        foodList![index]['_id']);
                                    if (response.statusCode == 200) {
                                      Future.delayed(Duration.zero, () {
                                        String foodName =
                                            foodList![index]['name'];
                                        CustomDialog.showSuccessDialog(
                                            context, "Đã xoá món $foodName");
                                      });
                                      _getFoodList("all");
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

  void _showFoodFormDialog(BuildContext context,
      {String? foodID, String? foodName, String? foodType, int? foodPrice}) {
    String? selectedTypeOfFood;
    final TextEditingController foodNameController = TextEditingController();
    final TextEditingController foodPriceController = TextEditingController();

    if (foodID != null) {
      setState(() {
        foodNameController.text = foodName!;
        foodPriceController.text = foodPrice!.toString();
        selectedTypeOfFood = foodType;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // sử dụng stateful mới tương thích với dropdown
        return StatefulBuilder(
          // Add this
          builder: (BuildContext context, StateSetter setState) {
            // And this
            return AlertDialog(
              title: Text(foodID == null ? 'Thêm món ăn' : 'Cập nhật món ăn'),
              content: Column(
                children: <Widget>[
                  TextField(
                    controller: foodNameController,
                    decoration: const InputDecoration(hintText: "Tên món ăn"),
                    onChanged: (value) {
                      // Update the food name
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: selectedTypeOfFood,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTypeOfFood = newValue;
                        });
                      },
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'eating',
                          child: Text('Đồ ăn'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'drinking',
                          child: Text('Đồ uống'),
                        ),
                      ],
                      hint: const Text('Chọn loại món ăn'),
                    ),
                  ),
                  TextField(
                    inputFormatters: <TextInputFormatter>[
                      // Chỉ cho phép nhập các ký tự số
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: foodPriceController,
                    decoration: const InputDecoration(hintText: "Giá"),
                    onChanged: (value) {
                      // Update the price
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Lưu'),
                  onPressed: () async {
                    final foodName = foodNameController.text;
                    final foodPrice = foodPriceController.text;
                    if (foodName.isNotEmpty &&
                        foodPrice.isNotEmpty &&
                        selectedTypeOfFood != null) {
                      Response response;
                      if (foodID == null) {
                        // Thêm mới
                        response = await FoodAPI.addNewFoodRequest(foodName,
                            selectedTypeOfFood!, int.parse(foodPrice));
                      } else {
                        // Cập nhật
                        response = await FoodAPI.updateFoodRequest(
                            foodID,
                            foodName,
                            selectedTypeOfFood!,
                            int.parse(foodPrice));
                      }
                      if (response.statusCode == 200) {
                        // Use Future.delayed to get the context after a short delay
                        Future.delayed(Duration.zero, () {
                          CustomDialog.showSuccessDialog(
                              context,
                              foodID == null
                                  ? 'Thêm mới món thành công'
                                  : 'Cập nhật món thành công');
                        });
                        if (foodID == null) {
                          foodNameController.text = "";
                          foodPriceController.text = "";
                        }
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
      },
    );
  }
}
