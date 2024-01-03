import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final Color titleColor;
  final Color messageColor;

  CustomDialog({
    required this.title,
    required this.message,
    required this.buttonText,
    required this.titleColor,
    required this.messageColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: titleColor),
      ),
      content: Text(
        message,
        style: TextStyle(color: messageColor),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng cửa sổ thông báo
          },
          child: Text(buttonText),
        ),
      ],
    );
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Lỗi',
          message: message,
          buttonText: 'Đóng',
          titleColor: Colors.red,
          messageColor: Colors.red[300]!,
        );
      },
    );
  }

  static void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Thành công',
          message: message,
          buttonText: 'Đóng',
          titleColor: Colors.green,
          messageColor: Colors.green[300]!,
        );
      },
    );
  }
}
