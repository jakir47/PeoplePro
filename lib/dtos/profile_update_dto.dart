class ProfileUpdateDto {
  String? empCode;
  ProfileUpdateDataLineModel? bloodGroup;
  ProfileUpdateDataLineModel? image;
  ProfileUpdateDataLineModel? ipx;
  ProfileUpdateDataLineModel? mobileNo;
  ProfileUpdateDataLineModel? mobileNoEmergency;
  ProfileUpdateDataLineModel? email;
  ProfileUpdateDataLineModel? isBloodDonor;

  ProfileUpdateDto(
      {this.empCode,
      this.bloodGroup,
      this.image,
      this.ipx,
      this.mobileNo,
      this.mobileNoEmergency,
      this.email,
      this.isBloodDonor});

  ProfileUpdateDto.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    bloodGroup = json['bloodGroup'] != null
        ? ProfileUpdateDataLineModel.fromJson(json['bloodGroup'])
        : null;
    image = json['image'] != null
        ? ProfileUpdateDataLineModel.fromJson(json['image'])
        : null;
    ipx = json['ipx'] != null
        ? ProfileUpdateDataLineModel.fromJson(json['ipx'])
        : null;
    mobileNo = json['mobileNo'] != null
        ? ProfileUpdateDataLineModel.fromJson(json['mobileNo'])
        : null;
    mobileNoEmergency = json['mobileNoEmergency'] != null
        ? ProfileUpdateDataLineModel.fromJson(json['mobileNoEmergency'])
        : null;
    email = json['email'] != null
        ? ProfileUpdateDataLineModel.fromJson(json['email'])
        : null;
    isBloodDonor = json['isBloodDonor'] != null
        ? ProfileUpdateDataLineModel.fromJson(json['isBloodDonor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    if (bloodGroup != null) {
      data['bloodGroup'] = bloodGroup!.toJson();
    }
    if (image != null) {
      data['image'] = image!.toJson();
    }
    if (ipx != null) {
      data['ipx'] = ipx!.toJson();
    }
    if (mobileNo != null) {
      data['mobileNo'] = mobileNo!.toJson();
    }
    if (mobileNoEmergency != null) {
      data['mobileNoEmergency'] = mobileNoEmergency!.toJson();
    }
    if (email != null) {
      data['email'] = email!.toJson();
    }
    if (isBloodDonor != null) {
      data['isBloodDonor'] = isBloodDonor!.toJson();
    }
    return data;
  }
}

class ProfileUpdateDataLineModel {
  String? data;
  bool? edited;

  ProfileUpdateDataLineModel({this.data, this.edited});

  ProfileUpdateDataLineModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    edited = json['edited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['edited'] = edited;
    return data;
  }
}
