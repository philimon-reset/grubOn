// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge/auth_service/firebase.dart';
import 'package:foodbridge/auth_service/models/grocery_model.dart';
import 'package:foodbridge/auth_service/models/user_model.dart';
import 'package:foodbridge/components/grocery/grocery_fields.dart';
import 'package:foodbridge/components/util_components/show_error.dart';

class AddGrocery extends StatefulWidget {
  const AddGrocery({super.key});

  @override
  State<AddGrocery> createState() => _AddGroceryState();
}

class _AddGroceryState extends State<AddGrocery> {
  // text editing controllers
  final aboutController = TextEditingController();
  final nameController = TextEditingController();
  final photoController = TextEditingController();
  final priceController = TextEditingController();
  final typeController = TextEditingController();
  final expireDateController = TextEditingController();

  // set up database Services
  final DatabaseService _databaseService = DatabaseService();
  late final UserModel currentUser;

  // other variables
  final ValueNotifier<bool> readOnly = ValueNotifier<bool>(false);

  void setInitalValues() async {
    final document = await _databaseService.getUserDetails();
    currentUser = document.docs.first.data() as UserModel;
  }

  // dispose controllers
  @override
  void dispose() {
    aboutController.dispose();
    nameController.dispose();
    photoController.dispose();
    priceController.dispose();
    typeController.dispose();
    expireDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setInitalValues();
  }

  // other variables
  // other variables
  ValueNotifier<bool> isSellable = ValueNotifier<bool>(false);
  ValueNotifier<int> counter = ValueNotifier<int>(1);

// check if required fields are present
  Future<bool> isFieldsGood() async {
    Map<String, dynamic> requiredInputs = {
      'name': nameController.text,
      'price': priceController.text,
      'type': typeController.text,
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

  void createGrocery() async {
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
        GroceryModel newGrocery = GroceryModel(
            userEmail: currentUser.email,
            count: counter.value,
            about: aboutController.text,
            name: nameController.text,
            sellable: isSellable.value,
            price: int.parse(priceController.text),
            type: typeController.text,
            postDate: Timestamp.now(),
            expireDate: Timestamp.fromDate(
                DateTime(expireDate.year, expireDate.month, expireDate.day)));
        _databaseService.addGroceries(newGrocery);
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

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(widthFactor: 1.8, child: Text('Add a Grocery')),
      ),
      body: ListView(children: [
        GroceryFields(
          typeController: typeController,
          aboutController: aboutController,
          nameController: nameController,
          priceController: priceController,
          expireDateController: expireDateController,
          readOnly: readOnly,
          isSellable: isSellable,
          counter: counter,
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: TextButton(
            onPressed: createGrocery,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 78, 180, 179),
              textStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text("Add"),
          ),
        )
      ]),
    );
  }
}
