class AttendanceBaseLatLng {
  double? latitude;
  double? longitude;

  AttendanceBaseLatLng({this.latitude, this.longitude});

  AttendanceBaseLatLng.fromJson(Map<String, dynamic> json) {
    latitude = double.parse(json['latitude'].toString());
    longitude = double.parse(json['longitude'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
