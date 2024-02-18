import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge/components/util_components/my_list_tile.dart';

class MyTools extends StatelessWidget {
  final void Function()? signUserOut;
  final void Function()? profilePage;
  const MyTools(
      {super.key, required this.signUserOut, required this.profilePage});

  @override
  Widget build(BuildContext context) {
    // current user
    final currentUser = FirebaseAuth.instance.currentUser!;
    return Drawer(
      width: 200,
      backgroundColor: const Color.fromARGB(255, 78, 180, 179),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        // home
        Column(
          children: [
            // header
            const DrawerHeader(
              padding: EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xffE6E6E6),
                    radius: 40,
                    child: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 141, 139, 139),
                      size: 39,
                    ),
                  ),
                ],
              ),
            ),
            MyListTile(
              icon: Icons.home,
              text: "H O M E",
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // profile
            MyListTile(
              icon: Icons.person,
              text: "P R O F I L E",
              onTap: profilePage,
            ),
          ],
        ),
        // log out
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: MyListTile(
            icon: Icons.door_back_door,
            text: "L O G  O U T",
            onTap: signUserOut,
          ),
        ),
      ]),
    );
  }
}