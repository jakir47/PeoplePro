class JobCardModel {
  DateTime? date;
  String? day;
  String? status;
  String? inTime;
  String? outTime;
  int? lateMinutes;
  double? overTimeHours;
  String? remarks;

  JobCardModel(
      {this.date,
      this.day,
      this.status,
      this.inTime,
      this.outTime,
      this.lateMinutes,
      this.overTimeHours,
      this.remarks});

  JobCardModel.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date'].toString());
    day = json['day'];
    status = json['status'];
    inTime = json['inTime'];
    outTime = json['outTime'];
    lateMinutes = json['lateMinutes'];
    overTimeHours = double.parse(json['overTimeHours'].toString());
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['day'] = day;
    data['status'] = status;
    data['inTime'] = inTime;
    data['outTime'] = outTime;
    data['lateMinutes'] = lateMinutes;
    data['overTimeHours'] = overTimeHours;
    data['remarks'] = remarks;
    return data;
  }
}
