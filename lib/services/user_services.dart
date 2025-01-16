import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data (either Admin or Intern)
  Future<String> fetchUserName() async {
    final User? user = _auth.currentUser;
    if (user == null) return "User";

    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        UserModel userModel = UserModel.fromFirestore(
            userDoc.data() as Map<String, dynamic>, user.uid);
        return userModel.name;
      } else {
        return "User";
      }
    } catch (e) {
      return "User";
    }
  }

  // Fetch user details
  Future<UserModel> fetchUserDetails() async {
    final User? user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        UserModel userModel = UserModel.fromFirestore(
            userDoc.data() as Map<String, dynamic>, user.uid);
        return userModel;
      } else {
        throw Exception("User data not found");
      }
    } catch (e) {
      throw Exception("Failed to fetch user details: $e");
    }
  }

  // Fetch all users data excluding admin users for admin dashboard
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final QuerySnapshot usersSnapshot =
          await _firestore.collection('users').get();
      return usersSnapshot.docs
          .map((doc) => UserModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .where((user) => user.role == 'intern')
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Fetch all users data as a stream for real-time updates
  Stream<List<UserModel>> fetchAllUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            return UserModel.fromFirestore(data, doc.id);
          })
          .where((user) => user.role == 'intern')
          .toList();
    });
  }
}
