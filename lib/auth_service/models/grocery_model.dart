import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryModel {
  final String id;
  final String about;
  final String name;
  final String? photo;
  final bool sellable;
  final int price;
  final String type;
  final int count;
  final Timestamp postDate;
  final Timestamp expireDate;
  final String userEmail;

  const GroceryModel(
      {required this.about,
      required this.id,
      required this.userEmail,
      required this.count,
      required this.name,
      this.photo,
      required this.sellable,
      required this.price,
      required this.type,
      required this.postDate,
      required this.expireDate});

  GroceryModel.fromJson(Map<String, dynamic> json)
      : about = json['about'],
        id = json['id'],
        userEmail = json['userEmail'],
        name = json['name'],
        photo = json['photo'],
        sellable = json['sellable'],
        price = json['price'],
        type = json['type'],
        postDate = json['postDate'],
        expireDate = json['expireDate'],
        count = json['count'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'about': about,
      'name': name,
      'userEmail': userEmail,
      'photo': photo,
      'sellable': sellable,
      'price': price,
      'type': type,
      'postDate': postDate,
      'expireDate': expireDate,
      'count': count,
    };
  }

  GroceryModel copyWith(
      {String? about,
      String? name,
      String? photo,
      bool? sellable,
      String? userEmail,
      int? price,
      String? type,
      Timestamp? postDate,
      Timestamp? expireDate,
      int? count}) {
    return GroceryModel(
      id: id,
      userEmail: userEmail ?? this.userEmail,
      count: count ?? this.count,
      about: about ?? this.about,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      sellable: sellable ?? this.sellable,
      price: price ?? this.price,
      type: type ?? this.type,
      postDate: postDate ?? this.postDate,
      expireDate: expireDate ?? this.expireDate,
    );
  }
}
