import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function()? onTap;
  const MyListTile(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        onTap: onTap,
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          text,
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}
