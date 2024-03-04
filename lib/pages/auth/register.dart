import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:grubOn/auth_service/firebase.dart";
import "package:grubOn/auth_service/models/user_model.dart";
import 'package:grubOn/components/util_components/my_button.dart';
import 'package:grubOn/components/field_components/my_textfield.dart';
import 'package:grubOn/components/util_components/show_error.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:lottie/lottie.dart";

class RegisterPage extends StatefulWidget {
  // initalization controllers
  const RegisterPage({super.key, required this.onTap});

  final Function()? onTap;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // set up database Services
  final DatabaseService _databaseService = DatabaseService();

  // text editing controllers
  final emailController = TextEditingController();
  final userPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final userNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  bool? isEstablishedController = false;

// dispose controllers
  @override
  void dispose() {
    emailController.dispose();
    userPasswordController.dispose();
    confirmPasswordController.dispose();
    userNameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: userPasswordController.text.trim());

        // add user details
        UserModel user = UserModel(
            createdOn: Timestamp.now(),
            userName: userNameController.text.trim(),
            phoneNumber: int.parse(phoneNumberController.text.trim()),
            email: emailController.text.trim(),
            address: addressController.text.trim(),
            password: userPasswordController.text.trim(),
            isEstablishment: isEstablishedController!);
        // add user
        _databaseService.addUserDetails(user);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Lottie.network(
                        "https://lottie.host/229d1e0c-275c-48ac-9f96-fecc3f28eecc/daGNEOchku.json"),
                  ),
                  Text(
                    "Welcome",
                    style: GoogleFonts.robotoMono(fontSize: 30),
                  ),
                  const Text("Fill in the details below to Register"),
                  const SizedBox(height: 10),
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
                  // userName
                  MyTextField(
                    controller: userNameController,
                    hintText: "User Name",
                    hideText: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Phone Number
                  MyTextField(
                    controller: phoneNumberController,
                    hintText: "Phone Number",
                    hideText: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // Set Address
                  MyTextField(
                    controller: addressController,
                    hintText: "Address",
                    hideText: false,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CheckboxListTile(
                      title: const Text("Are you an Establishment?"),
                      value: isEstablishedController,
                      onChanged: (bool? newValue) => {
                        setState(() {
                          isEstablishedController = newValue;
                        })
                      },
                      activeColor: Colors.purple,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  MyButton(buttonName: "Sign Up", onTap: signUserUp),
                  // Padding(
                  //   padding: const EdgeInsets.all(14.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Divider(
                  //               thickness: 0.5, color: Colors.grey.shade400)),
                  //       const Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 10.0),
                  //         child: Text("or Continue with"),
                  //       ),
                  //       Expanded(
                  //           child: Divider(
                  //               thickness: 0.5, color: Colors.grey.shade400))
                  //     ],
                  //   ),
                  // ),
                  // Google sign in
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [SquareTile(imagePath: "lib/images/google.png")],
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Register Now
                  const SizedBox(
                    height: 20,
                  ),
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
