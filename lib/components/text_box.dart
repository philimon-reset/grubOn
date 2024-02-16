import 'package:flutter/material.dart';

class TextBox extends StatefulWidget {
  final controller;
  final String hintText;
  const TextBox({super.key, required this.controller, required this.hintText});

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
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
