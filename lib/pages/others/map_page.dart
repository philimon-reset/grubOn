import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grubOn/auth_service/firebase.dart';
import 'package:grubOn/auth_service/models/filter_provider.dart';
import 'package:grubOn/auth_service/models/pickup_model.dart';
import 'package:grubOn/util/helpers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  // set up database Services
  final DatabaseService _databaseService = DatabaseService();

  // set up variables
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

// add custom icon
  void addCustomIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "lib/images/icons/icons8-home-128.png");
    setState(() {});
  }

  // get Locations
  Future<List<PickUpModel>> getLocations() async {
    final List<PickUpModel> pickups = [];
    final QuerySnapshot locations =
        (await _databaseService.getPickUpLocations());
    for (final location in locations.docs) {
      final PickUpModel current = location.data() as PickUpModel;
      pickups.add(current);
    }
    return pickups;
  }

  // center User position
  Future centerPosition(LatLng current) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition cameraPosition = CameraPosition(target: current, zoom: 14);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    super.initState();
    addCustomIcon();
  }

  Location locationController = Location();
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(widthFactor: 1.8, child: Text('Pick Up Locations')),
      ),
      body: FutureBuilder(
        future: Future.wait([
          getUserLocationPermission(locationController, centerPosition),
          getLocations()
        ]),
        builder: (
          context,
          AsyncSnapshot<List> snapshot,
        ) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasData) {
                // set user location
                final user = snapshot.data?[0];

                // get pick up locations
                final List<PickUpModel> locations = snapshot.data?[1];
                // set pick up locations as markers
                final Set<Marker> markers = locations.map((current) {
                  return Marker(
                      markerId: MarkerId(current.name),
                      icon: markerIcon,
                      infoWindow: InfoWindow(
                          title: current.name,
                          snippet: "Tap to see available items",
                          onTap: () {
                            context.read<FilterModel>().addFilter(current.name);
                            Navigator.pop(context);
                          }),
                      position: LatLng(
                          current.pickup.latitude, current.pickup.longitude));
                }).toSet();

                // add user location to markers
                markers.add(Marker(
                    markerId: const MarkerId("current"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                    position: user!));

                // return map
                return GoogleMap(
                  onMapCreated: (GoogleMapController controller) =>
                      mapController.complete(controller),
                  initialCameraPosition: CameraPosition(target: user, zoom: 14),
                  markers: markers,
                );
              } else {
                final error = snapshot.error;
                return Center(
                  child: Text("Error Occurred: $error"),
                );
              }
          }
        },
      ),
    );
  }
}
