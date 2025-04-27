import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crud_app/features/auth/data/models/user_model.dart';
import 'package:crud_app/features/auth/domain/entities/user_entity.dart';

class AuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserEntity> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password
  }) async {
    try {
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      await _firestore
        .collection('profiles')
        .doc(credentials.user!.uid)
        .set({
          'uid': credentials.user!.uid,
          'name': name,
          'email': email,
        });

      return UserModel(
        uid: credentials.user!.uid,
        name: name,
        email: email
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    try {
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      final userDoc = await _firestore
        .collection('profiles')
        .doc(credentials.user!.uid)
        .get();

      return UserModel(
        uid: credentials.user!.uid,
        name: userDoc.data()?['name'],
        email: credentials.user!.email
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      final userDoc = await _firestore
        .collection('profiles')
        .doc(user.uid)
        .get();

      return UserModel(
        uid: user.uid,
        name: userDoc.data()?['name'],
        email: user.email
      );
    }

    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}