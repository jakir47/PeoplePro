class LeaveApplicationModel {
  DateTime? applicationDate;
  DateTime? startDate;
  DateTime? endDate;
  double? totalDays;
  String? remarks;
  String? status;
  String? leaveType;
  String? durationType;
  String? docNumber;

  LeaveApplicationModel(
      {this.applicationDate,
      this.startDate,
      this.endDate,
      this.totalDays,
      this.remarks,
      this.status,
      this.leaveType,
      this.durationType,
      this.docNumber});

  LeaveApplicationModel.fromJson(Map<String, dynamic> json) {
    applicationDate = DateTime.parse(json['applicationDate'].toString());
    startDate = DateTime.parse(json['startDate'].toString());
    endDate = DateTime.parse(json['endDate'].toString());
    totalDays = double.parse(json['totalDays'].toString());
    remarks = json['remarks'];
    status = json['status'];
    leaveType = json['leaveType'];
    durationType = json['durationType'];
    docNumber = json['docNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['applicationDate'] = applicationDate;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['totalDays'] = totalDays;
    data['remarks'] = remarks;
    data['status'] = status;
    data['leaveType'] = leaveType;
    data['durationType'] = durationType;
    data['docNumber'] = docNumber;
    return data;
  }
}
