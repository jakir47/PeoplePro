import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:peoplepro/models/e-canteen/admin_meal_closing_count_model.dart';
import 'package:peoplepro/models/e-canteen/canteen_admin_card_model.dart';
import 'package:peoplepro/models/e-canteen/canteen_member_model.dart';
import 'package:peoplepro/models/e-canteen/cateen_admin_factory_guest_token_model.dart';
import 'package:peoplepro/models/e-canteen/meal_card_model.dart';
import 'package:peoplepro/models/e-canteen/meal_closing_model.dart';
import 'package:peoplepro/models/e-canteen/meal_closing_response_model.dart';
import 'package:peoplepro/models/e-canteen/meal_count_summary_model.dart';
import 'package:peoplepro/models/e-canteen/meal_daily_summary_model.dart';
import 'package:peoplepro/models/e-canteen/meal_monthly_summary.dart';
import 'package:peoplepro/models/e-canteen/request_line_model.dart';
import 'package:peoplepro/models/e-canteen/request_model.dart';
import 'package:peoplepro/models/e-canteen/request_pending_line_model.dart';
import 'package:peoplepro/models/e-canteen/request_report_details_model.dart';
import 'package:peoplepro/models/e-canteen/request_report_model.dart';
import 'package:peoplepro/screens/e-canteen/admin_member_count_model.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:http/http.dart' as http;
import 'package:peoplepro/utils/utils.dart';

class CanteenService {
  static Future<bool> makeRequest(RequestModel request) async {
    try {
      var url = "${Settings.apiUrl}/canteen/request/make";

      var uri = Uri.parse(url);
      var bodyData = jsonEncode(request);

      final response = await http.post(uri,
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

  static Future<List<RequestLineModel>> getRequestList() async {
    List<RequestLineModel> lines = [];
    try {
      var url =
          "${Settings.apiUrl}/canteen/request/list?empCode=${Session.empCode}";
      var uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ApiKey': Settings.apiKey,
        },
      );
      ;
      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        lines = decodedText
            .map<RequestLineModel>((json) => RequestLineModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }

  static Future<List<RequestPendingLineModel>> getRequestPendingList() async {
    List<RequestPendingLineModel> lines = [];
    try {
      var url = "${Settings.apiUrl}/canteen/request/pending/list";
      var uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ApiKey': Settings.apiKey,
        },
      );
      ;
      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        lines = decodedText
            .map<RequestPendingLineModel>(
                (json) => RequestPendingLineModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }

  static Future<bool> requestAction(
      int requestLineId, int statusId, String actionBy) async {
    try {
      var url = "${Settings.apiUrl}/canteen/request/action";
      var uri = Uri.parse(url);
      var bodyData = jsonEncode({
        "requestLineId": requestLineId,
        "statusId": statusId,
        "actionBy": actionBy
      });
      final response = await http.post(uri,
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

  static Future<List<RequestReportModel>> getRequestReport(
      String startDate, String endDate, String? empCode) async {
    List<RequestReportModel> lines = [];
    try {
      var url =
          "${Settings.apiUrl}/canteen/request/report?startDate=$startDate&endDate=$endDate${empCode!.isEmpty ? "" : "&empCode=$empCode"}";

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
            .map<RequestReportModel>(
                (json) => RequestReportModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }

  static Future<List<RequestReportDetailsModel>> getRequestReportDetails(
      String empCode, DateTime startDate, DateTime endDate) async {
    List<RequestReportDetailsModel> lines = [];

    try {
      var url =
          "${Settings.apiUrl}/canteen/request/report/details?startDate=$startDate&endDate=$endDate&empCode=$empCode}";

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
            .map<RequestReportDetailsModel>(
                (json) => RequestReportDetailsModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }

  static Future<List<RequestReportModel>> getCalculatedMeals(
      String startDate, String endDate, int costTotal, int mealTotal) async {
    List<RequestReportModel> lines = [];

    try {
      var url =
          "${Settings.apiUrl}/canteen/request/calculate/meals?startDate=$startDate&endDate=$endDate&costTotal=$costTotal&mealTotal=$mealTotal";

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
            .map<RequestReportModel>(
                (json) => RequestReportModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }

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

  static Future<MealMonthlySummary> getMealMonthlySummary(String userId) async {
    var summary = MealMonthlySummary();

    try {
      var url = "${Settings.apiUrl}/canteen/meal/summary?userId=$userId";
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
        var jsonText = jsonDecode(response.body);
        summary = MealMonthlySummary.fromJson(jsonText);

        return summary;
      } else {
        return summary;
      }
    } catch (e) {
      return summary;
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

  static Future<List<CanteenMemberModel>> getMembers() async {
    List<CanteenMemberModel> members = [];
    try {
      var uri = Uri.parse("${Settings.apiUrl}/canteen/admin/members");

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ApiKey': Settings.apiKey,
      });

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        members = decodedText
            .map<CanteenMemberModel>(
                (json) => CanteenMemberModel.fromJson(json))
            .toList();

        return members;
      } else {
        return members;
      }
    } catch (e) {
      return members;
    }
  }

  static Future<List<CanteenMemberModel>> getMembersQuery(
      int type, dynamic inputData) async {
    List<CanteenMemberModel> members = [];

    var input = "xyz";

    if (type == 4) {
      input = DateFormat("yyyy-MM-dd").format(inputData);
    } else if (type == 5) {
      input = inputData.toString();
    }

    try {
      var uri = Uri.parse(
          "${Settings.apiUrl}/canteen/admin/members/query?type=$type&input=$input");

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ApiKey': Settings.apiKey,
      });

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        members = decodedText
            .map<CanteenMemberModel>(
                (json) => CanteenMemberModel.fromJson(json))
            .toList();

        return members;
      } else {
        return members;
      }
    } catch (e) {
      return members;
    }
  }

  static Future<List<CanteenMemberModel>> getAdminCardMembers(
      String cardId) async {
    List<CanteenMemberModel> members = [];
    try {
      var uri = Uri.parse(
          "${Settings.apiUrl}/canteen/admin/members/query?type=5&input=$cardId");

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ApiKey': Settings.apiKey,
      });

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        members = decodedText
            .map<CanteenMemberModel>(
                (json) => CanteenMemberModel.fromJson(json))
            .toList();

        return members;
      } else {
        return members;
      }
    } catch (e) {
      return members;
    }
  }

  static Future<List<CanteenMemberModel>> getAdminCardMemberSearch(
      String memberId) async {
    List<CanteenMemberModel> members = [];
    try {
      var uri = Uri.parse(
          "${Settings.apiUrl}/canteen/admin/members/query?type=6&input=$memberId");

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ApiKey': Settings.apiKey,
      });

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        members = decodedText
            .map<CanteenMemberModel>(
                (json) => CanteenMemberModel.fromJson(json))
            .toList();

        return members;
      } else {
        return members;
      }
    } catch (e) {
      return members;
    }
  }

  static Future<bool> adminMasterCardMemberAddRemove(
      String cardId, String empId) async {
    try {
      var uri =
          Uri.parse("${Settings.apiUrl}/canteen/admin/mastercard/addremove");
      var data = {"CardId": cardId, "EmpId": empId};
      var bodyData = jsonEncode(data);

      final response = await http.post(uri,
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

  static Future<bool> adminMemberStatusUpdate(
      String userId, String empId) async {
    try {
      var uri =
          Uri.parse("${Settings.apiUrl}/canteen/admin/employee-status-update");
      var data = {"UserId": userId, "EmpId": empId};
      var bodyData = jsonEncode(data);

      final response = await http.post(uri,
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

  static Future<List<MealCountSummaryModel>> getMealCountSummary() async {
    List<MealCountSummaryModel> members = [];
    try {
      var uri = Uri.parse("${Settings.apiUrl}/canteen/admin/meal/count");

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ApiKey': Settings.apiKey,
      });

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        members = decodedText
            .map<MealCountSummaryModel>(
                (json) => MealCountSummaryModel.fromJson(json))
            .toList();

        return members;
      } else {
        return members;
      }
    } catch (e) {
      return members;
    }
  }

  static Future<AdminMemberCountModel> getAdminMemberCount() async {
    var summary = AdminMemberCountModel();

    try {
      var url = "${Settings.apiUrl}/canteen/admin/member/count";
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
        var jsonText = jsonDecode(response.body);
        summary = AdminMemberCountModel.fromJson(jsonText);

        return summary;
      } else {
        return summary;
      }
    } catch (e) {
      return summary;
    }
  }

  static Future<List<AdminMealClosingCountModel>>
      getAdminMealClosingCountSummary() async {
    List<AdminMealClosingCountModel> members = [];
    try {
      var uri = Uri.parse("${Settings.apiUrl}/canteen/admin/closing/count");

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ApiKey': Settings.apiKey,
      });

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        members = decodedText
            .map<AdminMealClosingCountModel>(
                (json) => AdminMealClosingCountModel.fromJson(json))
            .toList();

        return members;
      } else {
        return members;
      }
    } catch (e) {
      return members;
    }
  }

