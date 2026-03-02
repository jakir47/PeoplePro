class PositionModel {
  double longitude;
  double latitude;
  PositionModel({
    this.longitude = 0,
    this.latitude = 0,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      longitude: json["longitude"] == null ? 0.0 : json['longitude'].toDouble(),
      latitude: json["latitude"] == null ? 0.0 : json['latitude'].toDouble(),
    );
  }
}
