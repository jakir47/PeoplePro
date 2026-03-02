import 'dart:convert';

import 'package:peoplepro/models/user_data_model.dart';
import 'package:peoplepro/services/http.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:http/http.dart' as http;

class TesterService {
  static Future<String?> login(String userId, String password) async {
    try {
      var url = "${Settings.apiUrl}/security/user/login";
      var uri = Uri.parse(url);
      var bodyData = jsonEncode({
        'userId': userId,
        'password': password,
        'version': Settings.appVersion,
      });

      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ApiKey': Settings.apiKey,
          },
          body: bodyData);

      var responseText =
          "status: ${response.statusCode}, body: ${response.body}";

      return responseText;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> getUserData(String empCode) async {
    try {
      var url = "${Settings.apiUrl}/hive/user/data?empCode=$empCode";

      var uri = Uri.parse(url);
      final response = await http.get(uri, headers: Http.headers(true, false));
      try {
        var json = jsonDecode(response.body);

        var data = UserDataModel.fromJson(json);

        data.userInformation!.photo = "";
        data.notices = [];
        data.policies = [];
        var bText = data.toJson();
        var responseText = "status: ${response.statusCode}, body: $bText";
        return responseText;
      } catch (e) {
        return "error: $e, body: ${response.body}";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
