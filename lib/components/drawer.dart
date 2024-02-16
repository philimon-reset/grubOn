import 'package:flutter/material.dart';
import 'package:foodbridge/components/my_list_tile.dart';

class MyTools extends StatelessWidget {
  final void Function()? signUserOut;
  final void Function()? profilePage;
  const MyTools(
      {super.key, required this.signUserOut, required this.profilePage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: const Color.fromRGBO(25, 37, 61, 1),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        // home
        Column(
          children: [
            // header
            const DrawerHeader(
                child: Icon(Icons.person, color: Colors.white, size: 50)),
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
