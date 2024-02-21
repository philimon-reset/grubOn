import 'package:flutter/material.dart';
import 'package:grubOn/auth_service/firebase.dart';
import 'package:grubOn/auth_service/models/grocery_model.dart';
import 'package:grubOn/components/grocery/grocery_card.dart';

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  // set up database Services
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseService.getMyGroceries(),
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
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    GroceryModel grocery = myGroceries[index].data();
                    return Grocery(
                      grocery: grocery,
                      selling: false,
                    );
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
