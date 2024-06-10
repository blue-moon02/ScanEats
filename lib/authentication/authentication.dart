import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:label_scanner/models/user_model.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

//SIGN UP METHOD
  // Future<String?> signUp({required String email, required String password}) async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }
  Future<String?> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

      // Create a User object and save it to Firebase
      UserModel user = UserModel(
          uid: userCredential.user!.uid, email: email, name: name);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(user.toMap());

      await userCredential.user!.updateDisplayName(name);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  //SIGN IN METHODJ
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await _auth.signOut();
    debugPrint('signout');
  }
}
