import 'dart:convert';
import 'package:peoplepro/models/e-canteen/meal_card_model.dart';
import 'package:peoplepro/models/e-canteen/meal_closing_model.dart';
import 'package:peoplepro/models/e-canteen/meal_closing_response_model.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:http/http.dart' as http;

class CanteenService {
  static Future<String> generateToken() async {
    try {
      var uri = Uri.parse("${Settings.apiUrl}/canteen/token");
      var bodyData = jsonEncode(
          {"UserId": Session.empCode, "DeviceId": Settings.deviceId});

      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: bodyData);

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

  static Future<MealClosingResponseModel> mealClosing(
      String userId, List<DateTime> issueDates) async {
    var output = MealClosingResponseModel(
        isSuccess: false, message: "Cannot fulfill your closing request.");
    try {
      var uri = Uri.parse("${Settings.apiUrl}/canteen/meal/closing");

      var issueDatesFormatted =
          issueDates.map((date) => date.toIso8601String()).toList();

      var data = {"EmpId": userId, "IssueDates": issueDatesFormatted};

      var bodyData = jsonEncode(data);

      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: bodyData);

      if (response.statusCode == 200) {
        var jsonText = jsonDecode(response.body);
        output = MealClosingResponseModel.fromJson(jsonText);
      }
    } catch (e) {
      //
    }
    return output;
  }

  static Future<bool> mealClosingCancel(String userId, int id) async {
    try {
      var uri = Uri.parse("${Settings.apiUrl}/canteen/meal/closing/cancel");
      var data = {"EmpId": userId, "id": id};
      var bodyData = jsonEncode(data);

      final response = await http.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: bodyData);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<MealClosingModel>> getMealClosingList(
      String userId) async {
    List<MealClosingModel> lines = [];
    try {
      var url = "${Settings.apiUrl}/canteen/meal/closing/list?userId=$userId";
      var uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ApiKey': Settings.apiKey,
        },
      );

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        lines = decodedText
            .map<MealClosingModel>((json) => MealClosingModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }

  static Future<List<MealCardModel>> getMealCard(
      String fromDate, String toDate) async {
    List<MealCardModel> items = [];
    try {
      var url =
          "${Settings.apiUrl}/canteen/meal/card?userId=${Session.empCode}&fromDate=$fromDate&toDate=$toDate";

      var uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ApiKey': Settings.apiKey,
        },
      );

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        items = decodedText
            .map<MealCardModel>((json) => MealCardModel.fromJson(json))
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
