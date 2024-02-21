import 'package:flutter/material.dart';
import 'package:grubOn/auth_service/firebase.dart';
import 'package:grubOn/auth_service/models/filter_provider.dart';
import 'package:grubOn/auth_service/models/grocery_model.dart';
import 'package:grubOn/components/grocery/grocery_card.dart';
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
          List myGroceries = (snapshot.data?.docs) ?? [];
          List checkedGroceries = myGroceries
              .where((element) => element.data().count >= 1)
              .toList();
          if (checkedGroceries.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'No Groceries Available.\nTry Changing Pick Up Location',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: checkedGroceries.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                GroceryModel grocery = checkedGroceries[index].data();
                return Grocery(
                  grocery: grocery,
                  selling: true,
                );
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
