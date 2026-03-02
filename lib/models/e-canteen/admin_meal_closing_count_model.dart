class AdminMealClosingCountModel {
  DateTime? issueDate;
  bool? isToday;
  int? total;

  AdminMealClosingCountModel({
    this.issueDate,
    this.isToday = false,
    this.total = 0,
  });

  AdminMealClosingCountModel.fromJson(Map<String, dynamic> json) {
    issueDate = DateTime.parse(json['issueDate']);
    isToday = json['isToday'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['issueDate'] = issueDate;
    data['isToday'] = isToday;
    data['total'] = total;
    return data;
  }
}
