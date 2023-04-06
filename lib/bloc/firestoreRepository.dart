import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

abstract class FireStoreDb {
  Future<bool?> isUserPresent(String? uid);
}

class FireStoreRepository implements FireStoreDb {
  final databaseReference = FirebaseFirestore.instance;
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("users");
  var l = Logger();

  @override
  Future<bool?> isUserPresent(uid) async {
    try {
      DocumentSnapshot userData =
          await _usersCollectionReference.doc(uid).get();
      return userData.exists;
    } on FirebaseException catch (e) {
      l.e(e.message);
      return null;
    }
  }
}
