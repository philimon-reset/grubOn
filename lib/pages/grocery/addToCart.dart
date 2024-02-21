// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grubOn/auth_service/firebase.dart';
import 'package:grubOn/auth_service/models/grocery_model.dart';
import 'package:grubOn/auth_service/models/user_model.dart';
import 'package:grubOn/components/grocery/grocery_fields.dart';
import 'package:grubOn/util/helpers.dart';

class AddToCard extends StatefulWidget {
  final GroceryModel grocery;
  const AddToCard({super.key, required this.grocery});

  @override
  State<AddToCard> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCard> {
  // text editing controllers
  final aboutController = TextEditingController();
  final nameController = TextEditingController();
  final photoController = TextEditingController();
  final typeController = TextEditingController();
  final expireDateController = TextEditingController();
  final priceController = TextEditingController();
  final pickupController = TextEditingController();

  // other variables
  ValueNotifier<bool> readOnly = ValueNotifier<bool>(true);
  ValueNotifier<bool> isSellable = ValueNotifier<bool>(true);
  ValueNotifier<int> counter = ValueNotifier<int>(1);
  double turns = 0.0;

  // set up database Services
  final DatabaseService _databaseService = DatabaseService();
  late final UserModel currentUser;

  void setInitalValues() async {
    final document = await _databaseService.getUserDetails();
    currentUser = document.docs.first.data() as UserModel;
    aboutController.text = widget.grocery.about;
    nameController.text = widget.grocery.name;
    pickupController.text = widget.grocery.pickup;
    photoController.text = widget.grocery.photo ?? "";
    typeController.text = widget.grocery.type;
    expireDateController.text = timeStampToDateTime(widget.grocery.expireDate);
    priceController.text = widget.grocery.price.toString();
    isSellable.value = widget.grocery.sellable;
  }

  @override
  void initState() {
    super.initState();
    setInitalValues();
  }

  // selected grocery
  void addToCart() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      if (currentUser.email.isNotEmpty) {
        _databaseService.addToCart(
            widget.grocery, currentUser.email, counter.value);
        // leave page
        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      // Caught an exception from Firebase.
      print("Failed with error '${e.code}': ${e.message}");
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text("Item Successfully added To Cart"),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    // pop once to remove dialog box
                    Navigator.pop(context);

                    // pop again to go to the previous screen
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.done_outlined))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(widthFactor: 1.8, child: Text('Add to Cart')),
        ),
        body: ListView(
          children: [
            GroceryFields(
                pickupController: pickupController,
                totalCount: widget.grocery.count,
                notCartPage: false,
                aboutController: aboutController,
                nameController: nameController,
                priceController: priceController,
                expireDateController: expireDateController,
                typeController: typeController,
                readOnly: readOnly,
                isSellable: isSellable,
                counter: counter),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextButton(
                onPressed: addToCart,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.only(
                      bottom: 20, top: 20, left: 80, right: 80),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 78, 180, 179),
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Add item to Cart"),
              ),
            )
          ],
        ));
  }
}
