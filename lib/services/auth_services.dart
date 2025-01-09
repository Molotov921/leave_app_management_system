import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Intern Registration
  Future<User?> registerIntern(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userModel = UserModel(
        name: name,
        email: email,
        role: 'intern',
        uid: userCredential.user?.uid ?? '',
        approvedLeaves: 0,
        rejectedLeaves: 0,
        totalLeaves: 0,
      );
      await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(userModel.toMap());
      log("Intern registered: ${userCredential.user?.uid}");
      return userCredential.user;
    } catch (e) {
      log("Error in registration: $e");
      rethrow;
    }
  }

  // Login Logic
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("User signed in: ${userCredential.user?.uid}");
      return userCredential.user;
    } catch (e) {
      log("Error in login: $e");
      rethrow;
    }
  }

  // Fetch Role
  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      UserModel userModel =
          UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>, uid);
      return userModel.role;
    } catch (e) {
      log("Error fetching user role: $e");
      return 'unknown';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      log("User signed out");
    } catch (e) {
      log("Error in sign-out: $e");
      rethrow;
    }
  }
}
