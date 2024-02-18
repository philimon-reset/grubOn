import 'package:flutter/material.dart';
import 'package:foodbridge/auth_service/models/grocery_model.dart';
import 'package:foodbridge/pages/grocery/update_grocery.dart';
import 'package:foodbridge/util/helpers.dart';
import 'package:google_fonts/google_fonts.dart';

class Grocery extends StatelessWidget {
  final GroceryModel grocery;
  const Grocery({super.key, required this.grocery});

  @override
  Widget build(BuildContext context) {
    // update grocery page
    void displayGroceryUpdateModal() async {
      // Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateGrocery(
                    grocery: grocery,
                  )));
    }

    const double radius = 30.0;
    final String expiresAt = timeStampToDateTime(grocery.expireDate);
    final int price = grocery.price;
    final String count = grocery.count.toString();
    return GestureDetector(
      onLongPress: displayGroceryUpdateModal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 120,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
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
                      Text(grocery.name,
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
                              color: Color.fromARGB(255, 78, 180, 179)))
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
                      grocery.sellable
                          ? Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                              width: radius / 2.7,
                              height: radius / 2.7,
                            )
                          : Container(),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 165, 165, 165)),
                        child: Text("$count left",
                            style: GoogleFonts.karla(
                                fontSize: 14,
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
    );
  }
}
