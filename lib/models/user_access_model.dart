class UserAccessModel {
  String? userId;
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
  bool? canteenManager;
  bool? jobCardDownload;
  bool? regularization;
  bool? busLate;
  int? timeout;
  String? deviceId;
  bool? printToken;
  String? driverId;
  bool? debug;

  UserAccessModel(
      {this.userId,
      this.editionId,
      this.edition,
      this.isActive,
      this.controlPanel,
      this.notifier,
      this.zoneManager,
      this.locationManager,
      this.attendanceMonitor,
      this.poll,
      this.directory,
      this.canteen,
      this.transport,
      this.notification,
      this.notice,
      this.attendance,
      this.leave,
      this.outstation,
      this.approval,
      this.payslip,
      this.jobCard,
      this.holiday,
      this.jobHistory,
      this.hiring,
      this.providentFund,
      this.myProfile,
      this.policies,
      this.updateProfile,
      this.canteenManager,
      this.jobCardDownload,
      this.regularization,
      this.busLate,
      this.timeout,
      this.deviceId,
      this.printToken,
      this.driverId,
      this.debug});

  UserAccessModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
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

    jobCardDownload = json["jobCardDownload"];
    regularization = json["regularization"];
    busLate = json["busLate"];
    timeout = json['timeout'];
    deviceId = json['deviceId'];
    driverId = json['driverId'];
    printToken = json['printToken'];
    debug = json['debug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
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

    data["jobCardDownload"] = jobCardDownload;
    data["regularization"] = regularization;
    data["busLate"] = busLate;
    data['timeout'] = timeout;
    data['deviceId'] = deviceId;
    data['driverId'] = driverId;
    data['printToken'] = printToken;
    data['debug'] = debug;
    return data;
  }
}
