import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:virtuo/bloc/routes.dart';
import 'package:virtuo/helpers/databaseConstants.dart';

class UserRepository {
  UserRepository({User? firebaseAuth}) : _firebaseAuth = firebaseAuth;
  User? _firebaseAuth;
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference _associationUsersCollectionReference =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);
  final firebaseAuth = FirebaseAuth.instance;

  // -1 : anonymous user / can't be decided
  // 1 : Individual user type
  // 2 : Associative user type

  Future<int> isUserDataPresent(String? uid) async {
    int userRoleId = 0;

    try {
      // DocumentSnapshot snapshot =
      //     await _usersCollectionReference.doc(uid).get();
      DocumentSnapshot snapshot2 =
          await _associationUsersCollectionReference.doc(uid).get();
      // if (snapshot.exists == true) {
      //   return 1;
      // }
      if (snapshot2.exists == true) {
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await _associationUsersCollectionReference.doc(uid).set(
              {FCM_DEVICE_ID: token, UPDATED_AT_KEY: DateTime.now()},
              SetOptions(merge: true));
        }
        Map<String, dynamic> userData =
            snapshot2.data() as Map<String, dynamic>;
        // print(snapshot2.data());
        // print("userdata : ${snapshot.data() as Map<String, dynamic>}");
        return 2;
      }

      return userRoleId;
    } catch (e) {
      print("error ___________________________________________________");
      print("UserRepository : isUserDataPresent : No internect connection");
      print(e.toString());
      return -1;
    }
  }

  bool currentUser() {
    _firebaseAuth = FirebaseAuth.instance.currentUser;
    return _firebaseAuth != null;
  }

  Future<void> signOut(context) async {
    // Navigator.pop(context, true);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacementNamed(context, Routes.login);
    return firebaseAuth.signOut();
  }

  void createUser(String? user, String uid) {
    try {
      _usersCollectionReference.doc(uid).get().then((snapshot) {
        if (!snapshot.exists) {
          _usersCollectionReference.doc(uid).set({"name": user, "uid": uid});
        }
      });
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
