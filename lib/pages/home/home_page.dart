import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grubOn/auth_service/models/filter_provider.dart';
import 'package:grubOn/components/home_components/drawer.dart';
import 'package:grubOn/pages/grocery/add_grocery.dart';
import 'package:grubOn/pages/grocery/mycart.dart';
import 'package:grubOn/pages/home/grocery_page.dart';
import 'package:grubOn/pages/home/profile_page.dart';
import 'package:grubOn/pages/home/sellers_page.dart';
import 'package:grubOn/pages/others/fresh_check.dart';
import 'package:grubOn/pages/others/map_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

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

  // go to fresh Checker
  void freshCheck() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const FreshCheck()));
  }

// current index of page
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Groceries(),
    SellersPage(),
  ];

  // display modal to create grocery
  void _displayGroceryAddModal() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddGrocery()));
  }

  // display modal for map
  void _displayMapFilter() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyMap()));
  }

  // display modal for shopping cart
  void displayShoppingCart() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyCart()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed:
              _selectedIndex == 0 ? _displayGroceryAddModal : _displayMapFilter,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            _selectedIndex == 0 ? Icons.add : Icons.map,
            color: Colors.white,
          )),
      drawer: MyTools(
        profilePage: goToProfilePage,
        signUserOut: signUserOut,
        freshCheck: freshCheck,
      ),
      appBar: AppBar(
        titleTextStyle: GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 20,
        ),
        title: const Center(child: Text("Home")),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove),
            tooltip: 'Clear Filter',
            onPressed: () => context.read<FilterModel>().removeFilters(),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Shopping Cart',
            onPressed: displayShoppingCart,
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
      bottomNavigationBar: GNav(
          selectedIndex: _selectedIndex,
          backgroundColor: Theme.of(context).colorScheme.primary,
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
              icon: Icons.shopping_bag,
              text: 'Buy',
            )
          ]),
    );
  }
}
