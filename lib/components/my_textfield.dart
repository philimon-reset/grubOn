import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool hideText;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.hideText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
          controller: controller,
          obscureText: hideText,
          decoration: InputDecoration(
              constraints: BoxConstraints(maxHeight: 60),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(20)),
              fillColor: Colors.white,
              filled: true)),
    );
  }
}
