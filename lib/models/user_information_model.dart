class UserInformationModel {
  String? empId;
  String? empCode;
  String? name;
  String? designation;
  String? departmentName;
  String? companyName;
  String? companyCode;
  String? photo;
  String? birthDate;
  String? gender;
  String? mobileNo;
  String? joiningDate;
  String? confirmationDate;
  String? bloodGroup;
  String? maritalStatus;
  String? email;
  String? nid;
  String? currentAddress;
  String? permanentAddress;
  String? motherName;
  String? fatherName;
  String? bankAccountNo;
  double? grossSalary;
  String? spouseName;
  String? operatingLocation;
  String? operatingAddress;
  String? attendanceLocation;
  String? attendanceLocationId;
  String? managerName;
  String? managerDesignation;
  String? departmentId;

  UserInformationModel({
    this.empId,
    this.empCode,
    this.name,
    this.designation,
    this.departmentName,
    this.companyName,
    this.companyCode,
    this.photo,
    this.birthDate,
    this.gender,
    this.mobileNo,
    this.joiningDate,
    this.confirmationDate,
    this.bloodGroup,
    this.maritalStatus,
    this.email,
    this.nid,
    this.currentAddress,
    this.permanentAddress,
    this.motherName,
    this.fatherName,
    this.bankAccountNo,
    this.grossSalary,
    this.spouseName,
    this.operatingLocation,
    this.operatingAddress,
    this.attendanceLocation,
    this.attendanceLocationId,
    this.managerName,
    this.managerDesignation,
    this.departmentId,
  });

  UserInformationModel.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    empCode = json['empCode'];
    name = json['name'];
    designation = json['designation'];
    departmentName = json['departmentName'];
    companyName = json['companyName'];
    companyCode = json['companyCode'];
    photo = json['photo'];
    birthDate = json['birthDate'];
    gender = json['gender'];
    mobileNo = json['mobileNo'];
    joiningDate = json['joiningDate'];
    confirmationDate = json['confirmationDate'];
    bloodGroup = json['bloodGroup'] ?? "";
    maritalStatus = json['maritalStatus'];
    email = json['email'] ?? "";
    nid = json['nid'] ?? "";
    currentAddress = json['currentAddress'] ?? "";
    permanentAddress = json['permanentAddress'] ?? "";
    motherName = json['motherName'] ?? "";
    fatherName = json['fatherName'] ?? "";
    bankAccountNo = json['bankAccountNo'];
    grossSalary = double.parse(json['grossSalary'].toString());
    spouseName = json['spouseName'];
    operatingLocation = json['operatingLocation'];
    operatingAddress = json['operatingAddress'] ?? "";
    attendanceLocation = json['attendanceLocation'] ?? "";
    attendanceLocationId = json['attendanceLocationId'];
    managerName = json['managerName'] ?? "";
    managerDesignation = json['managerDesignation'] ?? "";
    departmentId = json['departmentId'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['empCode'] = empCode;
    data['name'] = name;
    data['designation'] = designation;
    data['departmentName'] = departmentName;
    data['companyName'] = companyName;
    data['companyCode'] = companyCode;
    data['photo'] = photo;
    data['birthDate'] = birthDate;
    data['gender'] = gender;
    data['mobileNo'] = mobileNo;
    data['joiningDate'] = joiningDate;
    data['confirmationDate'] = confirmationDate;
    data['bloodGroup'] = bloodGroup;
    data['maritalStatus'] = maritalStatus;
    data['email'] = email;
    data['nid'] = nid;
    data['currentAddress'] = currentAddress;
    data['permanentAddress'] = permanentAddress;
    data['motherName'] = motherName;
    data['fatherName'] = fatherName;
    data['bankAccountNo'] = bankAccountNo;
    data['grossSalary'] = grossSalary;
    data['spouseName'] = spouseName;
    data['operatingLocation'] = operatingLocation;
    data['operatingAddress'] = operatingAddress;
    data['attendanceLocation'] = attendanceLocation;
    data['attendanceLocationId'] = attendanceLocationId;
    data['managerName'] = managerName;
    data['managerDesignation'] = managerDesignation;
    data['departmentId'] = departmentId;
    return data;
  }
}
