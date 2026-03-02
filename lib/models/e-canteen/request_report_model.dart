class RequestReportModel {
  String? empCode;
  String? name;
  String? department;
  String? designation;
  String? location;
  int? totalMealOff;
  int? totalMyGuest;
  DateTime? startDate;
  DateTime? endDate;

  RequestReportModel({
    this.empCode,
    this.name,
    this.department,
    this.designation,
    this.location,
    this.totalMealOff,
    this.totalMyGuest,
    this.startDate,
    this.endDate,
  });

  RequestReportModel.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    name = json['name'];
    department = json['department'];
    designation = json['designation'];
    location = json['location'];
    totalMealOff = json['totalMealOff'];
    totalMyGuest = json['totalMyGuest'];
    startDate = DateTime.parse(json['startDate']);
    endDate = DateTime.parse(json['endDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['name'] = name;
    data['department'] = department;
    data['designation'] = designation;
    data['location'] = location;
    data['totalMealOff'] = totalMealOff;
    data['totalMyGuest'] = totalMyGuest;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}
