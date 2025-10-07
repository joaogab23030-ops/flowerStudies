import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required String uid,
    required String name,
    required String email,
    required int age,
  }) async {
    try {
      await _db.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw e;
    }
  }
}
