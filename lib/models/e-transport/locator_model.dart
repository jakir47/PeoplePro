class LocatorModel {
  String empCode;
  String empName;
  String designation;
  String department;
  double latitude;
  double longitude;

  LocatorModel(
      {this.empCode = "",
      this.empName = "",
      this.designation = "",
      this.department = "",
      this.latitude = 0,
      this.longitude = 0});

  factory LocatorModel.fromJson(Map<String, dynamic> json) {
    return LocatorModel(
      empCode: json["empCode"] as String,
      empName: json["empName"] as String,
      designation: json['designation'] as String,
      department: json['department'] as String,
      latitude: json["latitude"] == null ? 0.0 : json['latitude'].toDouble(),
      longitude: json["longitude"] == null ? 0.0 : json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "empCode": empCode,
      "empName": empName,
      "designation": designation,
      "department": department,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
