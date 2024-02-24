import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grubOn/util/helpers.dart';
import 'package:image_picker/image_picker.dart';

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
                      color: Colors.blue,
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
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () => checkFresh(imageFile!),
                    ),
                  ),
                ],
              )
            ])
          : TextButton(
              onPressed: pickImage,
              child: const Center(child: Text("Select image"))),
    );
  }
}
