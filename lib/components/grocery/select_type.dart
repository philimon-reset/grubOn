import 'package:flutter/material.dart';
import 'package:grubOn/auth_service/firebase.dart';
import 'package:grubOn/auth_service/models/pickup_model.dart';

class SelectGroceryType extends StatefulWidget {
  final TextEditingController typeController;
  final TextEditingController pickupController;
  final bool readOnly;
  const SelectGroceryType(
      {super.key,
      required this.typeController,
      required this.readOnly,
      required this.pickupController});

  @override
  State<SelectGroceryType> createState() => _SelectGroceryTypeState();
}

class _SelectGroceryTypeState extends State<SelectGroceryType> {
  // set up database Services
  final DatabaseService _databaseService = DatabaseService();

  bool loading = true;

  // get food types
  Future<List> getTypes() async {
    final result =
        (await _databaseService.getFoodTypes()).data() as Map<String, dynamic>;
    return result["types"];
  }

  // get pickup locations
  Future<List> getPickUps() async {
    final result = (await _databaseService.getPickUpLocations());
    return result.docs;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: getPickUps(),
            builder: (context, snapshot) {
              final ConnectionState currentConnection =
                  snapshot.connectionState;

              if ((currentConnection == ConnectionState.waiting) && loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                loading = false;
                if (snapshot.hasData) {
                  List<PickUpModel> pickups = (snapshot.data
                          ?.map<PickUpModel>((e) => e.data()))?.toList() ??
                      [];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: DropdownMenu(
                        enabled: widget.readOnly ? false : true,
                        initialSelection: widget.pickupController.text,
                        requestFocusOnTap: true,
                        leadingIcon: const Icon(Icons.search),
                        width: 340,
                        inputDecorationTheme: InputDecorationTheme(
                            disabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue.shade200),
                                borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade600),
                                borderRadius: BorderRadius.circular(12))),
                        label: const Text("Select Pick up location"),
                        dropdownMenuEntries: pickups
                            .map((e) =>
                                DropdownMenuEntry(value: e.name, label: e.name))
                            .toList(),
                        enableFilter: true,
                        onSelected: (value) {
                          if (value != null) {
                            setState(() {
                              widget.pickupController.text = value;
                            });
                          }
                        }),
                  );
                } else if (snapshot.hasError) {
                  final error = snapshot.error;
                  return Text("We have the error: $error");
                } else {
                  return const Center(child: Text("No Pick Up Location found"));
                }
              }
            }),
        FutureBuilder(
            future: getTypes(),
            builder: (context, snapshot) {
              final ConnectionState currentConnection =
                  snapshot.connectionState;
              if ((currentConnection == ConnectionState.waiting) && loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  List types = snapshot.data ?? [];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: DropdownMenu(
                        enabled: widget.readOnly ? false : true,
                        initialSelection: widget.typeController.text,
                        requestFocusOnTap: true,
                        leadingIcon: const Icon(Icons.search),
                        width: 340,
                        inputDecorationTheme: InputDecorationTheme(
                            disabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue.shade200),
                                borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade600),
                                borderRadius: BorderRadius.circular(12))),
                        label: const Text("Select Grocery Type"),
                        dropdownMenuEntries: types
                            .map((e) => DropdownMenuEntry(value: e, label: e))
                            .toList(),
                        enableFilter: true,
                        onSelected: (value) {
                          if (value != null) {
                            setState(() {
                              widget.typeController.text = value;
                            });
                          }
                        }),
                  );
                } else if (snapshot.hasError) {
                  final error = snapshot.error;
                  return Text("We have the error: $error");
                } else {
                  return const Center(child: Text("No Types"));
                }
              }
            }),
      ],
    );
  }
}
