import 'package:flutter/material.dart';
import 'package:foodbridge/auth_service/firebase.dart';
import 'package:foodbridge/auth_service/models/filter_provider.dart';
import 'package:foodbridge/auth_service/models/grocery_model.dart';
import 'package:foodbridge/components/grocery/grocery_card.dart';
import 'package:provider/provider.dart';

class SellersPage extends StatefulWidget {
  const SellersPage({super.key});

  @override
  State<SellersPage> createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage> {
  // set up database Services
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    List pickUps = context.watch<FilterModel>().filters;
    return StreamBuilder(
      stream: _databaseService.getSellableGroceries(pickUps),
      builder: sellerBuild,
    );
  }

  Widget sellerBuild(context, snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        return const Center(
          child: CircularProgressIndicator(),
        );
      default:
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'No Groceries Available',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          );
        } else if (snapshot.hasData) {
          List myGroceries = snapshot.data?.docs ?? [];
          if (myGroceries.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'No Groceries Available',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: myGroceries.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                GroceryModel grocery = myGroceries[index].data();
                return grocery.count >= 1
                    ? Grocery(
                        grocery: grocery,
                        selling: true,
                      )
                    : const SizedBox(width: 0, height: 0);
              },
            );
          }
        } else {
          return const Center(
            child: Text(
              'No Groceries Available',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          );
        }
    }
  }
}
