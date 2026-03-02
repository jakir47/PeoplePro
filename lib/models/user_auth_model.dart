import 'package:peoplepro/models/user_access_model.dart';

class UserAuthModel {
  String? jwtToken;
  UserAccessModel? access;
  String? inteAccToken;
  String? message;
  bool? success;

  UserAuthModel(
      {this.jwtToken,
      this.access,
      this.inteAccToken,
      this.success,
      this.message});

  UserAuthModel.fromJson(Map<String, dynamic> json) {
    jwtToken = json['jwtToken'];
    access = json['access'] != null
        ? UserAccessModel.fromJson(json['access'])
        : null;
    inteAccToken = json['inteAccToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jwtToken'] = jwtToken;
    if (access != null) {
      data['access'] = access!.toJson();
    }
    data['inteAccToken'] = inteAccToken;
    return data;
  }
}
