// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grubOn/auth_service/firebase.dart';
import 'package:grubOn/auth_service/models/grocery_model.dart';
import 'package:grubOn/auth_service/models/user_model.dart';
import 'package:grubOn/components/grocery/grocery_fields.dart';
import 'package:grubOn/components/util_components/show_error.dart';
import 'package:grubOn/util/helpers.dart';

class UpdateGrocery extends StatefulWidget {
  final GroceryModel grocery;
  const UpdateGrocery({super.key, required this.grocery});

  @override
  State<UpdateGrocery> createState() => _UpdateGroceryState();
}

class _UpdateGroceryState extends State<UpdateGrocery> {
  // text editing controllers
  final aboutController = TextEditingController();
  final nameController = TextEditingController();
  final photoController = TextEditingController();
  final typeController = TextEditingController();
  final expireDateController = TextEditingController();
  final priceController = TextEditingController();
  final pickupController = TextEditingController();

  // other variables
  ValueNotifier<bool> isSellable = ValueNotifier<bool>(false);
  ValueNotifier<bool> readOnly = ValueNotifier<bool>(true);
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
    counter.value = widget.grocery.count;
  }

  @override
  void initState() {
    super.initState();
    setInitalValues();
  }

// check if required fields are present
  Future<bool> isFieldsGood() async {
    Map<String, dynamic> requiredInputs = {
      'name': nameController.text,
      'price': priceController.text,
      'type': typeController.text,
      'pickup': pickupController.text,
      'expireDate': expireDateController.text,
    };
    if (requiredInputs.containsValue("")) {
      if (currentUser.isEstablishment == true && priceController.text.isEmpty) {
        await showErrorDialog(context, "Price is required");
        return false;
      } else {
        List<String> missing = requiredInputs.entries
            .map((item) {
              if (item.value.isEmpty) {
                return item.key;
              }
            })
            .whereType<String>()
            .toList();
        await showErrorDialog(context, "Missing Field: $missing");
        return false;
      }
    } else if (requiredInputs["name"].length > 15) {
      await showErrorDialog(context, "Name can't be more than 15 characters");
      return false;
    } else {
      return true;
    }
  }

  // update selected grocery
  void updateGroceryModel() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      bool success = await isFieldsGood();
      if (success && currentUser.email.isNotEmpty) {
        DateTime expireDate = DateTime.parse(expireDateController.text);
        GroceryModel newGrocery = widget.grocery.copyWith(
            count: counter.value,
            pickup: pickupController.text.trim(),
            about: aboutController.text.trim(),
            name: nameController.text.trim(),
            sellable: isSellable.value,
            price: int.parse(priceController.text.trim()),
            type: typeController.text.trim(),
            expireDate: Timestamp.fromDate(
                DateTime(expireDate.year, expireDate.month, expireDate.day)));
        _databaseService.updateGrocery(widget.grocery.id, newGrocery);
        // leave page
        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      // Caught an exception from Firebase.
      print("Failed with error '${e.code}': ${e.message}");
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              widthFactor: 1.8, child: Text('Update your Grocery')),
          actions: [
            CircleAvatar(
              radius: 20,
              backgroundColor: readOnly.value
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
              child: IconButton(
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    readOnly.value = !readOnly.value;
                    turns += 1 / 4;
                  });
                },
                icon: AnimatedRotation(
                    turns: turns,
                    duration: const Duration(milliseconds: 400),
                    child: const Icon(Icons.settings)),
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: ListView(
          children: [
            GroceryFields(
                pickupController: pickupController,
                totalCount: counter.value,
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
            AnimatedSwitcher(
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              duration: const Duration(milliseconds: 400),
              child: readOnly.value ? const SizedBox() : updateButton(),
            )
          ],
        ));
  }

  Widget updateButton() {
    return TextButton(
      onPressed: updateGroceryModel,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding:
            const EdgeInsets.only(bottom: 20, top: 20, left: 80, right: 80),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textStyle: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: const Text("Update!"),
    );
  }
}
