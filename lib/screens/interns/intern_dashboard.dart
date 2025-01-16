import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/user_services.dart';

class InternDashboardContent extends StatelessWidget {
  const InternDashboardContent({super.key});

  Future<String> fetchUserName() async {
    final UserService userService = UserService();
    return await userService.fetchUserName();
  }

  Future<UserModel> fetchUserDetails() async {
    final UserService userService = UserService();
    return await userService.fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Error fetching user data",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          );
        }

        final String displayName = snapshot.data ?? "Intern";

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    const Center(
                      child: Text(
                        "Welcome,",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "$displayName!",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Leave Report",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<UserModel>(
                  future: fetchUserDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "Error fetching leave data",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final UserModel user = snapshot.data!;

                    return _buildUserCard(user);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF241B61), Color(0xFF3C5BCC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.white70,
              thickness: 0.5,
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountColumn(
                    "Pending",
                    user.totalLeaves -
                        user.approvedLeaves -
                        user.rejectedLeaves,
                    Colors.orange),
                const VerticalDivider(
                  color: Colors.orange,
                  thickness: 0.5,
                  width: 20,
                ),
                _buildCountColumn(
                    "Approved", user.approvedLeaves, Colors.green),
                const VerticalDivider(
                  color: Colors.green,
                  thickness: 0.5,
                  width: 20,
                ),
                _buildCountColumn(
                    "Rejected", user.rejectedLeaves, Colors.redAccent),
                const VerticalDivider(
                  color: Colors.redAccent,
                  thickness: 0.5,
                  width: 20,
                ),
                _buildCountColumn("Total", user.totalLeaves, Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountColumn(String label, int count, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "$count",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
