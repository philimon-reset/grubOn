import 'package:flutter/material.dart';
import 'package:foodbridge/components/field_components/password_box.dart';
import 'package:foodbridge/components/field_components/text_box.dart';

class ProfileTextFields extends StatelessWidget {
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController userName;
  final TextEditingController phoneNumber;
  final TextEditingController address;
  final Function()? callback;

  const ProfileTextFields(
      {super.key,
      required this.email,
      required this.password,
      required this.userName,
      required this.phoneNumber,
      required this.address,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          MyTextBox(
            controller: email,
            hintText: "Email",
          ),
          PassWordTextField(controller: password, hintText: "Password"),
          MyTextBox(
            controller: userName,
            hintText: "User Name",
          ),
          MyTextBox(
            controller: phoneNumber,
            hintText: "Phone Number",
          ),
          MyTextBox(
            controller: address,
            hintText: "Address",
          ),
          const SizedBox(
            height: 80,
          ),
          TextButton(
            onPressed: callback,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.only(
                  bottom: 20, left: 140, right: 140, top: 20),
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 78, 180, 179),
              textStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text("Save!"),
          )
        ],
      ),
    );
  }
}
