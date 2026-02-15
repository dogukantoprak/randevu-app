import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_role.dart';

class UserProfile {
  final String uid;
  final String email;
  final String? displayName;
  final UserRole role;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    required this.email,
    this.displayName,
    required this.role,
    required this.createdAt,
  });

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      role: UserRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => UserRole.customer,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
