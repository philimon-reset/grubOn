import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String buyerAddress;
  final String groceryId;
  final int amountBought;
  final Timestamp boughtOn;
  final String buyerEmail;

  const TransactionModel(
      {required this.groceryId,
      required this.buyerEmail,
      required this.amountBought,
      required this.buyerAddress,
      required this.boughtOn});

  TransactionModel.fromJson(Map<String, dynamic> json)
      : groceryId = json['groceryId'],
        buyerEmail = json['buyerEmail'],
        buyerAddress = json['buyerAddress'],
        boughtOn = json['boughtOn'],
        amountBought = json['amountBought'];

  Map<String, dynamic> toJson() {
    return {
      'groceryId': groceryId,
      'buyerEmail': buyerEmail,
      'buyerAddress': buyerAddress,
      'boughtOn': boughtOn,
      'amountBought': amountBought,
    };
  }

  TransactionModel copyWith(
      {String? about,
      String? name,
      String? photo,
      bool? sellable,
      String? buyerEmail,
      int? price,
      String? buyerAddress,
      Timestamp? boughtOn,
      Timestamp? expireDate,
      int? amountBought}) {
    return TransactionModel(
      groceryId: groceryId,
      buyerEmail: buyerEmail ?? this.buyerEmail,
      amountBought: amountBought ?? this.amountBought,
      buyerAddress: buyerAddress ?? this.buyerAddress,
      boughtOn: boughtOn ?? this.boughtOn,
    );
  }
}
