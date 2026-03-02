import 'package:flutter/cupertino.dart';

class NoticeModel {
  int? noticeId;
  String? title;
  String? content;
  String? thumbnail;
  DateTime? publishDate;
  String? image;
  Image? thubnailImage;

  NoticeModel(
      {this.noticeId,
      this.title,
      this.content,
      this.thumbnail,
      this.publishDate,
      this.image,
      this.thubnailImage});

  NoticeModel.fromJson(Map<String, dynamic> json) {
    noticeId = json['noticeId'];
    title = json['title'];
    content = json['content'];
    thumbnail = json['thumbnail'];
    publishDate = DateTime.parse(json['publishDate']);
    image = json['image'];
    thubnailImage = json['thubnailImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['noticeId'] = noticeId;
    data['title'] = title;
    data['content'] = content;
    data['publishDate'] = publishDate;
    data['image'] = image;
    data['thumbnail'] = thumbnail;
    data['thubnailImage'] = thubnailImage;
    return data;
  }
}
