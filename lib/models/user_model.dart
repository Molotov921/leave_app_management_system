class UserModel {
  final String name;
  final String email;
  final String role;
  final String uid;
  final int totalLeaves;
  final int approvedLeaves;
  final int rejectedLeaves;

  int get pendingLeaves => totalLeaves - approvedLeaves - rejectedLeaves;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.uid,
    this.totalLeaves = 0,
    this.approvedLeaves = 0,
    this.rejectedLeaves = 0,
  });

  // Factory method to create a UserModel from Firestore data
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'unknown',
      uid: uid,
      totalLeaves: data['totalLeaves'] ?? 0,
      approvedLeaves: data['approvedLeaves'] ?? 0,
      rejectedLeaves: data['rejectedLeaves'] ?? 0,
    );
  }

  // Method to convert UserModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'uid': uid,
      'totalLeaves': totalLeaves,
      'approvedLeaves': approvedLeaves,
      'rejectedLeaves': rejectedLeaves,
      'pendingLeaves': pendingLeaves,
    };
  }
}
