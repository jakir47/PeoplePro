class ProvidentFundModel {
  String? payrollNo;
  String? salaryPeriod;
  double? amount;

  ProvidentFundModel({this.payrollNo, this.salaryPeriod, this.amount});

  ProvidentFundModel.fromJson(Map<String, dynamic> json) {
    payrollNo = json['payrollNo'];
    salaryPeriod = json['salaryPeriod'];
    amount = double.parse(json['amount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payrollNo'] = payrollNo;
    data['salaryPeriod'] = salaryPeriod;
    data['amount'] = amount;
    return data;
  }
}
