class PayslipLineModel {
  String? headName;
  bool? isEarning;
  String? headType;
  double? amount;

  PayslipLineModel({this.headName, this.isEarning, this.headType, this.amount});

  PayslipLineModel.fromJson(Map<String, dynamic> json) {
    headName = json['headName'];
    isEarning = json['isEarning'];
    headType = json['headType'];
    amount = double.parse(json['amount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['headName'] = headName;
    data['isEarning'] = isEarning;
    data['headType'] = headType;
    data['amount'] = amount;
    return data;
  }
}
