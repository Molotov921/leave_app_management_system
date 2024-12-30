import 'package:flutter/material.dart';

class LeaveStatus extends StatelessWidget {
  const LeaveStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "Check Leave Status here.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
