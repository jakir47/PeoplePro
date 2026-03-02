class RequestLineModel {
  int? requestLineId;
  String? empCode;
  DateTime? startDate;
  DateTime? endDate;
  int? mealCount;
  DateTime? submittedAt;
  String? remarks;
  int? statusId;
  String? statusName;
  int? requestTypeId;
  String? requestTypeName;
  DateTime? actionAt;

  RequestLineModel(
      {this.requestLineId,
      this.empCode,
      this.startDate,
      this.endDate,
      this.mealCount,
      this.submittedAt,
      this.remarks,
      this.statusId,
      this.statusName,
      this.requestTypeId,
      this.requestTypeName,
      this.actionAt});

  RequestLineModel.fromJson(Map<String, dynamic> json) {
    requestLineId = json['requestLineId'];
    empCode = json['empCode'];
    startDate = DateTime.parse(json['startDate']);
    endDate = DateTime.parse(json['endDate']);
    mealCount = json['mealCount'];
    submittedAt = DateTime.parse(json['submittedAt']);
    remarks = json['remarks'];
    statusId = json['statusId'];
    statusName = json['statusName'];
    requestTypeId = json['requestTypeId'];
    requestTypeName = json['requestTypeName'];
    actionAt = DateTime.parse(json['actionAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestLineId'] = requestLineId;
    data['empCode'] = empCode;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['mealCount'] = mealCount;
    data['submittedAt'] = submittedAt;
    data['remarks'] = remarks;
    data['statusId'] = statusId;
    data['statusName'] = statusName;
    data['requestTypeId'] = requestTypeId;
    data['requestTypeName'] = requestTypeName;
    data['actionAt'] = actionAt;
    return data;
  }
}
