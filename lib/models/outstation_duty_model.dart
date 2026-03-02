class OutstationDutyModel {
  DateTime? applicationDate;
  DateTime? startDate;
  DateTime? endDate;
  double? totalDays;
  String? location;
  String? status;
  String? durationType;
  String? docNumber;

  OutstationDutyModel(
      {this.applicationDate,
      this.startDate,
      this.endDate,
      this.totalDays,
      this.location,
      this.status,
      this.durationType,
      this.docNumber});

  OutstationDutyModel.fromJson(Map<String, dynamic> json) {
    applicationDate = DateTime.parse(json['applicationDate'].toString());
    startDate = DateTime.parse(json['startDate'].toString());
    endDate = DateTime.parse(json['endDate'].toString());
    totalDays = double.parse(json['totalDays'].toString());
    location = json['location'];
    status = json['status'];
    durationType = json['durationType'];
    docNumber = json['docNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['applicationDate'] = applicationDate;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['totalDays'] = totalDays;
    data['location'] = location;
    data['status'] = status;
    data['durationType'] = durationType;
    data['docNumber'] = docNumber;
    return data;
  }
}
