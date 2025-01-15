import 'package:flutter/material.dart';
import '../models/leave_model.dart';

class LeaveCardAdmin extends StatefulWidget {
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
  LeaveCardAdminState createState() => LeaveCardAdminState();
}

class LeaveCardAdminState extends State<LeaveCardAdmin> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
            Text(
              widget.leaveModel.userName ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: widget.onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text("Approve"),
                ),
                ElevatedButton(
                  onPressed: widget.onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
