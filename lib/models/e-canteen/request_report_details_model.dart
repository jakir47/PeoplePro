class RequestReportDetailsModel {
  int? requestLineId;
  String? requestTypeName;
  String? empCode;
  DateTime? startDate;
  DateTime? endDate;
  int? mealCount;
  DateTime? submittedAt;
  String? remarks;

  RequestReportDetailsModel(
      {this.requestLineId,
      this.requestTypeName,
      this.empCode,
      this.startDate,
      this.endDate,
      this.mealCount,
      this.submittedAt,
      this.remarks});

  RequestReportDetailsModel.fromJson(Map<String, dynamic> json) {
    requestLineId = json['requestLineId'];
    requestTypeName = json['requestTypeName'];
    empCode = json['empCode'];
    startDate = DateTime.parse(json['startDate']);
    endDate = DateTime.parse(json['endDate']);
    mealCount = json['mealCount'];
    submittedAt = DateTime.parse(json['submittedAt']);
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestLineId'] = requestLineId;
    data['requestTypeName'] = requestTypeName;
    data['empCode'] = empCode;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['mealCount'] = mealCount;
    data['submittedAt'] = submittedAt;
    data['remarks'] = remarks;
    return data;
  }
}
