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
            backgroundColor: const Color.fromRGBO(25, 37, 61, 1),
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

// Container(
//           padding: const EdgeInsets.all(20),
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: BoxDecoration(
//               color: Colors.black, borderRadius: BorderRadius.circular(8)),
//           child: Text(
//             buttonName,
//             style: const TextStyle(
//                 color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         )