import 'package:flutter/material.dart';
import '../../services/user_services.dart';

class InternDashboardContent extends StatelessWidget {
  const InternDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();

    return FutureBuilder<String>(
      future: userService.fetchUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Error fetching user data",
                style: TextStyle(color: Colors.white)),
          );
        }

        final String displayName = snapshot.data ?? "Intern";

        return Center(
          child: Text(
            "Welcome, $displayName!",
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
