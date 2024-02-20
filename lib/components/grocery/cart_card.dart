import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodbridge/auth_service/firebase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final Map<String, dynamic> item;
  const CartItem({super.key, required this.item});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  // // increment counter
  // void incrementCount() {
  //   setState(() {
  //     widget.item["Amount"] < widget.item["maxAmount"]
  //         ? widget.item["Amount"]++
  //         : widget.item["Amount"];
  //   });
  // }

  // // decrement counter
  // void decrementCount() {
  //   setState(() {
  //     widget.item["Amount"] > 1
  //         ? widget.item["Amount"]--
  //         : widget.item["Amount"] = 1;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    void deleteCartItem() {
      databaseService.deleteCartItem(widget.item["id"]);
    }

    return Consumer(
      builder: (context, value, child) => Container(
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: ListTile(
          title: Text(widget.item["groceryName"]),
          subtitle: Text("Selected: ${widget.item["Amount"]}"),
          trailing: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.red),
              child: IconButton(
                onPressed: deleteCartItem,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              )),
        ),
      ),
    );
  }
}
