class DurationModel {
  int? year;
  int? month;
  int? day;
  bool? isOneYearToday;

  DurationModel({this.year, this.month, this.day, this.isOneYearToday});

  DurationModel.fromJson(Map<String, dynamic> json) {
    year = int.parse(json['year'].toString());
    month = int.parse(json['month'].toString());
    day = int.parse(json['day'].toString());
    isOneYearToday = json['isOneYearToday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['month'] = month;
    data['day'] = day;
    data['isOneYearToday'] = isOneYearToday;
    return data;
  }
}
