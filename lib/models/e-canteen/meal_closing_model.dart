class MealClosingModel {
  int? id;
  String? empId;
  DateTime? issueDate;
  bool? isDriver;
  bool? cancellable;

  MealClosingModel(
      {this.id, this.empId, this.issueDate, this.isDriver, this.cancellable});

  MealClosingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empId = json['empId'];
    issueDate = DateTime.parse(json['issueDate']);
    isDriver = json['isDriver'];
    cancellable = json['cancellable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['empId'] = empId;
    data['issueDate'] = issueDate;
    data['isDriver'] = isDriver;
    data['cancellable'] = cancellable;
    return data;
  }
}
