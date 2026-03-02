class MealCardModel {
  DateTime? issueDate;
  int? total;
  int? employee;
  int? guest;
  int? driver;
  String? statusText;

  MealCardModel({
    this.issueDate,
    this.total,
    this.employee,
    this.guest,
    this.driver,
    this.statusText,
  });

  MealCardModel.fromJson(Map<String, dynamic> json) {
    issueDate = DateTime.parse(json['issueDate']);
    total = json['total'];
    employee = json['employee'];
    guest = json['guest'];
    driver = json['driver'];
    statusText = json['statusText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['issueDate'] = issueDate;
    data['total'] = total;
    data['employee'] = employee;
    data['guest'] = guest;
    data['driver'] = driver;
    data['statusText'] = statusText;
    return data;
  }
}
