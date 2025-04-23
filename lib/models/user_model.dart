// lib/models/user_model.dart

class UserModel {
  final String uid;
  final String email;
  final String role; // "recruiter" or "job_seeker"
  final String name;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      name: map['name'],
    );
  }
}
