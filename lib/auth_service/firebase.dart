import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbridge/auth_service/models/user_model.dart';

// ignore: constant_identifier_names
const String USER_MODEL_REF = "Users";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _userRef;

  DatabaseService() {
    _userRef = _firestore.collection(USER_MODEL_REF).withConverter<UserModel>(
          fromFirestore: (snapshot, options) {
            return UserModel.fromJson(snapshot.data()!);
          },
          toFirestore: (UserModel value, _) => value.toJson(),
        );
  }

  Future<QuerySnapshot<Object?>> getUserDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    // return _userRef.snapshots();
    final current =
        await _userRef.where("email", isEqualTo: currentUser.email).get();
    return current;
    // return _userRef.snapshots();
  }

  Future addUserDetails(UserModel user) async {
    _userRef.add(user);
  }

  void updateUserDetails(String email, UserModel user) async {
    final current = await _userRef.where("email", isEqualTo: user.email).get();
    print(current.docs.first.reference.id);
    _userRef.doc(current.docs.first.reference.id).update(user.toJson());
  }
}
