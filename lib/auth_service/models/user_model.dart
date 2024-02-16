import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final int phoneNumber;
  final String email;
  final String address;
  final String password;
  final bool isEstablishment;
  final Timestamp createdOn;

  const UserModel(
      {required this.createdOn,
      required this.userName,
      required this.phoneNumber,
      required this.email,
      required this.address,
      required this.password,
      required this.isEstablishment});

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
            userName: json["userName"],
            password: json["password"],
            isEstablishment: json["isEstablishment"],
            phoneNumber: json["phoneNumber"],
            email: json["email"],
            address: json["address"],
            createdOn: json["createdOn"]);

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password,
      "address": address,
      "isEstablishment": isEstablishment,
      "createdOn": createdOn,
    };
  }

  UserModel copyWith(
      {String? userName,
      int? phoneNumber,
      String? email,
      String? address,
      String? password,
      bool? isEstablishment,
      Timestamp? createdOn}) {
    return UserModel(
        createdOn: createdOn ?? this.createdOn,
        userName: userName ?? this.userName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        address: address ?? this.address,
        password: password ?? this.password,
        isEstablishment: isEstablishment ?? this.isEstablishment);
  }
}
