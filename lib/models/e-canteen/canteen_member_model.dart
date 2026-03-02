class CanteenMemberModel {
  String? empCode;
  String? name;
  String? designation;
  String? department;
  String? company;
  String? unit;
  bool? isRiceService;
  bool? isFreeService;
  bool? isActive;
  String? cardId;
  bool? isGuest;
  bool? isMasterCard;

  CanteenMemberModel(
      {this.empCode,
      this.name,
      this.designation,
      this.department,
      this.company,
      this.unit,
      this.isRiceService,
      this.isFreeService,
      this.isActive,
      this.cardId,
      this.isGuest,
      this.isMasterCard});

  CanteenMemberModel.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    name = json['name'];
    designation = json['designation'];
    department = json['department'];
    company = json['company'];
    unit = json['unit'];
    isRiceService = json['isRiceService'];
    isFreeService = json['isFreeService'];
    isActive = json['isActive'];
    cardId = json['cardId'];
    isGuest = json['isGuest'];
    isMasterCard = json['isMasterCard'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['name'] = name;
    data['designation'] = designation;
    data['department'] = department;
    data['company'] = company;
    data['unit'] = unit;
    data['isRiceService'] = isRiceService;
    data['isFreeService'] = isFreeService;
    data['isActive'] = isActive;
    data['cardId'] = cardId;
    data['isGuest'] = isGuest;
    data['isMasterCard'] = isMasterCard;
    return data;
  }
}
