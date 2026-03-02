import 'dart:convert';

List<LeaveApplication> leaveApplicationFromJson(String str) =>
    List<LeaveApplication>.from(
        json.decode(str).map((x) => LeaveApplication.fromJson(x)));
String leaveApplicationToJson(List<LeaveApplication> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//LeaveApplicationBrowse leaveApplicationBrowseFromJson(String str) => LeaveApplicationBrowse.fromJson(json.decode(str));
//String LeaveApplicationBrowseToJson(LeaveApplicationBrowse data) => json.encode(data.toJson());

class LeaveApplication {
  LeaveApplication({
    required this.entityName,
    required this.instanceName,
    required this.id,
    required this.appNumber,
    required this.applicationDate,
    required this.startDate,
    required this.endDate,
    required this.leaveProfileLine,
    required this.durationType,
    required this.totalDays,
    required this.employee,
    required this.processState,
    this.note,
  });

  final String entityName;
  final String instanceName;
  final String id;
  final String appNumber;
  final DateTime? applicationDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final LeaveProfileLine? leaveProfileLine;
  final String durationType;
  final double totalDays;
  final Employee? employee;
  final String processState;
  String? note;

  factory LeaveApplication.fromJson(Map<String, dynamic> json) =>
      LeaveApplication(
        entityName: json["_entityName"],
        instanceName: json["_instanceName"],
        id: json["id"],
        appNumber: json["appNumber"],
        applicationDate: json["applicationDate"] == null
            ? null
            : DateTime.parse(json["applicationDate"]),
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        leaveProfileLine: json["leaveProfileLine"] == null
            ? null
            : LeaveProfileLine.fromJson(json["leaveProfileLine"]),
        durationType: json["durationType"],
        totalDays: json["totalDays"],
        employee: json["employee"] == null
            ? null
            : Employee.fromJson(json["employee"]),
        processState: json["processState"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "_entityName": entityName,
        "_instanceName": instanceName,
        "id": id,
        "appNumber": appNumber,
        "applicationDate": applicationDate,
        "startDate": startDate,
        "endDate": endDate,
        "leaveProfileLine": leaveProfileLine,
        "durationType": durationType,
        "totalDays": totalDays,
        "employee": employee,
        "processState": processState,
        "note": note,
      };
}

class Employee {
  Employee({
    required this.entityName,
    required this.instanceName,
    required this.id,
    required this.name,
  });

  final String entityName;
  final String instanceName;
  final String id;
  final String? name;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        entityName: json["_entityName"],
        instanceName: json["_instanceName"],
        id: json["id"],
        name: json["_name"] == null ? null : json["_name"],
      );

  Map<String, dynamic> toJson() => {
        "_entityName": entityName,
        "_instanceName": instanceName,
        "id": id,
        "_name": name,
      };
}

class LeaveProfileLine {
  LeaveProfileLine({
    required this.entityName,
    required this.instanceName,
    required this.id,
    //  required this.leaveType,
  });

  final String entityName;
  final String instanceName;
  final String id;
//  final LeaveType leaveType;

  factory LeaveProfileLine.fromJson(Map<String, dynamic> json) =>
      LeaveProfileLine(
        entityName: json["_entityName"],
        instanceName: json["_instanceName"],
        id: json["id"],
        //  leaveType: LeaveType.fromJson(json["leaveType"]), // == null ? null : LeaveType.fromJson(json["leaveType"]),
        //  leaveType: json["leaveType"], // == null ? null : LeaveType.fromJson(json["leaveType"]),
        // leaveType: json["leaveType"] == null ? null : LeaveType.fromJson(json["leaveType"]),
      );

  Map<String, dynamic> toJson() => {
        "_entityName": entityName,
        "_instanceName": instanceName,
        "id": id,
        //  "leaveType": leaveType,
      };
}

class LeaveType {
  LeaveType({
    required this.entityName,
    required this.instanceName,
    required this.id,
    required this.leaveTypeCode,
    required this.name,
  });

  final String entityName;
  final String instanceName;
  final String id;
  final String leaveTypeCode;
  final String name;

  factory LeaveType.fromJson(Map<String, dynamic> json) => LeaveType(
        entityName: json["_entityName"],
        instanceName: json["_instanceName"],
        id: json["id"],
        leaveTypeCode: json["leaveTypeCode"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_entityName": entityName,
        "_instanceName": instanceName,
        "id": id,
        "leaveTypeCode": leaveTypeCode,
        "name": name,
      };
}

enum ProcessState { APPROVED, APPROVAL_IN_PROGRESS, REJECTED, NOT_STARTED }
