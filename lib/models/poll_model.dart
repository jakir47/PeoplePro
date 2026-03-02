class PollModel {
  int? pollId;
  String? name;
  String? description;
  String? startTime;
  String? endTime;
  int? pollLineId;
  int? pollTotal;

  PollModel(
      {this.pollId,
      this.name,
      this.description,
      this.startTime,
      this.endTime,
      this.pollLineId,
      this.pollTotal});

  PollModel.fromJson(Map<String, dynamic> json) {
    pollId = json['pollId'];
    name = json['name'];
    description = json['description'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    pollLineId = json['pollLineId'];
    pollTotal = json['pollTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pollId'] = pollId;
    data['name'] = name;
    data['description'] = description;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['pollLineId'] = pollLineId;
    data['pollTotal'] = pollTotal;
    return data;
  }
}
