import 'package:flutter/material.dart';

class FreshCheck extends StatefulWidget {
  const FreshCheck({super.key});

  @override
  State<FreshCheck> createState() => _FreshCheckState();
}

class _FreshCheckState extends State<FreshCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(widthFactor: 2, child: Text('Fresh Check')),
      ),
    );
  }
}
