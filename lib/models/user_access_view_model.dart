class UserAccessViewModel {
  String? userId;
  String? name;
  String? department;
  String? designation;
  int? editionId;
  String? edition;
  bool? isActive;
  bool? controlPanel;
  bool? notifier;
  bool? zoneManager;
  bool? locationManager;
  bool? attendanceMonitor;
  bool? poll;
  bool? directory;
  bool? canteen;
  bool? transport;
  bool? notification;
  bool? notice;
  bool? attendance;
  bool? leave;
  bool? outstation;
  bool? approval;
  bool? payslip;
  bool? jobCard;
  bool? holiday;
  bool? jobHistory;
  bool? hiring;
  bool? providentFund;
  bool? myProfile;
  bool? policies;
  bool? updateProfile;
  bool? printToken;
  bool? canteenManager;
  bool? jobCardDownload;
  bool? regularization;
  bool? busLate;
  bool? debug;

  UserAccessViewModel({
    this.userId,
    this.name,
    this.department,
    this.designation,
    this.editionId = 3,
    this.edition = "",
    this.isActive = false,
    this.controlPanel = false,
    this.notifier = false,
    this.zoneManager = false,
    this.locationManager = false,
    this.attendanceMonitor = false,
    this.poll = false,
    this.directory = false,
    this.canteen = false,
    this.transport = false,
    this.notification = false,
    this.notice = false,
    this.attendance = false,
    this.leave = false,
    this.outstation = false,
    this.approval = false,
    this.payslip = false,
    this.jobCard = false,
    this.holiday = false,
    this.jobHistory = false,
    this.hiring = false,
    this.providentFund = false,
    this.myProfile = false,
    this.policies = false,
    this.updateProfile = false,
    this.canteenManager = false,
    this.printToken = false,
    this.jobCardDownload = false,
    this.regularization = false,
    this.busLate = false,
    this.debug = false,
  });

  UserAccessViewModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    department = json['department'];
    designation = json['designation'];
    editionId = json['editionId'];
    edition = json['edition'];
    isActive = json['isActive'];
    controlPanel = json['controlPanel'];
    notifier = json['notifier'];
    zoneManager = json['zoneManager'];
    locationManager = json['locationManager'];
    attendanceMonitor = json['attendanceMonitor'];
    poll = json['poll'];
    directory = json['directory'];
    canteen = json['canteen'];
    transport = json['transport'];
    notification = json['notification'];
    notice = json['notice'];
    attendance = json['attendance'];
    leave = json['leave'];
    outstation = json['outstation'];
    approval = json['approval'];
    payslip = json['payslip'];
    jobCard = json['jobCard'];
    holiday = json['holiday'];
    jobHistory = json['jobHistory'];
    hiring = json['hiring'];
    providentFund = json['providentFund'];
    myProfile = json['myProfile'];
    policies = json['policies'];
    updateProfile = json['updateProfile'];
    canteenManager = json['canteenManager'];
    printToken = json['printToken'];
    jobCardDownload = json["jobCardDownload"];
    regularization = json["regularization"];
    busLate = json["busLate"];
    debug = json["debug"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['name'] = name;
    data['department'] = department;
    data['designation'] = designation;
    data['editionId'] = editionId;
    data['edition'] = edition;
    data['isActive'] = isActive;
    data['controlPanel'] = controlPanel;
    data['notifier'] = notifier;
    data['zoneManager'] = zoneManager;
    data['locationManager'] = locationManager;
    data['attendanceMonitor'] = attendanceMonitor;
    data['poll'] = poll;
    data['directory'] = directory;
    data['canteen'] = canteen;
    data['transport'] = transport;
    data['notification'] = notification;
    data['notice'] = notice;
    data['attendance'] = attendance;
    data['leave'] = leave;
    data['outstation'] = outstation;
    data['approval'] = approval;
    data['payslip'] = payslip;
    data['jobCard'] = jobCard;
    data['holiday'] = holiday;
    data['jobHistory'] = jobHistory;
    data['hiring'] = hiring;
    data['providentFund'] = providentFund;
    data['myProfile'] = myProfile;
    data['policies'] = policies;
    data['updateProfile'] = updateProfile;
    data['canteenManager'] = canteenManager;
    data['printToken'] = printToken;
    data["jobCardDownload"] = jobCardDownload;
    data["regularization"] = regularization;
    data["busLate"] = busLate;
    data["debug"] = debug;
    return data;
  }
}
