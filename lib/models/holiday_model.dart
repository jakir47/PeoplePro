class HolidayModel {
  int? holidayId;
  String? event;
  String? date;
  String? day;
  DateTime? eventDate;
  bool? isUpcoming;
  int? dayCount;
  DateTime? startDate;
  DateTime? endDate;

  HolidayModel(
      {this.holidayId,
      this.event,
      this.date,
      this.day,
      this.eventDate,
      this.isUpcoming,
      this.dayCount,
      this.startDate,
      this.endDate});

  HolidayModel.fromJson(Map<String, dynamic> json) {
    holidayId = json['holidayId'];
    event = json['event'];
    date = json['date'];
    day = json['day'];
    eventDate = DateTime.parse(json['eventDate']);
    isUpcoming = json['isUpcoming'];
    dayCount = json['dayCount'];
    startDate = DateTime.parse(json['startDate']);
    endDate = DateTime.parse(json['endDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['holidayId'] = holidayId;
    data['event'] = event;
    data['date'] = date;
    data['day'] = day;
    data['eventDate'] = eventDate;
    data['isUpcoming'] = isUpcoming;
    data['dayCount'] = dayCount;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}
