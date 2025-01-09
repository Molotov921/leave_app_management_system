import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../controllers/leave_controller.dart';
import '../../models/leave_model.dart';
import '../../widgets/edit_leave_application.dart';
import '../../widgets/leave_card.dart';

class LeaveStatus extends StatelessWidget {
  const LeaveStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaveController leaveController = Get.put(LeaveController());

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<List<LeaveModel>>(
          stream: leaveController.fetchLeaveApplications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Error fetching leave applications",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final leaveApplications = snapshot.data ?? [];

            // Separate leaves into recent and past categories
            final recentLeaves = leaveApplications
                .where((leave) => leave.status == 'Pending')
                .toList();
            final pastLeaves = leaveApplications
                .where((leave) =>
                    leave.status == 'Approved' || leave.status == 'Rejected')
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recentLeaves.isNotEmpty) ...[
                  const Text(
                    'Recent Leaves',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: recentLeaves.map((leaveApplication) {
                      return Slidable(
                        closeOnScroll: true,
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(25),
                              ),
                              onPressed: (ctx) {
                                showDialog(
                                  context: context,
                                  builder: (_) => EditLeavePopup(
                                    leaveApplication: leaveApplication,
                                    onSave: (updatedLeave) {
                                      leaveController
                                          .updateLeaveApplication(updatedLeave);
                                    },
                                  ),
                                );
                              },
                              backgroundColor: const Color(0xFF23195f),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(25),
                              ),
                              onPressed: (ctx) {
                                Get.dialog(
                                  AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    backgroundColor: const Color(0xFF241B61),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    title: const Center(
                                      child: Text(
                                        "Delete Leave Application",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    content: const Text(
                                      "Are you sure you want to delete this leave application? This action cannot be undone.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          leaveController
                                              .deleteLeaveApplication(
                                                  leaveApplication.docId)
                                              .then((value) {
                                            Get.back();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade400,
                                        ),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              backgroundColor: Colors.red.shade400,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: LeaveCard(
                          leaveType: leaveApplication.leaveType,
                          date:
                              "${leaveApplication.leaveDate.day}/${leaveApplication.leaveDate.month}/${leaveApplication.leaveDate.year}",
                          period: leaveApplication.period,
                          reason: leaveApplication.reason,
                          status: leaveApplication.status,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
                if (pastLeaves.isNotEmpty) ...[
                  const Text(
                    'Past Leaves',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: pastLeaves.map((leaveApplication) {
                      return LeaveCard(
                        leaveType: leaveApplication.leaveType,
                        date:
                            "${leaveApplication.leaveDate.day}/${leaveApplication.leaveDate.month}/${leaveApplication.leaveDate.year}",
                        period: leaveApplication.period,
                        reason: leaveApplication.reason,
                        status: leaveApplication.status,
                      );
                    }).toList(),
                  ),
                ],
                if (recentLeaves.isEmpty && pastLeaves.isEmpty)
                  const Center(
                    child: Text(
                      'No leave applications yet',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
