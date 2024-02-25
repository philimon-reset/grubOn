import 'package:flutter/material.dart';

class PassWordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  const PassWordTextField(
      {super.key, required this.controller, required this.hintText});

  @override
  State<PassWordTextField> createState() => _PassWordTextFieldState();
}

class _PassWordTextFieldState extends State<PassWordTextField> {
  bool hideText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextField(
          controller: widget.controller,
          obscureText: hideText,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: (hideText)
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    hideText = !hideText;
                  });
                },
              ),
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
