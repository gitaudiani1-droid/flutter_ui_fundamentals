
class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String role;

  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });

  bool get isStudent => role == 'student';
  bool get isLecturer => role == 'lecturer';
  bool get isAdmin => role == 'admin';

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? '',
      role: map['role'] ?? 'student',
    );
  }
}
