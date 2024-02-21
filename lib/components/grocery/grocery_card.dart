import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodbridge/auth_service/firebase.dart';
import 'package:foodbridge/auth_service/models/grocery_model.dart';
import 'package:foodbridge/pages/grocery/addToCart.dart';
import 'package:foodbridge/pages/grocery/update_grocery.dart';
import 'package:foodbridge/util/helpers.dart';
import 'package:google_fonts/google_fonts.dart';

class Grocery extends StatefulWidget {
  final GroceryModel grocery;
  final bool selling;
  const Grocery({super.key, required this.grocery, required this.selling});

  @override
  State<Grocery> createState() => _GroceryState();
}

class _GroceryState extends State<Grocery> {
  // set up database Services
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    // update grocery page
    void displayGroceryUpdateModal() {
      // Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateGrocery(
                    grocery: widget.grocery,
                  )));
    }

    void displayGroceryAddtoCartModal() {
      // add to cart
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddToCard(
                    grocery: widget.grocery,
                  )));
    }

    void deleteGrocery(context) {
      _databaseService.deleteGrocery(widget.grocery.id);
      setState(() {});
    }

    const double radius = 30.0;
    final String expiresAt = timeStampToDateTime(widget.grocery.expireDate);
    final int price = widget.grocery.price;
    final String count = widget.grocery.count.toString();

    return GestureDetector(
      onTap: widget.selling
          ? displayGroceryAddtoCartModal
          : displayGroceryUpdateModal,
      child: Slidable(
        closeOnScroll: true,
        endActionPane: widget.selling
            ? null
            : ActionPane(motion: const StretchMotion(), children: [
                SlidableAction(
                  padding: const EdgeInsets.all(8),
                  onPressed: deleteGrocery,
                  icon: Icons.delete,
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: Colors.red,
                )
              ]),
        child: Container(
          margin: const EdgeInsets.all(8),
          height: 120,
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
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade500,
                  radius: 37,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xffE6E6E6),
                    radius: 35,
                    child: Icon(
                      Icons.food_bank,
                      color: Colors.grey.shade700,
                      size: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.grocery.name,
                            style: GoogleFonts.poppins(
                                fontSize: 26, fontWeight: FontWeight.bold)),
                        Text("Fresh until: $expiresAt",
                            style: GoogleFonts.firaCode(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800)),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("Price: $price€",
                            style: GoogleFonts.karla(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4EB4B3)))
                      ]),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.grocery.sellable
                            ? Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                width: radius / 2.7,
                                height: radius / 2.7,
                              )
                            : Container(),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 165, 165, 165)),
                          child: int.parse(count) >= 1
                              ? Text("$count left",
                                  style: GoogleFonts.karla(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black))
                              : Text("Out of Stock",
                                  style: GoogleFonts.karla(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
