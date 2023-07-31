import 'package:flutter/material.dart';

class MyBuutton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  MyBuutton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Color.fromARGB(255, 47, 135, 130),
      child: Text(text),
    );
  }
}
