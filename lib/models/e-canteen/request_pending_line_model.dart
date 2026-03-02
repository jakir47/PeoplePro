class RequestPendingLineModel {
  int? requestLineId;
  String? requestTypeName;
  String? empCode;
  String? designation;
  String? department;
  String? location;
  DateTime? startDate;
  DateTime? endDate;
  int? mealCount;
  DateTime? submittedAt;
  String? remarks;
  String? empName;

  RequestPendingLineModel(
      {this.requestLineId,
      this.requestTypeName,
      this.empCode,
      this.designation,
      this.department,
      this.location,
      this.startDate,
      this.endDate,
      this.mealCount,
      this.submittedAt,
      this.remarks,
      this.empName});

  RequestPendingLineModel.fromJson(Map<String, dynamic> json) {
    requestLineId = json['requestLineId'];
    requestTypeName = json['requestTypeName'];
    empCode = json['empCode'];
    designation = json['designation'];
    department = json['department'];
    location = json['location'];
    startDate = DateTime.parse(json['startDate']);
    endDate = DateTime.parse(json['endDate']);
    mealCount = json['mealCount'];
    submittedAt = DateTime.parse(json['submittedAt']);
    remarks = json['remarks'];
    empName = json['empName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestLineId'] = requestLineId;
    data['requestTypeName'] = requestTypeName;
    data['empCode'] = empCode;
    data['designation'] = designation;
    data['department'] = department;
    data['location'] = location;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['mealCount'] = mealCount;
    data['submittedAt'] = submittedAt;
    data['remarks'] = remarks;
    data['empName'] = empName;
    return data;
  }
}
