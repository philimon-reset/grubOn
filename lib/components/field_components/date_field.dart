import 'package:flutter/material.dart';

class DateField extends StatefulWidget {
  final String label;
  final bool readOnly;
  final TextEditingController controller;
  const DateField(
      {super.key,
      required this.label,
      required this.controller,
      required this.readOnly});

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  @override
  Widget build(BuildContext context) {
    Future<void> selectDate() async {
      DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100));
      if (picked != null) {
        setState(() {
          widget.controller.text = picked.toString().split(" ")[0];
        });
      }
    }

    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.today),
          labelText: widget.label,
          hintText: "Pick a date",
          hintStyle: TextStyle(color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(12)),
          fillColor: Colors.white,
          filled: true),
      onTap: widget.readOnly ? () {} : selectDate,
      readOnly: true,
    );
  }
}
