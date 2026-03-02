class LogDto {
  String? userId;
  String? logText;
  String? logData;
  String? logTypeId;

  LogDto({this.userId, this.logText, this.logData, this.logTypeId});

  LogDto.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    logText = json['logText'];
    logData = json['logData'];
    logTypeId = json['logTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['logText'] = logText;
    data['logData'] = logData;
    data['logTypeId'] = logTypeId;
    return data;
  }
}
