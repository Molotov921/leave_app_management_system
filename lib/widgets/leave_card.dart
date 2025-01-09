import 'package:flutter/material.dart';

class LeaveCard extends StatefulWidget {
  final String leaveType;
  final String date;
  final String period;
  final String reason;
  final String status;

  const LeaveCard({
    super.key,
    required this.leaveType,
    required this.date,
    required this.period,
    required this.reason,
    required this.status,
  });

  @override
  LeaveCardState createState() => LeaveCardState();
}

class LeaveCardState extends State<LeaveCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    IconData statusIcon;
    Color statusColor;
    switch (widget.status) {
      case 'Approved':
        statusIcon = Icons.check_circle_outline;
        statusColor = Colors.green;
        break;
      case 'Rejected':
        statusIcon = Icons.cancel_outlined;
        statusColor = Colors.red;
        break;
      case 'Pending':
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.leaveType,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.date} (${widget.period})',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.reason,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        maxLines: _isExpanded ? null : 3,
                        overflow: _isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      if (widget.reason.length > 100)
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
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                      size: 30,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
