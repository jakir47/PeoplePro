class BirthdayModel {
  int? year;
  int? month;
  int? day;
  bool? isBirthdayToday;

  BirthdayModel({this.year, this.month, this.day, this.isBirthdayToday});

  BirthdayModel.fromJson(Map<String, dynamic> json) {
    year = int.parse(json['year'].toString());
    month = int.parse(json['month'].toString());
    day = int.parse(json['day'].toString());
    isBirthdayToday = json['isBirthdayToday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['month'] = month;
    data['day'] = day;
    data['isBirthdayToday'] = isBirthdayToday;
    return data;
  }
}
