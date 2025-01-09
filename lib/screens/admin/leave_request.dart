import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/leave_model.dart';
import '../../widgets/leave_card_admin.dart';

class LeaveRequests extends StatelessWidget {
  const LeaveRequests({super.key});

  Stream<List<LeaveModel>> fetchLeaveApplications() {
    return FirebaseFirestore.instance
        .collection('leave_applications')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => LeaveModel.fromDocument(doc)).toList());
  }

  Future<void> updateLeaveStatus(String docId, String status) async {
    final DocumentSnapshot leaveDoc = await FirebaseFirestore.instance
        .collection('leave_applications')
        .doc(docId)
        .get();

    if (leaveDoc.exists) {
      final LeaveModel leaveApplication = LeaveModel.fromDocument(leaveDoc);
      final String uid = leaveApplication.uid;
      final String previousStatus = leaveApplication.status;

      await FirebaseFirestore.instance
          .collection('leave_applications')
          .doc(docId)
          .update({'status': status});

      // Update the counters based on the status change
      final DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      final batch = FirebaseFirestore.instance.batch();

      if (previousStatus == 'Approved') {
        batch.update(userDocRef, {
          'approvedLeaves': FieldValue.increment(-1),
        });
      } else if (previousStatus == 'Rejected') {
        batch.update(userDocRef, {
          'rejectedLeaves': FieldValue.increment(-1),
        });
      } else if (previousStatus == 'Pending') {
        batch.update(userDocRef, {
          'pendingLeaves': FieldValue.increment(-1),
        });
      }

      if (status == 'Approved') {
        batch.update(userDocRef, {
          'approvedLeaves': FieldValue.increment(1),
        });
      } else if (status == 'Rejected') {
        batch.update(userDocRef, {
          'rejectedLeaves': FieldValue.increment(1),
        });
      } else if (status == 'Pending') {
        batch.update(userDocRef, {
          'pendingLeaves': FieldValue.increment(1),
        });
      }

      await batch.commit();
    }
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
              return LeaveCardAdmin(
                leaveModel: leaveApplication,
                onApprove: () =>
                    updateLeaveStatus(leaveApplication.docId, "Approved"),
                onReject: () =>
                    updateLeaveStatus(leaveApplication.docId, "Rejected"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
