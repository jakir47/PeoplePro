import 'dart:ui';

import 'package:flutter/material.dart';

class AttendanceZoneModel {
  int? zoneId;
  String? name;
  double? latitude;
  double? longitude;
  Color? color;
  String? attendanceLocationId;

  AttendanceZoneModel(
      {this.zoneId,
      this.name,
      this.latitude,
      this.longitude,
      this.color,
      this.attendanceLocationId});

  AttendanceZoneModel.fromJson(Map<String, dynamic> json) {
    zoneId = json['zoneId'] ?? 0;
    name = json['name'] ?? "";
    latitude = json['latitude'] ?? 0.0;
    longitude = json['longitude'] ?? 0.0;
    attendanceLocationId = json['attendanceLocationId'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zoneId'] = zoneId;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['color'] = color;
    data['attendanceLocationId'] = attendanceLocationId;
    return data;
  }
}
