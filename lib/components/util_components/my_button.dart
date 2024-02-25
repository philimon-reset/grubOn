import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonName;
  final Function()? onTap;
  const MyButton({super.key, required this.buttonName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding:
                EdgeInsets.only(bottom: 20, left: 100, right: 100, top: 20),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Text(buttonName),
        ),
      ],
    );
  }
}
