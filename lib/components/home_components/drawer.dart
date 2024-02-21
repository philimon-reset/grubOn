import 'package:flutter/material.dart';
import 'package:foodbridge/components/util_components/my_list_tile.dart';

class MyTools extends StatelessWidget {
  final void Function() signUserOut;
  final void Function() profilePage;
  final void Function() freshCheck;
  const MyTools(
      {super.key,
      required this.signUserOut,
      required this.profilePage,
      required this.freshCheck});

  @override
  Widget build(BuildContext context) {
    // current user
    return Drawer(
      width: 240,
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
            MyListTile(
                icon: Icons.camera,
                text: "F R E S H N E S S\nC H E C K",
                onTap: freshCheck)
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
