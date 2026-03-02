import 'dart:convert';
import 'package:peoplepro/models/jobcard_model.dart';
import 'package:peoplepro/services/http.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  static Future<bool> takeAttendance(String address, double distance) async {
    var success = false;
    var fakeDate = DateTime.now().toString();
    var url =
        '${Http.api_url}services/erp_LeaveSystemService/createAttendLogMobile?employeeCode=${Session.empCode}&attendDate=$fakeDate&address=$address&distanceInMeters=$distance';

    print(url);

    final response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 204) {
      success = true;
    }
    return success;
  }

  static Future<DateTime?> take(
      String latLng, int zoneId, DateTime clientTime) async {
    try {
      var url = "${Settings.apiUrl}/attendance/take";
      var uri = Uri.parse(url);
      var bodyData = jsonEncode({
        'empCode': Session.empCode,
        'latLng': latLng,
        'zoneId': zoneId,
        'clientTime': clientTime.toIso8601String()
      });
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: bodyData);

      print(url);
      print(response.body);

      if (response.statusCode == 200) {
        var jsonTime = jsonDecode(response.body);
        var attendTime = DateTime.parse(jsonTime);
        return attendTime;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<JobCardModel>> getJobCard(
      String fromDate, String toDate) async {
    List<JobCardModel> jobCards = [];
    try {
      var url =
          "${Settings.apiUrl}/hive/user/jobcard?empId=${Session.empId}&fromDate=$fromDate&toDate=$toDate";
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
        jobCards = decodedText
            .map<JobCardModel>((json) => JobCardModel.fromJson(json))
            .toList();

        return jobCards;
      } else {
        return jobCards;
      }
    } catch (e) {
      return jobCards;
    }
  }
}
