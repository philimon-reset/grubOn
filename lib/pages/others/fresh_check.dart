// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grubOn/util/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FreshCheck extends StatefulWidget {
  const FreshCheck({super.key});

  @override
  State<FreshCheck> createState() => _FreshCheckState();
}

class _FreshCheckState extends State<FreshCheck> {
  File? imageFile;

  Future<void> pickImage() async {
    final selected = await ImagePicker().pickImage(source: ImageSource.camera);

    return selected != null
        ? setState(() {
            imageFile = File(selected.path);
          })
        : null;
  }

  void checkOut() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      final List result = await checkFresh(imageFile!);
      final String catagory = result[0];
      final double confidence = result[1];
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      animation: true,
                      animationDuration: 1000,
                      radius: 100,
                      lineWidth: 30,
                      percent: (confidence / 100),
                      progressColor: Colors.deepPurple,
                      backgroundColor: Colors.deepPurple.shade100,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        "${confidence.round().toString()}%",
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Category: ",
                      style: GoogleFonts.roboto(fontSize: 25),
                    ),
                    Text(
                      "$catagory",
                      style: GoogleFonts.roboto(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
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
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(widthFactor: 2, child: Text('Fresh Check')),
      ),
      body: imageFile != null
          ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.file(
                    imageFile!,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade400),
                    child: const Center(
                      child: Text("Check if the item is fresh"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary),
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () => checkOut(),
                    ),
                  )
                ],
              ),
            ])
          : TextButton(
              onPressed: pickImage,
              child: const Center(child: Text("Select image"))),
    );
  }
}
