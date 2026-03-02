class LeaveBalanaceModel {
  String? sEntityName;
  String? sInstanceName;
  String? id;
  double? entitled;
  double? opening;
  double? balanceDays;
  double? leaveApproved;
  double? lateDeductDays;
  LeaveType? leaveType;
  LeaveProfileLine? leaveProfileLine;
  double? inprocessDays;

  LeaveBalanaceModel(
      {this.sEntityName,
      this.sInstanceName,
      this.id,
      this.entitled,
      this.opening,
      this.balanceDays,
      this.leaveApproved,
      this.lateDeductDays,
      this.leaveType,
      this.leaveProfileLine,
      this.inprocessDays});

  LeaveBalanaceModel.fromJson(Map<String, dynamic> json) {
    sEntityName = json['_entityName'];
    sInstanceName = json['_instanceName'];
    id = json['id'];
    entitled = json['entitled'];
    opening = json['opening'];
    balanceDays = json['balanceDays'];
    leaveApproved = json['leaveApproved'];
    lateDeductDays = json['lateDeductDays'];
    leaveType = json['leaveType'] != null
        ? LeaveType.fromJson(json['leaveType'])
        : null;
    leaveProfileLine = json['leaveProfileLine'] != null
        ? LeaveProfileLine.fromJson(json['leaveProfileLine'])
        : null;
    inprocessDays = json['inprocessDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_entityName'] = sEntityName;
    data['_instanceName'] = sInstanceName;
    data['id'] = id;
    data['entitled'] = entitled;
    data['opening'] = opening;
    data['balanceDays'] = balanceDays;
    data['leaveApproved'] = leaveApproved;
    data['lateDeductDays'] = lateDeductDays;
    if (leaveType != null) {
      data['leaveType'] = leaveType!.toJson();
    }
    if (leaveProfileLine != null) {
      data['leaveProfileLine'] = leaveProfileLine!.toJson();
    }
    data['inprocessDays'] = inprocessDays;
    return data;
  }
}

class LeaveType {
  String? sEntityName;
  String? sInstanceName;
  String? id;
  String? name;
  String? leaveTypeCode;

  LeaveType(
      {this.sEntityName,
      this.sInstanceName,
      this.id,
      this.name,
      this.leaveTypeCode});

  LeaveType.fromJson(Map<String, dynamic> json) {
    sEntityName = json['_entityName'];
    sInstanceName = json['_instanceName'];
    id = json['id'];
    name = json['name'];
    leaveTypeCode = json['leaveTypeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_entityName'] = sEntityName;
    data['_instanceName'] = sInstanceName;
    data['id'] = id;
    data['name'] = name;
    data['leaveTypeCode'] = leaveTypeCode;
    return data;
  }
}

class LeaveProfileLine {
  String? sEntityName;
  String? sInstanceName;
  String? id;
  String? consecDaysLimitEnfType;
  LeaveType? leaveType;
  bool? canCarryForward;

  LeaveProfileLine(
      {this.sEntityName,
      this.sInstanceName,
      this.id,
      this.consecDaysLimitEnfType,
      this.leaveType,
      this.canCarryForward});

  LeaveProfileLine.fromJson(Map<String, dynamic> json) {
    sEntityName = json['_entityName'];
    sInstanceName = json['_instanceName'];
    id = json['id'];
    consecDaysLimitEnfType = json['consecDaysLimitEnfType'];
    leaveType = json['leaveType'] != null
        ? LeaveType.fromJson(json['leaveType'])
        : null;
    canCarryForward = json['canCarryForward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_entityName'] = sEntityName;
    data['_instanceName'] = sInstanceName;
    data['id'] = id;
    data['consecDaysLimitEnfType'] = consecDaysLimitEnfType;
    if (leaveType != null) {
      data['leaveType'] = leaveType!.toJson();
    }
    data['canCarryForward'] = canCarryForward;
    return data;
  }
}
