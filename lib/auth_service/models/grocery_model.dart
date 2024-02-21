import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryModel {
  final String id;
  final String about;
  final String name;
  final String? photo;
  final bool sellable;
  final bool sold;

  final int price;
  final String type;
  final String pickup;
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
      required this.pickup,
      this.photo,
      required this.sellable,
      required this.sold,
      required this.price,
      required this.type,
      required this.postDate,
      required this.expireDate});

  GroceryModel.fromJson(Map<String, dynamic> json)
      : about = json['about'],
        pickup = json['pickup'],
        id = json['id'],
        userEmail = json['userEmail'],
        name = json['name'],
        photo = json['photo'],
        sellable = json['sellable'],
        sold = json['sold'],
        price = json['price'],
        type = json['type'],
        postDate = json['postDate'],
        expireDate = json['expireDate'],
        count = json['count'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'about': about,
      'pickup': pickup,
      'name': name,
      'userEmail': userEmail,
      'photo': photo,
      'sellable': sellable,
      'sold': sold,
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
      String? pickup,
      Timestamp? expireDate,
      bool? sold,
      int? count}) {
    return GroceryModel(
      pickup: pickup ?? this.pickup,
      sold: sold ?? this.sold,
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
