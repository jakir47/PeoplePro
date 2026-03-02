class MealOffReportModel {
  String? empCode;
  String? name;
  String? department;
  String? designation;
  int? totalDays;

  MealOffReportModel({
    this.empCode,
    this.name,
    this.department,
    this.designation,
    this.totalDays,
  });

  MealOffReportModel.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    name = json['name'];
    department = json['department'];
    designation = json['designation'];
    totalDays = json['totalDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['name'] = name;
    data['department'] = department;
    data['designation'] = designation;
    data['totalDays'] = totalDays;
    return data;
  }
}
