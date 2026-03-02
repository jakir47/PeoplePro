class RequestModel {
  String? empCode;
  int? requestTypeId;
  String? startDate;
  String? endDate;
  int? mealCount;
  String? remarks;

  RequestModel(
      {this.empCode,
      this.requestTypeId,
      this.startDate,
      this.endDate,
      this.mealCount,
      this.remarks});

  RequestModel.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    requestTypeId = json['requestTypeId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    mealCount = json['mealCount'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['requestTypeId'] = requestTypeId;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['mealCount'] = mealCount;
    data['remarks'] = remarks;
    return data;
  }
}
