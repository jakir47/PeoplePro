import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peoplepro/utils/canteen_session.dart';

class CanteenService2 {
  //static String apiUrl = "http://10.0.3.2:5600/api/v1";
  static String apiUrl = "http://182.163.117.72:5600/api/v1";

  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${CanteenSession.jwtToken}',
    };
  }

  static Future<CanteenLoginModel?> login(
      String username, String password) async {
    try {
      var url = "$apiUrl/login";
      print(url);
      var uri = Uri.parse(url);
      var bodyData = jsonEncode(
          {'username': username, 'password': password, "client": "app"});

      final response = await http.post(uri,
          headers: CanteenSession.getHeaders(), body: bodyData);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var data = CanteenLoginModel.fromJson(json);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> printMealToken(String username, String deviceId) async {
    try {
      var uri = Uri.parse("$apiUrl/print-meal-token");
      var bodyData = jsonEncode({"username": username, "deviceId": deviceId});

      final response = await http.post(uri,
          headers: CanteenSession.getHeaders(), body: bodyData);

      if (response.statusCode == 200) {
        return "Success";
      } else if (response.statusCode == 400) {
        return jsonDecode(response.body);
      } else {
        return "Cannot fulfill your token request.";
      }
    } catch (e) {
      return "Cannot fulfill your token request.";
    }
  }

  static Future<List<CanteenMealCloseListModel>> getMealClosedList(
      String username) async {
    List<CanteenMealCloseListModel> lines = [];
    try {
      var url = "$apiUrl/meal-closed-list?username=$username";
      var uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: CanteenSession.getHeaders(),
      );
      ;
      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        lines = decodedText
            .map<CanteenMealCloseListModel>(
                (json) => CanteenMealCloseListModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }

  static Future<MealCloseResponse?> mealClose(
      String username, DateTime mealDate) async {
    try {
      var url = "$apiUrl/meal-close";
      var uri = Uri.parse(url);
      var bodyData = jsonEncode(
          {"username": username, "mealDate": mealDate.toIso8601String()});
      final response = await http.post(uri,
          headers: CanteenSession.getHeaders(), body: bodyData);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var data = MealCloseResponse.fromJson(json);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<MealCancelResponse?> mealCancel(
      String username, DateTime mealDate) async {
    try {
      var url = "$apiUrl/meal-cancel";
      var uri = Uri.parse(url);
      var bodyData = jsonEncode(
          {"username": username, "mealDate": mealDate.toIso8601String()});
      final response = await http.post(uri,
          headers: CanteenSession.getHeaders(), body: bodyData);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var data = MealCancelResponse.fromJson(json);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<MealCardResonse>> getMealCard(
      String username, String startDate, String endDate) async {
    List<MealCardResonse> items = [];
    try {
      var url =
          "$apiUrl/meal-card?username=$username&startDate=$startDate&endDate=$endDate";

      var uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: CanteenSession.getHeaders(),
      );

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        items = decodedText
            .map<MealCardResonse>((json) => MealCardResonse.fromJson(json))
            .toList();

        return items;
      } else {
        return items;
      }
    } catch (e) {
      return items;
    }
  }
}

class CanteenLoginModel {
  final String name;
  final int roleId;
  final String roleName;
  final bool isMealClosedToday;
  final String jwtToken;

  CanteenLoginModel({
    required this.name,
    required this.roleId,
    required this.roleName,
    required this.isMealClosedToday,
    required this.jwtToken,
  });

  factory CanteenLoginModel.fromJson(Map<String, dynamic> json) {
    return CanteenLoginModel(
      name: json['name'] ?? '',
      roleId: json['roleId'] ?? 0,
      roleName: json['roleName'] ?? '',
      isMealClosedToday: json['isMealClosedToday'] ?? false,
      jwtToken: json['jwtToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'roleId': roleId,
      'roleName': roleName,
      'isMealClosedToday': isMealClosedToday,
      'jwtToken': jwtToken,
    };
  }
}

class CanteenMealCloseListModel {
  final DateTime mealDate;
  final bool isCancellable;

  CanteenMealCloseListModel(
      {required this.mealDate, required this.isCancellable});

  factory CanteenMealCloseListModel.fromJson(Map<String, dynamic> json) {
    return CanteenMealCloseListModel(
      isCancellable: json['isCancellable'] ?? false,
      mealDate: json['mealDate'] != null
          ? DateTime.tryParse(json['mealDate'].toString()) ?? DateTime(1900)
          : DateTime(1900),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isCancellable': isCancellable,
      'mealDate': mealDate.toIso8601String(),
    };
  }
}

class MealCloseResponse {
  final bool success;
  final String message;

  MealCloseResponse({
    required this.success,
    required this.message,
  });

  factory MealCloseResponse.fromJson(Map<String, dynamic> json) {
    return MealCloseResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}

class MealCancelResponse {
  final bool success;
  final String message;

  MealCancelResponse({
    required this.success,
    required this.message,
  });

  factory MealCancelResponse.fromJson(Map<String, dynamic> json) {
    return MealCancelResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}

class MealCardResonse {
  final String employeeId;
  final DateTime mealDate;
  final int mealCount;
  final int guestCount;
  final bool isMealClosed;
  final String statusText;

  MealCardResonse({
    required this.employeeId,
    required this.mealDate,
    required this.mealCount,
    required this.guestCount,
    required this.isMealClosed,
    required this.statusText,
  });

  factory MealCardResonse.fromJson(Map<String, dynamic> json) {
    return MealCardResonse(
      employeeId: json['employeeId'] ?? '',
      mealDate: json['mealDate'] != null
          ? DateTime.tryParse(json['mealDate'].toString()) ?? DateTime(1900)
          : DateTime(1900),
      mealCount: json['mealCount'] ?? 0,
      guestCount: json['guestCount'] ?? 0,
      isMealClosed: json['isMealClosed'] ?? false,
      statusText: json['statusText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'mealDate': mealDate.toIso8601String(),
      'mealCount': mealCount,
      'guestCount': guestCount,
      'isMealClosed': isMealClosed,
      'statusText': statusText,
    };
  }
}
