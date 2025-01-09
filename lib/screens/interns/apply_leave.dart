import 'package:flutter/material.dart';
import '../../controllers/leave_controller.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final LeaveController _controller = LeaveController();
  final FocusNode _reasonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _reasonFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _reasonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Leave Application Form",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please provide information about your leave.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: "Leave Type",
                hintText: "Choose leave type...",
                dropdownItems: ["Casual Leave", "Medical Leave", "Study Leave"],
                value: _controller.selectedLeaveType,
                onChanged: (value) =>
                    setState(() => _controller.selectedLeaveType = value),
              ),
              const SizedBox(height: 20),
              _buildDatePickerField(),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: "Select Period",
                hintText: "Period of leave...",
                dropdownItems: ["Full Day", "Half Day"],
                value: _controller.selectedPeriod,
                onChanged: (value) =>
                    setState(() => _controller.selectedPeriod = value),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  "Reason", "Enter reason...", _controller.reasonController),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () => _controller.submitLeaveApplication(setState),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF241B61),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Apply Leave",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: _glassDecoration(),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(
              hintText,
              style: const TextStyle(color: Colors.white70),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white70),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: _glassDecoration(),
          child: TextFormField(
            controller: TextEditingController(
                text: _controller.selectedDate != null
                    ? "${_controller.selectedDate!.day}/${_controller.selectedDate!.month}/${_controller.selectedDate!.year}"
                    : ""),
            readOnly: true,
            onTap: () async {
              await _controller.pickDate(context);
              setState(() {});
            },
            style: const TextStyle(color: Colors.white),
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
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: _glassDecoration(),
          child: TextFormField(
            controller: controller,
            focusNode: _reasonFocusNode,
            maxLines: label == "Reason" ? 4 : 1,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white70),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: const TextStyle(color: Colors.white),
            cursorColor: const Color(0xFF6A0DAD),
          ),
        ),
      ],
    );
  }

  BoxDecoration _glassDecoration() {
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
