import 'package:flutter/material.dart';

class MyTextBox extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? readOnly;
  const MyTextBox(
      {super.key,
      required this.controller,
      required this.hintText,
      this.readOnly});

  @override
  State<MyTextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<MyTextBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextField(
          readOnly: widget.readOnly ?? false,
          controller: widget.controller,
          decoration: InputDecoration(
              label: Text(widget.hintText),
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(12)),
              fillColor: Colors.white,
              filled: true)),
    );
  }
}
