import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveModel {
  final String docId;
  final String uid;
  final String leaveType;
  final String period;
  final DateTime leaveDate;
  final String reason;
  final String status;
  String? userName;

  LeaveModel({
    required this.docId,
    required this.uid,
    required this.leaveType,
    required this.period,
    required this.leaveDate,
    required this.reason,
    required this.status,
    this.userName,
  });

  // Factory method to create a LeaveModel from Firestore data
  factory LeaveModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaveModel(
      docId: doc.id,
      uid: data['uid'] ?? '',
      leaveType: data['leaveType'] ?? '',
      period: data['period'] ?? '',
      leaveDate: (data['leaveDate'] as Timestamp).toDate(),
      reason: data['reason'] ?? '',
      status: data['status'] ?? '',
    );
  }

  // Method to convert LeaveModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'leaveType': leaveType,
      'period': period,
      'leaveDate': Timestamp.fromDate(leaveDate),
      'reason': reason,
      'status': status,
    };
  }

  // Method to create a copy of the model with updated fields
  LeaveModel copyWith({
    String? docId,
    String? uid,
    String? leaveType,
    String? period,
    DateTime? leaveDate,
    String? reason,
    String? status,
    String? userName,
  }) {
    return LeaveModel(
      docId: docId ?? this.docId,
      uid: uid ?? this.uid,
      leaveType: leaveType ?? this.leaveType,
      period: period ?? this.period,
      leaveDate: leaveDate ?? this.leaveDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      userName: userName ?? this.userName,
    );
  }

  // Static method to fetch user name from Firestore
  static Future<String> fetchUserName(String uid) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc['name'];
  }
}
