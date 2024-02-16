import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge/components/drawer.dart';
import 'package:foodbridge/pages/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyTools(
        profilePage: goToProfilePage,
        signUserOut: signUserOut,
      ),
      appBar: AppBar(
        titleTextStyle: GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 20,
        ),
        title: const Center(child: Text("Home")),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ping Functionality')));
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(30)),
        child: Center(
            child: Text(
                "Home Page Logged in as: ${FirebaseAuth.instance.currentUser?.email}")),
      ),
      bottomNavigationBar: GNav(
          backgroundColor: const Color.fromRGBO(25, 37, 61, 1),
          gap: 10,
          activeColor: Colors.grey.shade200,
          hoverColor: Colors.grey.shade800,
          haptic: true,
          color: Colors.grey.shade700,
          iconSize: 30,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          tabs: const [
            GButton(icon: Icons.home, text: "Groceries"),
            GButton(
              icon: Icons.map,
              text: 'Map',
            )
          ]),
    );
  }
}