  static Future<List<AdminFactoryGuestTokenModel>>
      getAdminFactoryGuestTokens() async {
    List<AdminFactoryGuestTokenModel> tokens = [];
    try {
      var uri =
          Uri.parse("${Settings.apiUrl}/canteen/admin/factory/guest/token");

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ApiKey': Settings.apiKey,
      });

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        tokens = decodedText
            .map<AdminFactoryGuestTokenModel>(
                (json) => AdminFactoryGuestTokenModel.fromJson(json))
            .toList();

        return tokens;
      } else {
        return tokens;
      }
    } catch (e) {
      return tokens;
    }
  }

  static Future<List<CanteenAdminCardModel>> getAdminCards() async {
    List<CanteenAdminCardModel> cards = [];
    try {
      var uri = Uri.parse("${Settings.apiUrl}/canteen/admin/cards");

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ApiKey': Settings.apiKey,
      });

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        cards = decodedText
            .map<CanteenAdminCardModel>(
                (json) => CanteenAdminCardModel.fromJson(json))
            .toList();

        return cards;
      } else {
        return cards;
      }
    } catch (e) {
      return cards;
    }
  }

  static Future<FactoryGuestTokenResponseModel> updateFactoryGuestToken(
      AdminFactoryGuestTokenModel data) async {
    var output = FactoryGuestTokenResponseModel(
        isSuccess: false, message: "Cannot fulfill your request.");
    try {
      var uri = Uri.parse(
          "${Settings.apiUrl}/canteen/admin/factory/guest/token/update");

      var bodyData = jsonEncode(data);

      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: bodyData);

      if (response.statusCode == 200) {
        var jsonText = jsonDecode(response.body);
        output = FactoryGuestTokenResponseModel.fromJson(jsonText);
      }
    } catch (e) {
      //
    }
    return output;
  }

  static Future<List<MealDailySummaryModel>> getAdminDailyReport(
      DateTime reportDate) async {
    List<MealDailySummaryModel> items = [];
    try {
      var reportText = Utils.formatDate(reportDate, format: "yyyy-MM-dd");
      var url =
          "${Settings.apiUrl}/canteen/admin/report/daily?reportDate=$reportText";

      print(url);

      var uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ApiKey': Settings.apiKey,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        items = decodedText
            .map<MealDailySummaryModel>(
                (json) => MealDailySummaryModel.fromJson(json))
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
