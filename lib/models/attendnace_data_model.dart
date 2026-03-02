class AttendanceDataModel {
  double? latitude;
  double? longitude;
  bool? isMocked;
  bool? service;
  bool? outOfZone;
  int? zoneId;
  bool? isValid;

  AttendanceDataModel(
      {this.latitude,
      this.longitude,
      this.isMocked,
      this.service,
      this.outOfZone,
      this.zoneId,
      this.isValid});

  AttendanceDataModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    isMocked = json['isMocked'];
    service = json['service'];
    outOfZone = json['outOfZone'];
    zoneId = json['zoneId'];
    isValid = json['isValid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['isMocked'] = isMocked;
    data['service'] = service;
    data['outOfZone'] = outOfZone;
    data['zoneId'] = zoneId;
    data['isValid'] = isValid;
    return data;
  }
}
