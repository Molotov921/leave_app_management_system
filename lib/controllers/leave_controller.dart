import 'package:flutter/material.dart';

class LeaveController {
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

  void submitLeaveApplication(BuildContext context, StateSetter setState) {
    if (selectedLeaveType == null ||
        selectedPeriod == null ||
        selectedDate == null ||
        reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields before submitting."),
        ),
      );
      return;
    }

    clearForm();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Leave application submitted and cleared."),
      ),
    );
  }
}
