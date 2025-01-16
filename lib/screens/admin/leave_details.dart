import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../controllers/leave_controller.dart';
import '../../models/leave_model.dart';

class LeaveDetails extends StatelessWidget {
  const LeaveDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaveController leaveController = Get.put(LeaveController());

    return Scaffold(
      body: StreamBuilder<List<LeaveModel>>(
        stream: leaveController.fetchProcessedLeaveApplications(),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: leaveApplications.isNotEmpty
                  ? leaveApplications.map((leaveApplication) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Slidable(
                          closeOnScroll: true,
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(25),
                                ),
                                onPressed: (ctx) {
                                  Get.dialog(
                                    AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      backgroundColor: const Color(0xFF241B61),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 20),
                                      title: const Center(
                                        child: Text(
                                          "Edit Approval",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      content: const Text(
                                        "Do you want to edit the approval status?",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        SizedBox(
                                          width: 120, // Equal width for buttons
                                          child: ElevatedButton(
                                            onPressed: () {
                                              leaveController
                                                  .updateLeaveApplicationStatus(
                                                      leaveApplication.docId,
                                                      "Approved");
                                              Get.back();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.green.shade500,
                                            ),
                                            child: const Text(
                                              "Approve",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120, // Equal width for buttons
                                          child: ElevatedButton(
                                            onPressed: () {
                                              leaveController
                                                  .updateLeaveApplicationStatus(
                                                      leaveApplication.docId,
                                                      "Rejected");
                                              Get.back();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.shade400,
                                            ),
                                            child: const Text(
                                              "Reject",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                backgroundColor: const Color(0xFF23195f),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                                flex: 1,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LeaveCardDetail(
                              leaveModel: leaveApplication,
                            ),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const Center(
                        child: Text(
                          'No processed leave requests yet',
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
      ),
    );
  }
}

class LeaveCardDetail extends StatefulWidget {
  final LeaveModel leaveModel;

  const LeaveCardDetail({super.key, required this.leaveModel});

  @override
  LeaveCardDetailState createState() => LeaveCardDetailState();
}

class LeaveCardDetailState extends State<LeaveCardDetail> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    IconData statusIcon;
    Color statusColor;
    switch (widget.leaveModel.status) {
      case 'Approved':
        statusIcon = Icons.check_circle_outline;
        statusColor = Colors.green;
        break;
      case 'Rejected':
        statusIcon = Icons.cancel_outlined;
        statusColor = Colors.red;
        break;
      default:
        statusIcon = Icons.hourglass_empty;
        statusColor = Colors.orange;
    }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.leaveModel.userName ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  statusIcon,
                  color: statusColor,
                  size: 30,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.leaveModel.leaveType,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.leaveModel.leaveDate.day}/${widget.leaveModel.leaveDate.month}/${widget.leaveModel.leaveDate.year} (${widget.leaveModel.period})',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.leaveModel.reason,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              maxLines: _isExpanded ? null : 3,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (widget.leaveModel.reason.length > 100)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? 'Show Less' : 'Show More',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
