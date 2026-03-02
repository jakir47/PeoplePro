import 'dart:convert';

List<OutstationDuty> outstationDutyFromJson(String str) =>
    List<OutstationDuty>.from(
        json.decode(str).map((x) => OutstationDuty.fromJson(x)));
String outstationDutyToJson(List<OutstationDuty> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OutstationDuty {
  OutstationDuty({
    this.id,
    this.appNo,
    required this.appDate,
    required this.dateFrom,
    required this.dateTo,
    required this.purpose,
    required this.location,
    required this.durationType,
    required this.totalDays,
    this.employee,
    this.processState,
  });

  final String? id;
  final String? appNo;
  final DateTime? appDate;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String? purpose;
  final String? location;
  final String durationType;
  final double? totalDays;
  final Employee? employee;
  final String? processState;

  factory OutstationDuty.fromJson(Map<String, dynamic> json) => OutstationDuty(
        id: json["id"],
        appNo: json["appNo"],
        appDate:
            json["appDate"] == null ? null : DateTime.parse(json["appDate"]),
        dateFrom: DateTime.parse(json["dateFrom"]),
        dateTo: DateTime.parse(json["dateTo"]),
        purpose: json["purpose"] == null ? '' : json["purpose"],
        location: json["location"] == null ? '' : json["location"],
        durationType: json["durationType"],
        totalDays:
            json["totalDays"], // == null ? 0 : double.parse(json["totalDays"]),
        employee: json["employee"] == null
            ? null
            : Employee.fromJson(json["employee"]),
        processState: json["processState"] == null ? '' : json["processState"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "appNo": appNo,
        "appDate": appDate,
        "dateFrom": dateFrom,
        "dateTo": dateTo,
        "purpose": purpose,
        "location": location,
        "durationType": durationType,
        "totalDays": totalDays,
        "employee": employee,
        "processState": processState,
      };
}

class Employee {
  Employee({
    required this.id,
    required this.name,
  });

  final String id;
  final String? name;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["_name"] == null ? null : json["_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "_name": name,
      };
}

enum ProcessState { APPROVED, APPROVAL_IN_PROGRESS, REJECTED, NOT_STARTED }
