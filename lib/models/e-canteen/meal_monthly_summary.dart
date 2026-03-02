class MealMonthlySummary {
  String? title;
  int? total;
  int? employee;
  int? guest;
  int? driver;

  MealMonthlySummary(
      {this.title = "",
      this.total = 0,
      this.employee = 0,
      this.guest = 0,
      this.driver = 0});

  MealMonthlySummary.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    total = json['total'];
    employee = json['employee'];
    guest = json['guest'];
    driver = json['driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['total'] = total;
    data['employee'] = employee;
    data['guest'] = guest;
    data['driver'] = driver;
    return data;
  }
}
