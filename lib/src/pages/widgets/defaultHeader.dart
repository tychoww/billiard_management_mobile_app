// ignore: file_names
import 'package:flutter/material.dart';

class DefaultHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;

  const DefaultHeader({Key? key, required this.title, required this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1, // Điều chỉnh tỷ lệ chiếm không gian của phần này
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 136, 200, 247),
          border: Border(
            bottom: BorderSide(
                width: 3.0, color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
