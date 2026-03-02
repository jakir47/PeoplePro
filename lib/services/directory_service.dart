import 'dart:convert';

import 'package:peoplepro/models/employee_directory_model.dart';
import 'package:peoplepro/models/search_option_model.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:http/http.dart' as http;

class DirectoryService {
  static Future<List<EmployeeDirectoryModel>> search(
      String searchText, String searchType, int offset) async {
    List<EmployeeDirectoryModel> results = [];
    try {
      var bodyData = jsonEncode({
        'searchText': searchText,
        'searchType': searchType,
        'offset': offset,
      });
      var url = "${Settings.apiUrl}/directory/search";
      var uri = Uri.parse(url);
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ApiKey': Settings.apiKey,
          },
          body: bodyData);

      if (response.statusCode == 200) {
        var decodedText =
            json.decode(response.body).cast<Map<String, dynamic>>();
        results = decodedText
            .map<EmployeeDirectoryModel>(
                (json) => EmployeeDirectoryModel.fromJson(json))
            .toList();

        return results;
      } else {
        return results;
      }
    } catch (e) {
      return results;
    }
  }

  static Future<SearchOptionModel> getOption() async {
    SearchOptionModel options = SearchOptionModel();

    try {
      var url = "${Settings.apiUrl}/directory/options";

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

        print(jsonText);
        options = SearchOptionModel.fromJson(jsonText);

        return options;
      } else {
        return options;
      }
    } catch (e) {
      return options;
    }
  }
}
