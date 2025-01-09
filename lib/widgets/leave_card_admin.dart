import 'package:flutter/material.dart';
import '../models/leave_model.dart';

class LeaveCardAdmin extends StatelessWidget {
  final LeaveModel leaveModel;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const LeaveCardAdmin({
    super.key,
    required this.leaveModel,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white.withAlpha(30),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leaveModel.leaveType,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${leaveModel.leaveDate.day}/${leaveModel.leaveDate.month}/${leaveModel.leaveDate.year} (${leaveModel.period})',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              leaveModel.reason,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Approve"),
                ),
                ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Reject"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
