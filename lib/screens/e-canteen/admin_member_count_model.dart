class AdminMemberCountModel {
  int? total;
  int? paidCount;
  int? riceCount;
  int? freeCount;

  AdminMemberCountModel(
      {this.total = 0,
      this.paidCount = 0,
      this.riceCount = 0,
      this.freeCount = 0});

  AdminMemberCountModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    paidCount = json['paidCount'];
    riceCount = json['riceCount'];
    freeCount = json['freeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['paidCount'] = paidCount;
    data['riceCount'] = riceCount;
    data['freeCount'] = freeCount;
    return data;
  }
}
