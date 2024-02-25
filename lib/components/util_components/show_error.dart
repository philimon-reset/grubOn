import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("An error occurred",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"))
          ],
        );
      });
}
