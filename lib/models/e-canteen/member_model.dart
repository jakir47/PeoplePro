class MemberModel {
  String? empCode;
  String? name;
  String? designation;
  String? department;
  String? location;
  String? company;

  MemberModel(
      {this.empCode,
      this.name,
      this.designation,
      this.department,
      this.location,
      this.company});

  MemberModel.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    name = json['name'];
    designation = json['designation'];
    department = json['department'];
    location = json['location'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['name'] = name;
    data['designation'] = designation;
    data['department'] = department;
    data['location'] = location;
    data['company'] = company;
    return data;
  }
}
