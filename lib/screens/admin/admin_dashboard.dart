import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_services.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    void logout() async {
      await authService.signOut();
      Get.offAllNamed('/login');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(child: Text("Welcome, Admin!")),
    );
  }
}
