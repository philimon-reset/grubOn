import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

const modelAsset =
    "lib/util/fruitFreshnessModel/Models/fruitFreshnessModel.tflite";
const labelAsset = "lib/util/fruitFreshnessModel/Models/labels.txt";

String timeStampToDateTime(Timestamp value) {
  final DateTime tsdate = value.toDate();
  final DateTime newDate = DateTime(tsdate.year, tsdate.month, tsdate.day);
  return newDate.toString().split(" ")[0];
}

Future<LatLng> getUserLocationPermission(
    Location location, Function cameraPosition) async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LatLng currentP = const LatLng(53.16809844970703, 8.651703834533691);
  // LocationData currentData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return currentP;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return currentP;
    }
  }
  location.onLocationChanged.listen((LocationData currentLocation) {
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      cameraPosition(currentP);
    }
  });
  return currentP;
}

Future<void> checkFresh(File input) async {
  imageProcessor(input);
}

Future<void> initTensorFlow() async {
  // model: "lib/util/fruitFreshnessModel/Models/fruitFreshnessModel.tflite",
  // labels: "lib/util/fruitFreshnessModel/Models/labels.txt",
}

/// Load tflite model from assets
Future<void> loadModel() async {
  print('Loading interpreter options...');
  final interpreterOptions = InterpreterOptions();

  if (Platform.isAndroid) {
    interpreterOptions.addDelegate(XNNPackDelegate());
  }

  print('Loading interpreter...');
  final _interpreter =
      await Interpreter.fromAsset(modelAsset, options: interpreterOptions);
}

/// Load Labels from assets
Future<void> loadLabels() async {
  print('Loading labels...');
  final labelsRaw = await rootBundle.loadString(labelAsset);
  final _labels = labelsRaw.split('\n');
}

List imageProcessor(File imageCurrent) {
  // Reading image bytes from file
  final imageData = imageCurrent.readAsBytesSync();

// Decoding image
  final image = img.decodeImage(imageData);

// Resizing image fpr model, [300, 300]
  final imageInput = img.copyResize(
    image!,
    width: 300,
    height: 300,
  );

// Creating matrix representation, [300, 300, 3]
  final imageMatrix = List.generate(
    imageInput.height,
    (y) => List.generate(
      imageInput.width,
      (x) {
        final pixel = imageInput.getPixel(x, y);
        return [pixel, pixel, pixel];
      },
    ),
  );
  print(imageMatrix);
  return imageMatrix;
}
