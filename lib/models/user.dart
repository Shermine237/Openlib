class User {
  final String id;
  final String username;
  final String email;
  final String? phoneNumber;
  final DateTime createdAt;
  final String status;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    required this.createdAt,
    required this.status,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'role': role,
    };
  }
}
