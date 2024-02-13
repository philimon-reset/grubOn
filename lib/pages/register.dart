import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:foodbridge/components/my_button.dart";
import "package:foodbridge/components/my_textfield.dart";
import "package:foodbridge/components/squareTile.dart";
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  // initalization controllers
  const RegisterPage({super.key, required this.onTap});

  final Function()? onTap;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final userPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

// dispose controllers
  @override
  void dispose() {
    emailController.dispose();
    userPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // sign user in method
  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      // check if password and confirm password is the same
      if (userPasswordController.text == confirmPasswordController.text) {
        // create user
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text,
                password: userPasswordController.text);
      } else {
        await showErrorDialog(context, "Passwords do not match");
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      switch (e.code) {
        case 'weak-password':
          // ignore: use_build_context_synchronously
          await showErrorDialog(context, "Password is too weak");
          break;
        case 'email-already-in-use':
          // ignore: use_build_context_synchronously
          await showErrorDialog(context, "Email already in use");
          break;
        case 'invalid-email':
          // ignore: use_build_context_synchronously
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
            backgroundColor: const Color.fromRGBO(25, 37, 61, 1),
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
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.door_front_door_outlined,
                    size: 60,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Welcome",
                    style: GoogleFonts.robotoMono(fontSize: 30),
                  ),
                  const Text("Fill in the details below to Register"),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    hideText: false,
                  ),
                  const SizedBox(height: 10),
                  // Set Password
                  MyTextField(
                    controller: userPasswordController,
                    hintText: "Password",
                    hideText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Confirm Password
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    hideText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(buttonName: "Sign Up", onTap: signUserUp),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
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
                      const Text("Already a Member?"),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Sign In",
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
