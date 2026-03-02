class PayslipModel {
  String? payrollId;
  String? name;
  String? fromDate;
  String? toDate;
  double? grossAmount;
  double? deductionAmount;
  double? netAmount;
  String? inWord;
  String? salaryType;

  PayslipModel(
      {this.payrollId,
      this.name,
      this.fromDate,
      this.toDate,
      this.grossAmount,
      this.deductionAmount,
      this.netAmount,
      this.inWord,
      this.salaryType});

  PayslipModel.fromJson(Map<String, dynamic> json) {
    payrollId = json['payrollId'];
    name = json['name'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    grossAmount = double.parse(json['grossAmount'].toString());
    deductionAmount = double.parse(json['deductionAmount'].toString());
    netAmount = double.parse(json['netAmount'].toString());
    inWord = json['inWord'];
    salaryType = json['salaryType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payrollId'] = payrollId;
    data['name'] = name;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['grossAmount'] = grossAmount;
    data['deductionAmount'] = deductionAmount;
    data['netAmount'] = netAmount;
    data['inWord'] = inWord;
    data['salaryType'] = salaryType;
    return data;
  }
}
