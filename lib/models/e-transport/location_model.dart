class LocationModel {
  int busId;
  double latitude;
  double longitude;
  double heading;
  String speed;
  String time;
  int placeId;
  String placeName;
  double distance;
  String trackerId;
  String trackerName;
  String designation;
  String department;
  bool isTrackerActive;
  bool notification;

  LocationModel({
    this.busId = 0,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.heading = 0.0,
    this.speed = "",
    this.time = "",
    this.placeId = 0,
    this.placeName = "",
    this.distance = 0.0,
    this.trackerId = "",
    this.trackerName = "",
    this.designation = "",
    this.department = "",
    this.isTrackerActive = true,
    this.notification = false,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      busId: json["busId"] as int,
      latitude: json["latitude"] == null ? 0.0 : json['latitude'].toDouble(),
      longitude: json["longitude"] == null ? 0.0 : json['longitude'].toDouble(),
      heading: json["heading"] == null ? 0.0 : json['heading'].toDouble(),
      speed: json["speed"] as String,
      time: json["time"] as String,
      placeId: json['placeId'] as int,
      placeName: json['placeName'] as String,
      distance: json['distance'] == null ? 0.0 : json['distance'].toDouble(),
      trackerId: json['trackerId'] as String,
      trackerName: json['trackerName'] as String,
      designation: json['designation'] as String,
      department: json['department'] as String,
      isTrackerActive: json['isTrackerActive'] as bool,
      notification: json['notification'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "busId": busId,
      "latitude": latitude,
      "longitude": longitude,
      "heading": heading,
      "speed": speed,
      "time": time,
      "placeId": placeId,
      "placeName": placeName,
      "distance": distance,
      "trackerId": trackerId,
      "trackerName": trackerName,
      "designation": designation,
      "department": department,
      "isTrackerActive": isTrackerActive,
      "notification": notification,
    };
  }
}
