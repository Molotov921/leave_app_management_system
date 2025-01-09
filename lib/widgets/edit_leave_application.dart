import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/leave_model.dart';

class EditLeavePopup extends StatelessWidget {
  final LeaveModel leaveApplication;
  final Function(LeaveModel) onSave;

  const EditLeavePopup({
    super.key,
    required this.leaveApplication,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final reasonController =
        TextEditingController(text: leaveApplication.reason);
    String? selectedLeaveType = leaveApplication.leaveType;
    String? selectedPeriod = leaveApplication.period;
    DateTime selectedDate = leaveApplication.leaveDate;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: const Color(0xFF241B61),
      contentPadding: const EdgeInsets.all(20),
      title: const Text(
        "Edit Leave Application",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDropdownField(
              label: "Leave Type",
              hintText: "Choose leave type...",
              dropdownItems: ["Casual Leave", "Medical Leave", "Study Leave"],
              value: selectedLeaveType,
              onChanged: (value) {
                selectedLeaveType = value;
              },
            ),
            const SizedBox(height: 20),
            _buildDatePickerField(
              context,
              selectedDate: selectedDate,
              onDatePicked: (pickedDate) {
                selectedDate = pickedDate;
              },
            ),
            const SizedBox(height: 20),
            _buildDropdownField(
              label: "Select Period",
              hintText: "Period of leave...",
              dropdownItems: ["Full Day", "Half Day"],
              value: selectedPeriod,
              onChanged: (value) {
                selectedPeriod = value;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField("Reason", "Enter reason...", reasonController),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  LeaveModel updatedLeave = LeaveModel(
                    docId: leaveApplication.docId,
                    uid: leaveApplication.uid,
                    leaveType: selectedLeaveType!,
                    period: selectedPeriod!,
                    leaveDate: selectedDate,
                    reason: reasonController.text,
                    status: leaveApplication.status,
                  );
                  onSave(updatedLeave);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required List<String> dropdownItems,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: _glassDecoration(),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(
              hintText,
              style: const TextStyle(color: Colors.white70),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: dropdownItems
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
            dropdownColor: const Color(0xFF23195f),
            iconEnabledColor: Colors.white,
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(
    BuildContext context, {
    required DateTime selectedDate,
    required ValueChanged<DateTime> onDatePicked,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Date:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: _glassDecoration(),
          child: TextFormField(
            controller: TextEditingController(
                text:
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
            readOnly: true,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                onDatePicked(pickedDate);
              }
            },
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: _glassDecoration(),
          child: TextFormField(
            controller: controller,
            maxLines: label == "Reason" ? 4 : 1,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white70),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  static BoxDecoration _glassDecoration() {
    return BoxDecoration(
      color: Colors.white.withAlpha(50),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(25),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
