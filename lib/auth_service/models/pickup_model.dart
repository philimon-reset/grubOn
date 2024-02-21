import 'package:cloud_firestore/cloud_firestore.dart';

class PickUpModel {
  final String name;
  final GeoPoint pickup;

  const PickUpModel({required this.name, required this.pickup});

  PickUpModel.fromJson(Map<String, dynamic> json)
      : this(name: json["name"], pickup: json["pickup"]);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "pickup": pickup,
    };
  }

  PickUpModel copyWith({
    String? name,
    GeoPoint? pickup,
  }) {
    return PickUpModel(name: name ?? this.name, pickup: pickup ?? this.pickup);
  }
}
