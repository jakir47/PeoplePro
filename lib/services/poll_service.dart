import 'dart:convert';

import 'package:peoplepro/models/poll_data_model.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:http/http.dart' as http;

class PollService {
  static Future<PollDataModel?> getPoll() async {
    try {
      var url = "${Settings.apiUrl}/hive/poll?empCode=${Session.empCode}";

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
        var jsonText = json.decode(response.body);

        var data = PollDataModel.fromJson(jsonText);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> submit(int pollLineId) async {
    try {
      var url =
          "${Settings.apiUrl}/hive/poll/submit?empCode=${Session.empCode}&&pollLineId=$pollLineId";
      var uri = Uri.parse(url);
      final response = await http.post(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ApiKey': Settings.apiKey,
      });
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
