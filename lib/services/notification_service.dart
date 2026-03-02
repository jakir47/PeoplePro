import 'dart:convert';

import 'package:peoplepro/models/notificaiton_model.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static Future<List<NotificationModel>> getListAll() async {
    List<NotificationModel> results = [];

    try {
      var url = "${Settings.apiUrl}/notification/list/all";
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
        results = decodedText
            .map<NotificationModel>((json) => NotificationModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      //
    }

    return results;
  }

  static create(String title, String content) async {
    try {
      var url = "${Settings.apiUrl}/notification/create";
      var uri = Uri.parse(url);
      var bodyData = jsonEncode({
        'title': title,
        'content': content,
      });
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
}
