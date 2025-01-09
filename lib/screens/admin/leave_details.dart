import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/leave_model.dart';

class LeaveDetails extends StatelessWidget {
  const LeaveDetails({super.key});

  Stream<List<LeaveModel>> fetchLeaveApplications() {
    return FirebaseFirestore.instance
        .collection('leave_applications')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => LeaveModel.fromDocument(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: StreamBuilder<List<LeaveModel>>(
        stream: fetchLeaveApplications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text("Error fetching leave applications",
                    style: TextStyle(color: Colors.white)));
          }

          final leaveApplications = snapshot.data ?? [];

          return Column(
            children: leaveApplications.map((leaveApplication) {
              return ListTile(
                title: Text(leaveApplication.leaveType,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  "Date: ${leaveApplication.leaveDate.day}/${leaveApplication.leaveDate.month}/${leaveApplication.leaveDate.year}\nStatus: ${leaveApplication.status}",
                  style: const TextStyle(color: Colors.white70),
                ),
                isThreeLine: true,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
