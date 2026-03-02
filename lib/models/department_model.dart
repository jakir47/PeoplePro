class DepartmentModel {
  String? departmentId;
  String? name;
  DepartmentModel({this.departmentId, this.name});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    departmentId = json['departmentId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['departmentId'] = departmentId;
    data['name'] = name;

    return data;
  }
}
