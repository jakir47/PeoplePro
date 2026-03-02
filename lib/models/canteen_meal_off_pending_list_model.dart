class MealOffPendingListModel {
  int? mealOffId;
  String? empCode;
  String? name;
  String? department;
  String? designation;
  DateTime? fromDate;
  DateTime? toDate;
  int? days;
  DateTime? submittedAt;
  String? remarks;

  MealOffPendingListModel(
      {this.mealOffId,
      this.empCode,
      this.name,
      this.department,
      this.designation,
      this.fromDate,
      this.toDate,
      this.days,
      this.submittedAt,
      this.remarks});

  MealOffPendingListModel.fromJson(Map<String, dynamic> json) {
    mealOffId = json['mealOffId'];
    empCode = json['empCode'];
    name = json['name'];
    department = json['department'];
    designation = json['designation'];
    fromDate = DateTime.parse(json['fromDate']);
    toDate = DateTime.parse(json['toDate']);
    days = json['days'];
    submittedAt = DateTime.parse(json['submittedAt']);
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mealOffId'] = mealOffId;
    data['empCode'] = empCode;
    data['name'] = name;
    data['department'] = department;
    data['designation'] = designation;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['days'] = days;
    data['submittedAt'] = submittedAt;
    data['remarks'] = remarks;
    return data;
  }
}
