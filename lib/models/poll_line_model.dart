class PollLineModel {
  int? pollLineId;
  String? name;
  int? pollLineCount;
  double? pollPercent;

  PollLineModel(
      {this.pollLineId, this.name, this.pollLineCount, this.pollPercent});

  PollLineModel.fromJson(Map<String, dynamic> json) {
    pollLineId = json['pollLineId'];
    name = json['name'];
    pollLineCount = json['pollLineCount'];
    pollPercent = double.parse(json['pollPercent'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pollLineId'] = pollLineId;
    data['name'] = name;
    data['pollLineCount'] = pollLineCount;
    data['pollPercent'] = pollPercent;
    return data;
  }
}
