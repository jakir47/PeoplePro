import 'dart:convert';
import 'package:peoplepro/models/updater_model.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:http/http.dart' as http;

class UpdateService {
  static Future<UpdaterModel?> check() async {
    try {
      var url = "${Settings.apiUrl}/update/check";

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
        var update = UpdaterModel.fromJson(json);

        return update;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
