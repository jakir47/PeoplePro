class PopupNotificationModel {
  int? notificationId;
  String? imageName;
  bool? isRepeated;

  PopupNotificationModel(
      {this.notificationId, this.imageName, this.isRepeated});

  PopupNotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = int.parse(json['notificationId'].toString());
    imageName = json['imageName'];
    isRepeated = json['isRepeated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationId'] = notificationId;
    data['imageName'] = imageName;
    data['isRepeated'] = isRepeated;
    return data;
  }
}
