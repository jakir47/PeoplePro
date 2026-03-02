import 'package:peoplepro/models/poll_line_model.dart';
import 'package:peoplepro/models/poll_model.dart';

class PollDataModel {
  PollModel? poll;
  List<PollLineModel>? pollLines;
  PollDataModel({this.poll, this.pollLines});

  PollDataModel.fromJson(Map<String, dynamic> json) {
    poll = json['poll'] != null ? PollModel.fromJson(json['poll']) : null;
    if (json['pollLines'] != null) {
      pollLines = <PollLineModel>[];
      json['pollLines'].forEach((v) {
        pollLines!.add(PollLineModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (poll != null) {
      data['poll'] = poll!.toJson();
    }
    if (pollLines != null) {
      data['pollLines'] = pollLines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
