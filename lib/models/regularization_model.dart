class RegularizationModel {
  DateTime? date;
  String? dateOfRegularization;
  String? purpose;

  RegularizationModel({this.date, this.dateOfRegularization, this.purpose});

  RegularizationModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dateOfRegularization = json['dateOfRegularization'];
    purpose = json['purpose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['dateOfRegularization'] = dateOfRegularization;
    data['purpose'] = purpose;
    return data;
  }
}
