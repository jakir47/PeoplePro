class OutstationApprovalModel {
  int? stepNumber;
  String? taskName;
  String? approver;
  DateTime? actionDate;
  String? status;

  OutstationApprovalModel(
      {this.stepNumber,
      this.taskName,
      this.approver,
      this.actionDate,
      this.status});

  OutstationApprovalModel.fromJson(Map<String, dynamic> json) {
    stepNumber = json['stepNumber'];
    taskName = json['taskName'];
    approver = json['approver'];
    actionDate = DateTime.parse(json['actionDate'].toString());
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stepNumber'] = stepNumber;
    data['taskName'] = taskName;
    data['approver'] = approver;
    data['actionDate'] = actionDate;
    data['status'] = status;
    return data;
  }
}
