import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge/auth_service/firebase.dart';
import 'package:foodbridge/auth_service/models/user_model.dart';
import 'package:foodbridge/components/my_button.dart';
import 'package:foodbridge/components/password_box.dart';
import 'package:foodbridge/components/show_error.dart';
import 'package:foodbridge/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // set up database Services
  final DatabaseService _databaseService = DatabaseService();
  // current user
  final currentUser = FirebaseAuth.instance.currentUser!;
  // text editing controllers
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  late final bool isEstablishment;
  late final UserModel user;
  late Future<UserModel> dataFuture;

  // setup inital values
  Future<UserModel> setInitalValues() async {
    final document = await _databaseService.getUserDetails();
    UserModel current = document.docs.first.data() as UserModel;
    emailController.text = current.email;
    userNameController.text = current.userName;
    passwordController.text = current.password;
    addressController.text = current.address;
    phoneNumberController.text = current.phoneNumber.toString();
    isEstablishment = current.isEstablishment;
    return current;
  }

  //update user
  void updateUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      UserModel updatedUser = user.copyWith(
          userName: userNameController.text.trim(),
          phoneNumber: int.parse(phoneNumberController.text.trim()),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          address: addressController.text.trim(),
          isEstablishment: isEstablishment);
      _databaseService.updateUserDetails(updatedUser.email, updatedUser);
      // leave page
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // Caught an exception from Firebase.
      print("Failed with error '${e.code}': ${e.message}");
    }
    Navigator.pop(context);
  }

  // inital state
  @override
  void initState() {
    super.initState();
    dataFuture = setInitalValues();
  }

// dispose controllers
  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(widthFactor: 2.3, child: Text('Edit Profile')),
      ),
      body: FutureBuilder(
          future: dataFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  return Text("We have the error: $error");
                } else if (snapshot.hasData) {
                  user = snapshot.data!;
                  return Center(
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xffE6E6E6),
                              radius: 50,
                              child: Icon(
                                Icons.person,
                                color: Color(0xffCCCCCC),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(currentUser.email!)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              TextBox(
                                controller: emailController,
                                hintText: "Email",
                              ),
                              PassWordTextField(
                                  controller: passwordController,
                                  hintText: "Password"),
                              TextBox(
                                controller: userNameController,
                                hintText: "User Name",
                              ),
                              TextBox(
                                controller: phoneNumberController,
                                hintText: "Phone Number",
                              ),
                              TextBox(
                                controller: addressController,
                                hintText: "Address",
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              TextButton(
                                onPressed: updateUser,
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.only(
                                      bottom: 20,
                                      left: 140,
                                      right: 140,
                                      top: 20),
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromRGBO(25, 37, 61, 1),
                                  textStyle: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text("Save!"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
            }
          }),
    );
  }
}
