import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbridge/auth_service/models/grocery_model.dart';
import 'package:foodbridge/auth_service/models/user_model.dart';

// ignore: constant_identifier_names
const String USER_MODEL_REF = "Users";
const String GROCERY_MODEL_REF = "Groceries";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  late final CollectionReference _userRef;
  late final CollectionReference _groceryRef;

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

  // get groceries
  Stream<QuerySnapshot> getGroceries() {
    return _groceryRef.snapshots();
  }

  // add grocery
  void addGroceries(GroceryModel grocery) {
    _groceryRef.add(grocery);
  }

  void updateGrocery(String name, GroceryModel grocery) async {
    final ref = await _groceryRef.where("name", isEqualTo: name).get();
    print("here_");
    print(name);
    print(await ref.docs.first.reference.id);
    _groceryRef.doc(ref.docs.first.reference.id).update(grocery.toJson());
  }

  // get food types
  Future<DocumentSnapshot> getFoodTypes() {
    return _firestore.collection("foodType").doc("foodTypes").get();
  }
}
