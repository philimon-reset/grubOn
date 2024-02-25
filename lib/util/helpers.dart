import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart';
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

Future<List> checkFresh(File input) async {
  Interpreter interpreter = await loadModel();
  final List<List<List<num>>> imageMatrix = imageProcessor(input);

  final output = runInference(imageMatrix, interpreter);
  final maxValue = output.cast<double>().reduce(max);
  final maxIndex = output.indexOf(maxValue);
  final label = await loadLabels();
  final correctLabel = label[maxIndex];
  return [correctLabel, maxValue * 1000];
}

/// Load tflite model from assets
Future<Interpreter> loadModel() async {
  final interpreterOptions = InterpreterOptions();

  if (Platform.isAndroid) {
    interpreterOptions.addDelegate(XNNPackDelegate());
  }

  final interpreter =
      await Interpreter.fromAsset(modelAsset, options: interpreterOptions);
  return interpreter;
}

/// Load Labels from assets
Future<List<String>> loadLabels() async {
  print('Loading labels...');
  final labelsRaw = await rootBundle.loadString(labelAsset);
  return labelsRaw.split('\n');
}

List<List<List<num>>> imageProcessor(File imageCurrent) {
  // Reading image bytes from file
  final imageData = imageCurrent.readAsBytesSync();

// Decoding image
  final image = img.decodeImage(imageData);

// Resizing image fpr model, [300, 300]
  final imageInput = img.copyResize(
    image!,
    width: 256,
    height: 256,
  );
  final pixel = imageInput.getBytes(format: Format.rgb);

  final List<List<List<int>>> imageMatrix = [];
  for (int y = 0; y < imageInput.height; y++) {
    imageMatrix.add([]);
    for (int x = 0; x < imageInput.width; x++) {
      int red = pixel[y * imageInput.width * 3 + x * 3];
      int green = pixel[y * imageInput.width * 3 + x * 3 + 1];
      int blue = pixel[y * imageInput.width * 3 + x * 3 + 2];
      imageMatrix[y].add([red, green, blue]);
    }
  }

  return imageMatrix;
}

List runInference(List<List<List<num>>> imageMatrix, Interpreter interpreter) {
  print('Running inference...');

  // Set input tensor [1, 300, 300, 3]
  final input = [imageMatrix];

  // Set output tensor
  // Locations: [1, 10, 4]
  // Classes: [1, 10],
  // Scores: [1, 10],
  // Number of detections: [1]
  final output = {
    0: [List<num>.filled(16, 0)]
  };

  interpreter.runForMultipleInputs([input], output);
  final List<num> logits = output.values.toList()[0][0];

  final maxLogit = logits.cast<double>().reduce(max);

  // Shift the logits to avoid overflow during exponentiation
  final shiftedLogits = List.from(logits, growable: true);
  for (int i = 0; i < shiftedLogits.length; i++) {
    shiftedLogits[i] -= maxLogit;
  }

  // Calculate the sum of exponentiated values
  final sumExpShiftedLogits =
      shiftedLogits.map((e) => exp(e)).reduce((a, b) => a + b);

  // Normalize the values to sum to 1
  final softmaxValues = List.from(shiftedLogits, growable: true);
  for (int i = 0; i < softmaxValues.length; i++) {
    softmaxValues[i] = exp(shiftedLogits[i]) / sumExpShiftedLogits;
  }
  return softmaxValues;
}
