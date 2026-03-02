class EmployeeDirectoryModel {
  String? empCode;
  String? name;
  String? bloodGroup;
  String? designation;
  String? department;
  String? section;
  String? company;
  String? location;
  String? mobileNo;
  String? email;
  String? ipx;
  String? motherName;
  String? fatherName;
  String? presentAddress;
  String? permanentAddress;
  String? photo;
  String? emergencyContact;
  String? maritalStatus;
  bool? isBloodDonor;
  bool? isActive;
  int? expLevel;
  DateTime? joiningDate;
  String? gender;
  DateTime? inActiveFrom;
  String? religion;

  EmployeeDirectoryModel({
    this.empCode,
    this.name,
    this.bloodGroup,
    this.designation,
    this.department,
    this.section,
    this.company,
    this.location,
    this.mobileNo,
    this.email,
    this.ipx,
    this.motherName,
    this.fatherName,
    this.presentAddress,
    this.permanentAddress,
    this.photo,
    this.emergencyContact,
    this.maritalStatus,
    this.isBloodDonor,
    this.isActive,
    this.expLevel,
    this.joiningDate,
    this.gender,
    this.inActiveFrom,
    this.religion,
  });

  EmployeeDirectoryModel.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    name = json['name'];
    bloodGroup = json['bloodGroup'];
    designation = json['designation'];
    department = json['department'];
    section = json['section'];
    company = json['company'];
    location = json['location'];
    mobileNo = json['mobileNo'];
    email = json['email'];
    ipx = json['ipx'];
    motherName = json['motherName'];
    fatherName = json['fatherName'];
    presentAddress = json['presentAddress'];
    permanentAddress = json['permanentAddress'];
    photo = json['photo'];
    emergencyContact = json['emergencyContact'];
    maritalStatus = json['maritalStatus'];
    isBloodDonor = json['isBloodDonor'];
    isActive = json['isActive'];
    expLevel = json['expLevel'];
    joiningDate = DateTime.parse(json['joiningDate'].toString());
    gender = json['gender'];
    inActiveFrom = DateTime.parse(json['inActiveFrom'].toString());
    religion = json['religion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['name'] = name;
    data['bloodGroup'] = bloodGroup;
    data['designation'] = designation;
    data['department'] = department;
    data['section'] = section;
    data['company'] = company;
    data['location'] = location;
    data['mobileNo'] = mobileNo;
    data['email'] = email;
    data['ipx'] = ipx;
    data['motherName'] = motherName;
    data['fatherName'] = fatherName;
    data['presentAddress'] = presentAddress;
    data['permanentAddress'] = permanentAddress;
    data['photo'] = photo;
    data['emergencyContact'] = emergencyContact;
    data['isBloodDonor'] = isBloodDonor;
    data['maritalStatus'] = maritalStatus;
    data['isActive'] = isActive;
    data['expLevel'] = expLevel;
    data['joiningDate'] = joiningDate;
    data['gender'] = gender;
    data['inActiveFrom'] = inActiveFrom;
    data['religion'] = religion;
    return data;
  }
}
