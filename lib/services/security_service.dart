import 'dart:convert';
import 'package:peoplepro/dtos/log_dto.dart';
import 'package:peoplepro/models/user_access_model.dart';
import 'package:peoplepro/models/user_access_view_model.dart';
import 'package:peoplepro/services/http.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:http/http.dart' as http;

class SecurityService {
  static Future<String> getDeviceStatus() async {
    try {
      var url =
          "${Settings.apiUrl}/security/device/status?userId=${Session.empCode}&deviceId=${Settings.deviceId}";

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
        var json = jsonDecode(response.body);
        Settings.deviceStatus = json;
        return json;
      } else {
        return "none";
      }
    } catch (e) {
      return "none";
    }
  }

  static Future<bool> createDeviceRequest() async {
    try {
      var url = "${Settings.apiUrl}/security/device/request";

      var uri = Uri.parse(url);
      var bodyData = jsonEncode({
        'userId': Session.empCode,
        'deviceId': Settings.deviceId,
        'brand': Settings.brand,
        'model': Settings.model,
        'osVersion': Settings.osVersion,
      });
      print(bodyData);
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ApiKey': Settings.apiKey,
          },
          body: bodyData);

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeDevice(String userId) async {
    try {
      var url = "${Settings.apiUrl}/security/device/remove?userId=$userId";

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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getUserStatus(String userId) async {
    try {
      var url =
          "${Settings.apiUrl}/security/user/status?userId=$userId&version=${Settings.appVersion}";
      Utils.log(url, "Url");
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
        var json = jsonDecode(response.body);
        bool isActive = json['isActive'];
        return isActive;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> createLog(LogDto log) async {
    try {
      var url = "${Settings.apiUrl}/security/log/create";
      var uri = Uri.parse(url);
      var bodyData = jsonEncode(log);
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ApiKey': Settings.apiKey,
          },
          body: bodyData);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<UserAccessViewModel?> getUserAccess(String empCode) async {
    try {
      var url = "${Settings.apiUrl}/security/user/access?empCode=$empCode";
      print(url);
      var uri = Uri.parse(url);
      final response = await http.get(uri, headers: Http.headers(true, false));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json);
        var data = UserAccessViewModel.fromJson(json);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateUserAccess(UserAccessModel userAccess) async {
    try {
      var url = "${Settings.apiUrl}/security/user/access/update";

      var uri = Uri.parse(url);
      var bodyData = jsonEncode(userAccess);
      print(bodyData);
      final response = await http.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ApiKey': Settings.apiKey,
          },
          body: bodyData);
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
