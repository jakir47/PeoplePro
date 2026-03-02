class HubUserModel {
  String empCode;
  String name;
  String designation;
  String department;
  String photo;
  bool isConnected;
  DateTime lastSeen;

  HubUserModel({
    required this.empCode,
    required this.name,
    required this.designation,
    required this.department,
    required this.photo,
    required this.isConnected,
    required this.lastSeen,
  });

  factory HubUserModel.fromJson(Map<String, dynamic> json) {
    return HubUserModel(
      empCode: json['empCode'],
      name: json['name'],
      designation: json['designation'],
      department: json['department'],
      photo: json['photo'] ?? "",
      isConnected: json['isConnected'] ?? false,
      lastSeen: DateTime.parse(json['lastSeen']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['name'] = name;
    data['designation'] = designation;
    data['department'] = department;
    data['photo'] = photo;
    data['isConnected'] = isConnected;
    data['lastSeen'] = lastSeen.toIso8601String();
    return data;
  }
}
