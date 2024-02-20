// ignore_for_file: use_build_context_synchronously

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:foodbridge/components/util_components/my_button.dart';
import 'package:foodbridge/components/field_components/my_textfield.dart';
import 'package:foodbridge/components/util_components/squareTile.dart';
import "package:google_fonts/google_fonts.dart";

class LoginPage extends StatefulWidget {
  // initalization controllers
  const LoginPage({super.key, required this.onTap});

  final Function()? onTap;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final userPasswordController = TextEditingController();

// dispose controllers
  @override
  void dispose() {
    emailController.dispose();
    userPasswordController.dispose();
    super.dispose();
  }

  // sign user in method
  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: userPasswordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      switch (e.code) {
        case 'user-not-found':
          await showErrorDialog(context, "User not found");
          break;
        case 'wrong-password':
          await showErrorDialog(context, "Wrong Credentials");
          break;
        case 'invalid-email':
          await showErrorDialog(context, "Invalid Email");
          break;
        default:
          print(e.code);
      }
    }
  }

  Future<void> showErrorDialog(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("An error occurred",
                style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 78, 180, 179),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.grey.shade100),
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Hello Again",
                    style: GoogleFonts.robotoMono(fontSize: 30),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    hideText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: userPasswordController,
                    hintText: "Password",
                    hideText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Forgot Password
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Forgot Password?"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(buttonName: "Sign In", onTap: signUserIn),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                                thickness: 0.5, color: Colors.grey.shade400)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("or Continue with"),
                        ),
                        Expanded(
                            child: Divider(
                                thickness: 0.5, color: Colors.grey.shade400))
                      ],
                    ),
                  ),
                  // Google sign in
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [SquareTile(imagePath: "lib/images/google.png")],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Register Now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a Member?"),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Register Now",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
