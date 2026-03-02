class MealOffPendingListModel {
  int? mealOffId;
  String? empCode;
  String? name;
  String? department;
  String? designation;
  String? fromDate;
  String? toDate;
  int? days;
  String? submittedAt;
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
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    days = json['days'];
    submittedAt = json['submittedAt'];
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
