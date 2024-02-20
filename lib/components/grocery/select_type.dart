import 'package:flutter/material.dart';
import 'package:foodbridge/auth_service/firebase.dart';
import 'package:foodbridge/components/field_components/text_box.dart';

class SelectGroceryType extends StatefulWidget {
  final TextEditingController typeController;
  final bool readOnly;
  const SelectGroceryType(
      {super.key, required this.typeController, required this.readOnly});

  @override
  State<SelectGroceryType> createState() => _SelectGroceryTypeState();
}

class _SelectGroceryTypeState extends State<SelectGroceryType> {
  // set up database Services
  final DatabaseService _databaseService = DatabaseService();

  // get food types
  Future<List> getTypes() async {
    final result =
        (await _databaseService.getFoodTypes()).data() as Map<String, dynamic>;
    return result["types"];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getTypes(),
        builder: (context, snapshot) {
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
                          borderSide: BorderSide(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade600),
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
        });
  }
}
