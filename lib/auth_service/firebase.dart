import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbridge/auth_service/models/grocery_model.dart';
import 'package:foodbridge/auth_service/models/pickup_model.dart';
import 'package:foodbridge/auth_service/models/transaction_model.dart';
import 'package:foodbridge/auth_service/models/user_model.dart';

// ignore: constant_identifier_names
const String USER_MODEL_REF = "Users";
const String GROCERY_MODEL_REF = "Groceries";
const String TRANSACTION_MODEL_REF = "Transactions";
const String PICKUP_MODEL_REF = "PickUp";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  late final CollectionReference _userRef;
  late final CollectionReference _groceryRef;
  late final CollectionReference _transactionRef;
  late final CollectionReference _pickupRef;

  DatabaseService() {
    _userRef = _firestore.collection(USER_MODEL_REF).withConverter<UserModel>(
          fromFirestore: (snapshot, options) {
            return UserModel.fromJson(snapshot.data()!);
          },
          toFirestore: (UserModel value, _) => value.toJson(),
        );
    _groceryRef =
        _firestore.collection(GROCERY_MODEL_REF).withConverter<GroceryModel>(
            fromFirestore: (snapshot, options) {
              return GroceryModel.fromJson(snapshot.data()!);
            },
            toFirestore: (GroceryModel value, _) => value.toJson());
    _transactionRef = _firestore
        .collection(TRANSACTION_MODEL_REF)
        .withConverter<TransactionModel>(
            fromFirestore: (snapshot, options) {
              return TransactionModel.fromJson(snapshot.data()!);
            },
            toFirestore: (TransactionModel value, _) => value.toJson());

    _pickupRef =
        _firestore.collection(PICKUP_MODEL_REF).withConverter<PickUpModel>(
            fromFirestore: (snapshot, options) {
              return PickUpModel.fromJson(snapshot.data()!);
            },
            toFirestore: (PickUpModel value, _) => value.toJson());
  }

  // get user details
  Future<QuerySnapshot<Object?>> getUserDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final current =
        await _userRef.where("email", isEqualTo: currentUser.email).get();
    return current;
  }

  // add user record
  addUserDetails(UserModel user) {
    _userRef.add(user);
  }

  // update user record
  void updateUserDetails(String email, UserModel user) async {
    final current = await _userRef.where("email", isEqualTo: user.email).get();
    _userRef.doc(current.docs.first.reference.id).update(user.toJson());
  }

  // get all groceries
  Stream<QuerySnapshot> getGroceries() {
    return _groceryRef.snapshots();
  }

  Stream<QuerySnapshot> getMyGroceries() {
    return _groceryRef
        .where("userEmail", isEqualTo: currentUser?.email)
        .snapshots();
  }

  Stream<QuerySnapshot> getSellableGroceries(List pickups) {
    Query query = _groceryRef
        .where("sellable", isEqualTo: true)
        .where("userEmail", isNotEqualTo: currentUser?.email);
    print(pickups);
    if (pickups.isNotEmpty) {
      query = _groceryRef.where("pickup", whereIn: pickups);
    }
    return query.snapshots();
  }

  void updateSoldGroceries(List myItems) async {
    List<String> ids = myItems.map<String>((e) => e["id"]).toList();
    _groceryRef.where("id", whereIn: ids).get().then((value) {
      for (final doc in value.docs) {
        final docRef = _groceryRef.doc(doc.id);
        final current =
            myItems.firstWhere((element) => element["id"] == doc.id);
        docRef.update(
            {"Sold": true, "count": FieldValue.increment(-current["Amount"])});
      }
    });
  }

  // add grocery
  void addGroceries(GroceryModel grocery) {
    _groceryRef.doc(grocery.id).set(grocery);
  }

  // update grocery
  void updateGrocery(String id, GroceryModel grocery) {
    _groceryRef.doc(id).update(grocery.toJson());
  }

  // delete grocery
  void deleteGrocery(String id) {
    _groceryRef.doc(id).delete();
  }

  // get food types
  Future<DocumentSnapshot> getFoodTypes() {
    return _firestore.collection("foodType").doc("foodTypes").get();
  }

  void addToCart(GroceryModel grocery, String email, int amount) {
    _firestore.collection("Cart").doc(grocery.id).set({
      "Amount": amount,
      "userEmail": email,
      "groceryName": grocery.name,
      "type": grocery.type,
      "id": grocery.id,
      "maxAmount": grocery.count
    });
  }

  Stream<QuerySnapshot> getMyCart() {
    return _firestore
        .collection("Cart")
        .where("userEmail", isEqualTo: currentUser?.email)
        .snapshots();
  }

  void deleteCartItem(String id) {
    _firestore.collection("Cart").doc(id).delete();
  }

  void clearCart(String id) {
    _firestore.collection("Cart").doc(id).delete();
  }

  void addTransaction(TransactionModel transaction) {
    _transactionRef.add(transaction);
  }

  Future<QuerySnapshot> getPickUpLocations() {
    return _pickupRef.get();
  }
}
