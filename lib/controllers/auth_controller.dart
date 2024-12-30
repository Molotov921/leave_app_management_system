import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxString userRole = "".obs;

  @override
  void onInit() {
    super.onInit();

    firebaseUser.bindStream(_auth.authStateChanges());

    ever(firebaseUser, (User? user) async {
      await Future.delayed(const Duration(seconds: 3));

      if (user != null) {
        try {
          DocumentSnapshot userDoc =
              await _firestore.collection('users').doc(user.uid).get();

          if (userDoc.exists) {
            userRole.value = userDoc['role'];

            // Role-based navigation
            if (userRole.value == 'admin') {
              Get.offAllNamed('/adminDashboard');
            } else if (userRole.value == 'intern') {
              Get.offAllNamed('/internDashboard');
            } else {
              Get.offAllNamed('/login');
              Get.snackbar("Error", "Unauthorized role.");
            }
          } else {
            Get.offAllNamed('/login');
            Get.snackbar("Error", "User data not found in Firestore.");
          }
        } catch (e) {
          Get.offAllNamed('/login');
          Get.snackbar("Error", "Failed to retrieve user data.");
        }
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        userRole.value = userDoc['role'];
        print('User role on login: ${userRole.value}'); // Debugging line

        // Role-based navigation
        if (userRole.value == 'admin') {
          Get.offAllNamed('/adminDashboard');
        } else if (userRole.value == 'intern') {
          Get.offAllNamed('/internDashboard');
        } else {
          print("Invalid user role: ${userRole.value}"); // Debugging line
          Get.snackbar("Error", "Invalid user role.");
        }
      } else {
        print("User document not found on login."); // Debugging line
        Get.snackbar("Error", "User data not found in Firestore.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Login Failed", "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Login Failed", "Incorrect password.");
      } else {
        Get.snackbar(
            "Login Failed", e.message ?? "An unexpected error occurred.");
      }
    } catch (e) {
      Get.snackbar("Login Failed", "An unexpected error occurred: $e");
    }
  }

  Future<void> logout() async {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to log out?",
      textConfirm: "Yes",
      textCancel: "No",
      onConfirm: () async {
        userRole.value = "";
        await _auth.signOut();
        Get.offAllNamed('/login');
      },
    );
  }
}
