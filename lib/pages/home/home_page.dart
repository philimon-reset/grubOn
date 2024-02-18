import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge/components/home_components/drawer.dart';
import 'package:foodbridge/pages/grocery/add_grocery.dart';
import 'package:foodbridge/pages/grocery/grocery_page.dart';
import 'package:foodbridge/pages/home/profile_page.dart';
import 'package:foodbridge/pages/home/sellers_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // sign out user
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // go to profile page
  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

// current index of page
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Groceries(),
    SellersPage(),
  ];

  // display modal to create grocery
  void _displayGroceryAddModal() async {
    // Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddGrocery()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: _displayGroceryAddModal,
          backgroundColor: const Color.fromARGB(255, 78, 180, 179),
          child: Icon(
            _selectedIndex == 0 ? Icons.add : Icons.local_grocery_store,
            color: Colors.white,
          )),
      drawer: MyTools(profilePage: goToProfilePage, signUserOut: signUserOut),
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
      backgroundColor: Color.fromARGB(255, 78, 180, 179),
      body: Container(
        padding: EdgeInsets.only(bottom: 6),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
      bottomNavigationBar: GNav(
          selectedIndex: _selectedIndex,
          backgroundColor: Color.fromARGB(255, 78, 180, 179),
          gap: 10,
          activeColor: Colors.grey.shade200,
          hoverColor: Colors.grey.shade400,
          color: Colors.grey.shade500,
          iconSize: 30,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(icon: Icons.home, text: "Groceries"),
            GButton(
              icon: Icons.map,
              text: 'Buy',
            )
          ]),
    );
  }
}