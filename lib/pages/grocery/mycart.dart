import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grubOn/auth_service/firebase.dart';
import 'package:grubOn/auth_service/models/transaction_model.dart';
import 'package:grubOn/auth_service/models/user_model.dart';
import 'package:grubOn/components/grocery/cart_card.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    late final List myItems;

    void checkOut() async {
      try {
        databaseService.updateSoldGroceries(myItems);
        final UserModel myUser = (await databaseService.getUserDetails())
            .docs
            .first
            .data() as UserModel;
        for (final item in myItems) {
          TransactionModel myTransaction = TransactionModel(
              groceryId: item["id"],
              buyerEmail: myUser.email,
              amountBought: item["Amount"],
              buyerAddress: myUser.address,
              boughtOn: Timestamp.now());
          databaseService.addTransaction(myTransaction);
          databaseService.clearCart(item["id"]);
        }
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("Purchase Made!"),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        // pop once to remove dialog box
                        Navigator.pop(context);

                        // pop again to go to the previous screen
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.done_outlined))
                ],
              );
            });
      } catch (e) {
        print("Error on: ${e}");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(widthFactor: 1.8, child: Text('Shopping Cart')),
        actions: [
          Container(
            width: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary),
            child: IconButton(
              onPressed: checkOut,
              icon: const Icon(Icons.check),
              color: Colors.white,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: databaseService.getMyCart(),
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
                List myCart = snapshot.data?.docs ?? [];
                if (myCart.isEmpty) {
                  return const Center(
                    child: Text("No item in Your Cart"),
                  );
                } else {
                  myItems = myCart;
                  return ListView.builder(
                    itemCount: myCart.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> item = myCart[index].data();
                      return CartItem(
                        item: item,
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
      ),
    );
  }
}
