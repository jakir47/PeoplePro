import 'dart:convert';

List<WorkflowTaskLine> workflowTaskLineFromJson(String str) =>
    List<WorkflowTaskLine>.from(
        json.decode(str).map((x) => WorkflowTaskLine.fromJson(x)));

String workflowTaskLineToJson(List<WorkflowTaskLine> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkflowTaskLine {
  WorkflowTaskLine({
    required this.id,
    required this.workflowStatus,
    this.taskDate,
    this.actionDate,
    required this.workFlowTaskNumber,
    this.taskDueDate,
    this.readyForAction,
    //   required this.stepNumber,
    this.comment,
    this.wfCategory,
    this.employeeName,
    this.description,
    //  this.workflowTask,
  });

  String? id;
  String workflowStatus;
  DateTime? taskDate;
  DateTime? actionDate;
  String workFlowTaskNumber;
  DateTime? taskDueDate;
  bool? readyForAction;
//  int stepNumber;
  String? comment;
  String? wfCategory;
  String? employeeName;
  String? description;
//  WorkflowTask? workflowTask;

  factory WorkflowTaskLine.fromJson(Map<String, dynamic> json) =>
      WorkflowTaskLine(
        id: json["id"],
        workflowStatus: json["workflowStatus"],
        taskDate:
            json["taskDate"] == null ? null : DateTime.parse(json["taskDate"]),
        actionDate: json["actionDate"] == null
            ? null
            : DateTime.parse(json["actionDate"]),
        workFlowTaskNumber: json["workFlowTaskNumber"],
        taskDueDate: json["taskDueDate"] == null
            ? null
            : DateTime.parse(json["taskDueDate"]),
        readyForAction: json["readyForAction"],
        //      stepNumber: json["stepNumber"] == null ? null : json["stepNumber"],
        comment: json["comment"] ?? "",
//        workflowTask: WorkflowTask.fromJson(json["workflowTask"] == null ? null : json["workflowTask"]),
        wfCategory: json["wfCategory"],
        employeeName: json["employeeName"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "workflowStatus": workflowStatus,
        "taskDate": taskDate,
        "actionDate": actionDate,
        "workFlowTaskNumber": workFlowTaskNumber,
        "taskDueDate": taskDueDate,
        "readyForAction": readyForAction,
        //       "stepNumber": stepNumber == null ? null : stepNumber,
        "comment": comment ?? "",
        //     "workflowTask": workflowTask == null ? null : workflowTask,
        "wfCategory": wfCategory ?? "",
        "employeeName": employeeName ?? "",
        "description": description ?? "",
      };
}

//----

// To parse this JSON data, do
//
//     final workflowTask = workflowTaskFromJson(jsonString);

//import 'package:meta/meta.dart';
//import 'dart:convert';

List<WorkflowTask> workflowTaskFromJson(String str) => List<WorkflowTask>.from(
    json.decode(str).map((x) => WorkflowTask.fromJson(x)));

String workflowTaskToJson(List<WorkflowTask> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkflowTask {
  WorkflowTask({
    required this.id,
    required this.workflowCompleteDate,
    required this.docNumber,
    required this.workflowStatus,
    this.wfCategory,
    required this.entityId,
    required this.workflowDate,
    this.description,
  });

  String id;
  DateTime workflowCompleteDate;
  String docNumber;
  String workflowStatus;
  String? wfCategory;
  String entityId;
  DateTime workflowDate;
  String? description;

  factory WorkflowTask.fromJson(Map<String, dynamic> json) => WorkflowTask(
        id: json["id"],
        workflowCompleteDate: json["workflowCompleteDate"],
        docNumber: json["docNumber"],
        workflowStatus: json["workflowStatus"],
        wfCategory: json["wfCategory"],
        entityId: json["entityId"],
        workflowDate: json["workflowDate"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "workflowCompleteDate": workflowCompleteDate == null
            ? null
            : workflowCompleteDate.toIso8601String(),
        "docNumber": docNumber,
        "workflowStatus": workflowStatus,
        "wfCategory": wfCategory,
        "entityId": entityId,
        "workflowDate": workflowDate,
        "description": description,
      };
}
