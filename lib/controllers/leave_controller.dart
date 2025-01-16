import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/leave_model.dart';

class LeaveController extends GetxController {
  final TextEditingController reasonController = TextEditingController();
  String? selectedLeaveType;
  String? selectedPeriod;
  DateTime? selectedDate;

  void clearForm() {
    selectedLeaveType = null;
    selectedPeriod = null;
    selectedDate = null;
    reasonController.clear();
  }

  Future<void> pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedDate = pickedDate;
    }
  }

  Future<void> submitLeaveApplication(StateSetter setState) async {
    if (selectedLeaveType == null ||
        selectedPeriod == null ||
        selectedDate == null ||
        reasonController.text.isEmpty) {
      showSnackBarMessage("Please fill in all fields before submitting.");
      return;
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser == null) {
      showSnackBarMessage("User not logged in.");
      return;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (!userDoc.exists) {
      showSnackBarMessage("User details not found.");
      return;
    }

    String userName = userDoc['name'] ?? '';

    LeaveModel leaveApplication = LeaveModel(
      docId: '',
      uid: currentUser.uid,
      userName: userName,
      leaveType: selectedLeaveType!,
      period: selectedPeriod!,
      leaveDate: selectedDate!,
      reason: reasonController.text,
      status: 'Pending',
    );

    try {
      // Add leave application to Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('leave_applications')
          .add({
        ...leaveApplication.toMap(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      leaveApplication = leaveApplication.copyWith(docId: docRef.id);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'totalLeaves': FieldValue.increment(1),
        'pendingLeaves': FieldValue.increment(1),
      });

      clearForm();
      setState(() {});
      showSnackBarMessage("Leave application submitted.");
    } catch (e) {
      showSnackBarMessage("Failed to submit leave application: $e");
    }
  }

  Future<void> updateLeaveApplicationStatus(
      String docId, String newStatus) async {
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
          .update({'status': newStatus});
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
      if (newStatus == 'Approved') {
        batch.update(userDocRef, {
          'approvedLeaves': FieldValue.increment(1),
        });
      } else if (newStatus == 'Rejected') {
        batch.update(userDocRef, {
          'rejectedLeaves': FieldValue.increment(1),
        });
      }
      await batch.commit();
    }
  }

  Future<void> deleteLeaveApplication(String docId) async {
    try {
      // Fetch leave application before deletion to get the user ID
      DocumentSnapshot leaveDoc = await FirebaseFirestore.instance
          .collection('leave_applications')
          .doc(docId)
          .get();

      if (leaveDoc.exists) {
        String uid = leaveDoc['uid'];

        // Delete the leave application
        await FirebaseFirestore.instance
            .collection('leave_applications')
            .doc(docId)
            .delete();

        if (leaveDoc['status'] == 'Pending') {
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'totalLeaves': FieldValue.increment(-1),
            'pendingLeaves': FieldValue.increment(-1),
          });
        } else {
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'totalLeaves': FieldValue.increment(-1),
          });
        }

        showSnackBarMessage("Leave application deleted.");
      } else {
        showSnackBarMessage("Leave application not found.");
      }
    } catch (e) {
      showSnackBarMessage("Failed to delete leave application: $e");
    }
  }

  void openEditLeaveDialog(LeaveModel leaveApplication) {
    selectedLeaveType = leaveApplication.leaveType;
    selectedPeriod = leaveApplication.period;
    selectedDate = leaveApplication.leaveDate;
    reasonController.text = leaveApplication.reason;

    Get.defaultDialog(
      title: "Edit Leave Application",
      content: Column(
        children: [
          _buildDropdownField(
              "Leave Type",
              ["Casual Leave", "Medical Leave", "Study Leave"],
              selectedLeaveType, (value) {
            selectedLeaveType = value;
          }),
          const SizedBox(height: 20),
          _buildDatePickerField(),
          const SizedBox(height: 20),
          _buildDropdownField(
              "Select Period", ["Full Day", "Half Day"], selectedPeriod,
              (value) {
            selectedPeriod = value;
          }),
          const SizedBox(height: 20),
          TextFormField(
            controller: reasonController,
            decoration: InputDecoration(
              labelText: "Reason",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              LeaveModel updatedLeave = leaveApplication.copyWith(
                leaveType: selectedLeaveType,
                period: selectedPeriod,
                leaveDate: selectedDate,
                reason: reasonController.text,
              );
              updateLeaveApplication(updatedLeave).then((value) {
                Get.back();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF241B61),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Update Leave",
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> updateLeaveApplication(LeaveModel updatedLeave) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedLeave.uid)
          .get();

      if (!userDoc.exists) {
        showSnackBarMessage("User details not found.");
        return;
      }

      String userName = userDoc['name'] ?? '';
      updatedLeave = updatedLeave.copyWith(userName: userName);

      // Update the leave application in Firestore
      await FirebaseFirestore.instance
          .collection('leave_applications')
          .doc(updatedLeave.docId)
          .update(updatedLeave.toMap());

      showSnackBarMessage("Leave application updated successfully.");
    } catch (e) {
      showSnackBarMessage("Failed to update leave application: $e");
    }
  }

  Widget _buildDropdownField(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:",
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 8,
                  offset: const Offset(0, 4))
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text("Choose $label...",
                style: const TextStyle(color: Colors.white70)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: items
                .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item,
                        style: const TextStyle(color: Colors.white))))
                .toList(),
            onChanged: onChanged,
            dropdownColor: const Color(0xFF241B61),
            iconEnabledColor: Colors.white,
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Date:",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 8,
                  offset: const Offset(0, 4))
            ],
          ),
          child: TextFormField(
            readOnly: true,
            onTap: () async {
              await pickDate(Get.context!);
            },
            controller: TextEditingController(
                text: selectedDate != null
                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    : ""),
            decoration: InputDecoration(
              hintText: "Select leave date...",
              hintStyle: const TextStyle(color: Colors.white70),
              suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Stream<List<LeaveModel>> fetchLeaveApplications() {
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('leave_applications')
        .where('uid', isEqualTo: currentUid)
        .orderBy('leaveDate', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<LeaveModel> leaveList = [];
      for (var doc in snapshot.docs) {
        LeaveModel leave = LeaveModel.fromDocument(doc);
        leave.userName = await LeaveModel.fetchUserName(leave.uid);
        leaveList.add(leave);
      }
      return leaveList;
    });
  }

  Stream<List<LeaveModel>> fetchPendingLeaveApplicationsOrderedByTimestamp() {
    return FirebaseFirestore.instance
        .collection('leave_applications')
        .where('status', isEqualTo: 'Pending')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<LeaveModel> leaveList = [];
      for (var doc in snapshot.docs) {
        LeaveModel leave = LeaveModel.fromDocument(doc);
        leave.userName = await LeaveModel.fetchUserName(leave.uid);
        leaveList.add(leave);
      }
      return leaveList;
    });
  }

  Stream<List<LeaveModel>> fetchProcessedLeaveApplications() {
    return FirebaseFirestore.instance
        .collection('leave_applications')
        .where('status', isNotEqualTo: 'Pending')
        .orderBy('leaveDate', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<LeaveModel> leaveList = [];
      for (var doc in snapshot.docs) {
        LeaveModel leave = LeaveModel.fromDocument(doc);
        leave.userName = await LeaveModel.fetchUserName(leave.uid);
        leaveList.add(leave);
      }
      return leaveList;
    });
  }

  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
