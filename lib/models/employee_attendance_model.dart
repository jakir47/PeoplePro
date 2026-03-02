class EmployeeAttendanceModel {
  String? empCode;
  String? name;
  String? designation;
  String? section;
  String? department;
  String? location;
  String? company;
  String? entryTime;
  String? workShirtStart;
  int? graceMinute;
  String? attendSource;
  bool? isPresent;
  bool? isLate;
  int? lateMinute;

  EmployeeAttendanceModel(
      {this.empCode,
      this.name,
      this.designation,
      this.section,
      this.department,
      this.location,
      this.company,
      this.entryTime,
      this.workShirtStart,
      this.graceMinute,
      this.attendSource,
      this.isPresent,
      this.isLate,
      this.lateMinute});

  EmployeeAttendanceModel.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    name = json['name'];
    designation = json['designation'];
    section = json['section'];
    department = json['department'];
    location = json['location'];
    company = json['company'];
    entryTime = json['entryTime'];
    workShirtStart = json['workShirtStart'];
    graceMinute = json['graceMinute'];
    attendSource = json['attendSource'];
    isPresent = json['isPresent'];
    isLate = json['isLate'];
    lateMinute = json['lateMinute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['name'] = name;
    data['designation'] = designation;
    data['section'] = section;
    data['department'] = department;
    data['location'] = location;
    data['company'] = company;
    data['entryTime'] = entryTime;
    data['workShirtStart'] = workShirtStart;
    data['graceMinute'] = graceMinute;
    data['attendSource'] = attendSource;
    data['isPresent'] = isPresent;
    data['isLate'] = isLate;
    data['lateMinute'] = lateMinute;
    return data;
  }
}
