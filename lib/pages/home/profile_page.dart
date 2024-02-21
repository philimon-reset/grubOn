import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grubOn/auth_service/firebase.dart';
import 'package:grubOn/auth_service/models/user_model.dart';
import 'package:grubOn/components/home_components/profile_fields.dart';

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
  bool isEstablishment = false;
  late UserModel user;
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: CheckboxListTile(
                            title: const Text("Are you an Establishment?"),
                            value: isEstablishment,
                            onChanged: (bool? newValue) => {
                              setState(() {
                                isEstablishment = newValue!;
                              })
                            },
                            activeColor: Colors.purple,
                            checkColor: Colors.white,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        ProfileTextFields(
                          email: emailController,
                          address: addressController,
                          password: passwordController,
                          phoneNumber: phoneNumberController,
                          userName: userNameController,
                          callback: updateUser,
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
