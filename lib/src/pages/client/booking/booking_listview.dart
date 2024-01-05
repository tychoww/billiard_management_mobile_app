import 'package:billiard_management_mobile_app/src/api/booking_api.dart';
import 'package:billiard_management_mobile_app/src/helpers/datetime_helper.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultFooter.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultHeader.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/dialog.dart';
import 'package:billiard_management_mobile_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class ClientBookingListView extends StatefulWidget {
  static const routeName = 'client/booking';
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const ClientBookingListView({@required this.token, Key? key})
      : super(key: key);

  @override
  State<ClientBookingListView> createState() => _ClientBookingListViewState();
}

class _ClientBookingListViewState extends State<ClientBookingListView> {
  // USER INFOR
  late String currentUserPhone;
  late String currentUserFullName;
  late String currentUserID;

  List? bookingList;
  DateTime _dateTime = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    currentUserPhone = jwtDecodedToken['phone'];
    currentUserFullName = jwtDecodedToken['fullname'];
    currentUserID = jwtDecodedToken['_id'];
    print('$currentUserPhone, $currentUserFullName, $currentUserID');

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
                                    'Thời gian đặt: ${bookingList![index]['createdDate']}'),
                                Text(
                                    'Thời gian đến: ${bookingList![index]['arrivalTime']}'),
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

  void _showBookingFormDialog(BuildContext context) {
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    phoneController.text = currentUserPhone;
    fullNameController.text = currentUserFullName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // sử dụng stateful mới tương thích với dropdown
        return StatefulBuilder(
          // Add this
          builder: (BuildContext context, StateSetter setState) {
            // And this
            return AlertDialog(
              title: const Text('Thêm đơn đặt bàn'),
              content: Column(
                children: <Widget>[
                  TextField(
                    enabled: false,
                    controller: phoneController,
                    decoration:
                        const InputDecoration(hintText: "Số điện thoại"),
                    onChanged: (value) {
                      // Update the food name
                    },
                  ),
                  TextField(
                    enabled: false,
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
                    String arrivalTime =
                        DateTimeConverter.toMongoDB(_dateTime, _time);
                    Response response;

                    response = await BookingAPI.addNewBookingRequest(
                        phoneTxt, fullNameTxt, arrivalTime);

                    if (response.statusCode == 200) {
                      Future.delayed(Duration.zero, () {
                        CustomDialog.showSuccessDialog(
                            context, '($phoneTxt) Thêm đơn đặt bàn thành công');
                      });
                      _getBookingList();
                    } else {
                      Future.delayed(Duration.zero, () {
                        CustomDialog.showErrorDialog(context, "Có lỗi xảy ra!");
                      });
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
