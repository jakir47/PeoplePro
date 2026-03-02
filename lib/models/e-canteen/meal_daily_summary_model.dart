class MealDailySummaryModel {
  String? issueDate;
  String? empId;
  String? name;
  String? designation;
  String? depratment;
  String? unit;
  int? empMeal;
  int? guestMeal;
  bool? isEmpTaken;
  String? driverId;
  int? driverMeal;
  bool? isDriverTaken;
  int? totalMeal;
  bool? isMealClosed;
  String? statusText;
  bool? isFreeService;
  bool? isRiceService;

  MealDailySummaryModel({
    this.issueDate,
    this.empId,
    this.name,
    this.designation,
    this.depratment,
    this.unit,
    this.empMeal,
    this.guestMeal,
    this.isEmpTaken,
    this.driverId,
    this.driverMeal,
    this.isDriverTaken,
    this.totalMeal,
    this.isMealClosed,
    this.statusText,
    this.isRiceService,
    this.isFreeService,
  });

  MealDailySummaryModel.fromJson(Map<String, dynamic> json) {
    issueDate = json['issueDate'];
    empId = json['empId'];
    name = json['name'];
    designation = json['designation'];
    depratment = json['depratment'];
    unit = json['unit'];
    empMeal = json['empMeal'];
    guestMeal = json['guestMeal'];
    isEmpTaken = json['isEmpTaken'];
    driverId = json['driverId'];
    driverMeal = json['driverMeal'];
    isDriverTaken = json['isDriverTaken'];
    totalMeal = json['totalMeal'];
    isMealClosed = json['isMealClosed'];
    statusText = json['statusText'];
    isRiceService = json['isRiceService'];
    isFreeService = json['isFreeService'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['issueDate'] = issueDate;
    data['empId'] = empId;

    data['name'] = name;
    data['designation'] = designation;
    data['depratment'] = depratment;
    data['unit'] = unit;

    data['empMeal'] = empMeal;
    data['guestMeal'] = guestMeal;
    data['isEmpTaken'] = isEmpTaken;
    data['driverId'] = driverId;
    data['driverMeal'] = driverMeal;
    data['isDriverTaken'] = isDriverTaken;
    data['totalMeal'] = totalMeal;
    data['isMealClosed'] = isMealClosed;
    data['statusText'] = statusText;
    data['isRiceService'] = isRiceService;
    data['isFreeService'] = isFreeService;
    return data;
  }
}
