import 'package:flutter/material.dart';
import 'package:grubOn/components/field_components/date_field.dart';
import 'package:grubOn/components/field_components/text_box.dart';
import 'package:grubOn/components/grocery/select_type.dart';
import 'package:google_fonts/google_fonts.dart';

class GroceryFields extends StatefulWidget {
  final TextEditingController aboutController;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController expireDateController;
  final TextEditingController typeController;
  final TextEditingController pickupController;
  final Function()? callback;
  final bool? notCartPage;
  final ValueNotifier<bool> isSellable;
  final ValueNotifier<bool> readOnly;
  final ValueNotifier<int> counter;
  final int totalCount;

  const GroceryFields({
    super.key,
    required this.aboutController,
    required this.nameController,
    required this.priceController,
    required this.expireDateController,
    this.callback,
    required this.readOnly,
    required this.typeController,
    required this.isSellable,
    required this.counter,
    this.notCartPage = true,
    required this.totalCount,
    required this.pickupController,
  });

  @override
  State<GroceryFields> createState() => _GroceryFieldsState();
}

class _GroceryFieldsState extends State<GroceryFields> {
  // thumbIcon for switch
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  // increment counter
  void incrementCount() {
    setState(() {
      if (widget.notCartPage == false) {
        widget.counter.value < widget.totalCount
            ? widget.counter.value++
            : widget.counter.value;
      } else {
        widget.counter.value++;
      }
    });
  }

  // decrement counter
  void decrementCount() {
    setState(() {
      widget.counter.value > 1
          ? widget.counter.value--
          : widget.counter.value = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: ValueListenableBuilder(
        valueListenable: widget.readOnly,
        builder: (context, value, child) {
          return Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 55,
                child: CircleAvatar(
                  backgroundColor: const Color(0xffE6E6E6),
                  radius: 50,
                  child: Icon(
                    Icons.food_bank,
                    color: Colors.grey.shade700,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SelectGroceryType(
                  readOnly: widget.readOnly.value,
                  typeController: widget.typeController,
                  pickupController: widget.pickupController),
              MyTextBox(
                controller: widget.nameController,
                hintText: "Name",
                readOnly: widget.readOnly.value,
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                          readOnly: widget.readOnly.value,
                          controller: widget.priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              label: const Text("Price"),
                              hintText: "Price",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade600),
                                  borderRadius: BorderRadius.circular(12)),
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DateField(
                          readOnly: widget.readOnly.value,
                          label: "Expire Date",
                          controller: widget.expireDateController),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: SizedBox(
                  height: 100,
                  child: TextField(
                    readOnly: widget.readOnly.value,
                    expands: true,
                    maxLines: null,
                    controller: widget.aboutController,
                    decoration: InputDecoration(
                        label: const Text("More Info"),
                        hintText: "More Info",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade600),
                            borderRadius: BorderRadius.circular(12)),
                        fillColor: Colors.white,
                        filled: true),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ValueListenableBuilder(
                      builder: (context, value, child) {
                        return Switch(
                          thumbIcon: thumbIcon,
                          value: widget.isSellable.value,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: widget.readOnly.value
                              ? (bool value) {}
                              : (bool value) {
                                  setState(() {
                                    widget.isSellable.value = value;
                                  });
                                },
                        );
                      },
                      valueListenable: widget.isSellable,
                    ),
                    const Text("Are you selling this item?"),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // minus button
                  (widget.readOnly.value) && (widget.notCartPage ?? true)
                      ? Container(
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: IconButton(
                              icon: const Icon(null), onPressed: () {}),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle),
                          child: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: decrementCount),
                        ),
                  // current count
                  SizedBox(
                      width: 50,
                      child: Center(
                          child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.primary),
                        child: Text(
                          widget.counter.value.toString(),
                          style: GoogleFonts.roboto(color: Colors.white),
                        ),
                      ))),
                  // plus button
                  (widget.readOnly.value && (widget.notCartPage ?? true))
                      ? Container(
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: IconButton(
                              icon: const Icon(null), onPressed: () {}),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle),
                          child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: incrementCount),
                        )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
