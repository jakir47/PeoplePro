class ApprovalTaskLineModel {
  String? workFlowTaskId;
  String? docNumber;
  String? taskName;
  DateTime? taskDate;
  DateTime? taskDueDate;
  String? empCode;
  String? empName;
  String? designation;
  String? department;
  String? remark;
  DateTime? applyDate;
  DateTime? startDate;
  DateTime? endDate;
  String? taskType;
  String? taskTypeLine;
  String? durationType;
  double? totalDays;

  ApprovalTaskLineModel(
      {this.workFlowTaskId,
      this.docNumber,
      this.taskName,
      this.taskDate,
      this.taskDueDate,
      this.empCode,
      this.empName,
      this.designation,
      this.department,
      this.remark,
      this.applyDate,
      this.startDate,
      this.endDate,
      this.taskType,
      this.taskTypeLine,
      this.durationType,
      this.totalDays});

  ApprovalTaskLineModel.fromJson(Map<String, dynamic> json) {
    workFlowTaskId = json['workFlowTaskId'];
    docNumber = json['docNumber'];
    taskName = json['taskName'];
    taskDate = DateTime.parse(json['taskDate']);
    taskDueDate = DateTime.parse(json['taskDueDate']);
    empCode = json['empCode'];
    empName = json['empName'];
    designation = json['designation'];
    department = json['department'];
    remark = json['remark'];
    applyDate = DateTime.parse(json['applyDate']);
    startDate = DateTime.parse(json['startDate']);
    endDate = DateTime.parse(json['endDate']);
    taskType = json['taskType'];
    taskTypeLine = json['taskTypeLine'];
    durationType = json['durationType'];
    totalDays = double.parse(json['totalDays'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workFlowTaskId'] = workFlowTaskId;
    data['docNumber'] = docNumber;
    data['taskName'] = taskName;
    data['taskDate'] = taskDate;
    data['taskDueDate'] = taskDueDate;
    data['empCode'] = empCode;
    data['empName'] = empName;
    data['designation'] = designation;
    data['department'] = department;
    data['remark'] = remark;
    data['applyDate'] = applyDate;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['taskType'] = taskType;
    data['taskTypeLine'] = taskTypeLine;
    data['durationType'] = durationType;
    data['totalDays'] = totalDays;
    return data;
  }
}
