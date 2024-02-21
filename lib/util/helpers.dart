import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
