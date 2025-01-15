import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/leave_controller.dart';
import '../../models/leave_model.dart';
import '../../widgets/leave_card_admin.dart';

class LeaveRequests extends StatelessWidget {
  const LeaveRequests({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaveController leaveController = Get.put(LeaveController());

    return StreamBuilder<List<LeaveModel>>(
      stream: leaveController.fetchPendingLeaveApplicationsOrderedByTimestamp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          if (snapshot.error.toString().contains('FAILED_PRECONDITION')) {
            return const Center(
              child: Text(
                'Please create the necessary Firestore index.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Error fetching leave applications',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        }

        final leaveApplications = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: leaveApplications.isNotEmpty
                ? leaveApplications.map((leaveApplication) {
                    return LeaveCardAdmin(
                      leaveModel: leaveApplication,
                      onApprove: () =>
                          leaveController.updateLeaveApplicationStatus(
                              leaveApplication.docId, "Approved"),
                      onReject: () =>
                          leaveController.updateLeaveApplicationStatus(
                              leaveApplication.docId, "Rejected"),
                    );
                  }).toList()
                : [
                    const Center(
                      child: Text(
                        'No New leave requests yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
          ),
        );
      },
    );
  }
}
