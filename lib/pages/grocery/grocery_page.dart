import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge/auth_service/firebase.dart';
import 'package:foodbridge/auth_service/models/grocery_model.dart';
import 'package:foodbridge/components/grocery/grocery_card.dart';

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  // needed variables

  // set up database Services
  final DatabaseService _databaseService = DatabaseService();
  // current user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // inital state
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseService.getGroceries(),
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
              List myGroceries = snapshot.data?.docs ?? [];
              if (myGroceries.isEmpty) {
                return const Center(
                  child: Text("Add your Grocery List"),
                );
              } else {
                return ListView.builder(
                  itemCount: myGroceries.length,
                  padding: EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    GroceryModel grocery = myGroceries[index].data();
                    return Grocery(grocery: grocery);
                  },
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        }
      },
    );
  }
}
