class EmployeeProfileModel {
  String? bloodGroup;
  String? ipx;
  String? mobileNo;
  String? emergencyContact;
  String? email;
  bool? isBloodDonor;

  EmployeeProfileModel(
      {this.bloodGroup,
      this.ipx,
      this.mobileNo,
      this.emergencyContact,
      this.email,
      this.isBloodDonor});

  EmployeeProfileModel.fromJson(Map<String, dynamic> json) {
    bloodGroup = json['bloodGroup'];
    ipx = json['ipx'];
    mobileNo = json['mobileNo'];
    emergencyContact = json['emergencyContact'];
    email = json['email'];
    isBloodDonor = json['isBloodDonor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bloodGroup'] = bloodGroup;
    data['ipx'] = ipx;
    data['mobileNo'] = mobileNo;
    data['emergencyContact'] = emergencyContact;
    data['email'] = email;
    data['isBloodDonor'] = isBloodDonor;
    return data;
  }
}
