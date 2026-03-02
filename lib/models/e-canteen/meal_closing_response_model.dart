class MealClosingResponseModel {
  bool? isSuccess;
  String? message;

  MealClosingResponseModel({this.isSuccess, this.message});

  MealClosingResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;

    return data;
  }
}

class FactoryGuestTokenResponseModel {
  bool? isSuccess;
  String? message;

  FactoryGuestTokenResponseModel({this.isSuccess, this.message});

  FactoryGuestTokenResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;

    return data;
  }
}
