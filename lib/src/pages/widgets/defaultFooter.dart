import 'package:flutter/material.dart';

class DefaultFooter extends StatelessWidget {
  final String footerText;

  const DefaultFooter({Key? key, required this.footerText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: const Color.fromARGB(255, 136, 200, 247),
        child: Center(
          child: Text(footerText),
        ),
      ),
    );
  }
}
