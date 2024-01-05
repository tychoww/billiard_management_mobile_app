import 'package:billiard_management_mobile_app/src/api/booking_api.dart';
import 'package:billiard_management_mobile_app/src/helpers/datetime_helper.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultFooter.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultHeader.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/dialog.dart';
import 'package:billiard_management_mobile_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class AdminBookingListView extends StatefulWidget {
  static const routeName = 'admin/booking';
  const AdminBookingListView({Key? key}) : super(key: key);

  @override
  State<AdminBookingListView> createState() => _AdminBookingListViewState();
}

class _AdminBookingListViewState extends State<AdminBookingListView> {
  List? bookingList;
  DateTime _dateTime = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _getBookingList();
  }

  void _getBookingList() async {
    try {
      var response = await BookingAPI.getAllBookingsRequest();
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        bookingList = jsonResponse['data'];
      });
    } catch (error) {
      print("Error fetching booking list: $error");
    }
  }

  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dateTime) {
      setState(() {
        _dateTime = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, StateSetter setState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đặt bàn'),
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
              title: 'Danh sách đặt bàn',
              onAdd: () {
                _showBookingFormDialog(context);
              },
            ),
            // Body
            Expanded(
              flex: 8,
              child: bookingList == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: bookingList!.length,
                      itemBuilder: (context, int index) {
                        // Access user information from the response
                        var userInfor = bookingList![index]['userInfor'];

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
                            title: Text(userInfor != null
                                ? '${userInfor['fullname']} (${userInfor['phone']})'
                                : ""),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Thời gian đặt: ${DateTimeConverter.fromMongoDBDisplayText(bookingList![index]['createdDate'])}'),
                                Text(
                                    'Thời gian đến: ${DateTimeConverter.fromMongoDBDisplayText(bookingList![index]['arrivalTime'])}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    Response response;
                                    response =
                                        await BookingAPI.deleteBookingRequest(
                                            bookingList![index]['_id']);
                                    if (response.statusCode == 200) {
                                      Future.delayed(Duration.zero, () {
                                        String bookingId =
                                            bookingList![index]['_id'];
                                        CustomDialog.showSuccessDialog(context,
                                            "Xoá thành công bookingID: $bookingId");
                                      });
                                      _getBookingList();
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

  void _showBookingFormDialog(BuildContext context,
      {String? bookingID,
      String? userID,
      String? phone,
      String? fullName,
      String? arrivalTime}) {
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    if (bookingID != null) {
      setState(() {
        // foodNameController.text = foodName!;
        // foodPriceController.text = foodPrice!.toString();
        // selectedTypeOfFood = foodType;
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
              title: Text(bookingID == null
                  ? 'Thêm đơn đặt bàn'
                  : 'Cập nhật đơn đặt bàn'),
              content: Column(
                children: <Widget>[
                  TextField(
                    inputFormatters: <TextInputFormatter>[
                      // Only allow entering digits
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: phoneController,
                    decoration:
                        const InputDecoration(hintText: "Số điện thoại"),
                    onChanged: (value) {
                      // Update the food name
                    },
                  ),
                  TextField(
                    controller: fullNameController,
                    decoration:
                        const InputDecoration(hintText: "Tên người đặt"),
                    onChanged: (value) {
                      // Update the price
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Thời gian: ${_dateTime.day}-${_dateTime.month} / ${_time.format(context)}',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      IconTheme(
                        data: const IconThemeData(
                            size: 20,
                            color: Colors.blue), // Adjust size and color
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context, setState),
                            ),
                            IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () => _selectTime(context, setState),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Lưu'),
                  onPressed: () async {
                    final phoneTxt = phoneController.text;
                    final fullNameTxt = fullNameController.text;
                    print('$phoneTxt, $fullNameTxt');

                    String arrivalTime =
                        DateTimeConverter.toMongoDB(_dateTime, _time);
                    if (phoneTxt.isNotEmpty && arrivalTime.isNotEmpty) {
                      Response response;
                      // bookingID == null => adding...
                      if (bookingID == null) {
                        response = await BookingAPI.addNewBookingRequest(
                            phoneTxt, fullNameTxt, arrivalTime);
                      } else {
                        // bookingID != null => updating...
                        response = await BookingAPI.updateBookingRequest(
                            phoneTxt, fullNameTxt, arrivalTime);
                      }
                      if (response.statusCode == 200) {
                        // Use Future.delayed to get the context after a short delay
                        Future.delayed(Duration.zero, () {
                          CustomDialog.showSuccessDialog(
                              context,
                              bookingID == null
                                  ? 'Thêm đơn đặt bàn thành công'
                                  : 'Cập nhật đơn đặt bàn thành công');
                        });
                        if (bookingID == null) {
                          fullNameController.text = "";
                          phoneController.text = "";
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
