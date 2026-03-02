class AttendanceLocationModel {
  String? attendanceLocationId;
  String? name;
  double? latitude;
  double? longitude;

  AttendanceLocationModel(
      {this.attendanceLocationId, this.name, this.latitude, this.longitude});

  AttendanceLocationModel.fromJson(Map<String, dynamic> json) {
    attendanceLocationId = json['attendanceLocationId'];
    name = json['name'];
    latitude = double.parse(json['latitude'].toString());
    longitude = double.parse(json['longitude'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attendanceLocationId'] = attendanceLocationId;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
