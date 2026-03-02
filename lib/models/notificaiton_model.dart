class NotificationModel {
  int? notificationId;
  String? title;
  String? content;
  DateTime? createdAt;

  NotificationModel(
      {this.notificationId, this.title, this.content, this.createdAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    title = json['title'];
    content = json['content'];
    createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationId'] = notificationId;
    data['title'] = title;
    data['content'] = content;
    data['createdAt'] = createdAt;
    return data;
  }
}
