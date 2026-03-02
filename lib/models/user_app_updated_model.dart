class UserAppUpdatedModel {
  final String userId;
  final String name;
  final String designation;
  final String department;
  final DateTime updatedAt;

  UserAppUpdatedModel({
    required this.userId,
    required this.name,
    required this.designation,
    required this.department,
    required this.updatedAt,
  });

  factory UserAppUpdatedModel.fromJson(Map<String, dynamic> json) {
    return UserAppUpdatedModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      designation: json['designation'] ?? '',
      department: json['department'] ?? '',
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'designation': designation,
      'department': department,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
