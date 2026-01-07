import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  ///

  final firestore = FirebaseFirestore.instance;

  final auth = FirebaseAuth.instance;

  ///

  Future<void> addUserData(UserModel user) async {
    try {
      final userCollection = firestore
          .collection("users")
          .doc(auth.currentUser?.uid);
      final snapshot = await userCollection.get();
      //
      if (snapshot.exists) {
        await userCollection.update({"lastLogin": Timestamp.now()});
      } else {
        //
        final userToAdd = user.toJson();
        //
        await userCollection.set(userToAdd, SetOptions(merge: true));
      }

      //
    } catch (e) {
      log("Erreur lors de l'ajout des données à Firestore : $e");
    }
  }
}
