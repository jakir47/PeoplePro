import 'dart:convert';

import 'package:peoplepro/models/bus_employee_model.dart';
import 'package:peoplepro/models/department_model.dart';
import 'package:peoplepro/models/edition_model.dart';
import 'package:peoplepro/models/employee_attendance_model.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:http/http.dart' as http;

class HiveService {
  static Future<List<DepartmentModel>> getdepartments() async {
    List<DepartmentModel> departments = [];
    try {
      var url = "${Settings.apiUrl}/hive/departments";
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
        departments = decodedText
            .map<DepartmentModel>((json) => DepartmentModel.fromJson(json))
            .toList();

        return departments;
      } else {
        return departments;
      }
    } catch (e) {
      return departments;
    }
  }

  static Future<List<EditionModel>> getEditions() async {
    List<EditionModel> editions = [];
    try {
      var url = "${Settings.apiUrl}/hive/user/editions";
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
        editions = decodedText
            .map<EditionModel>((json) => EditionModel.fromJson(json))
            .toList();

        return editions;
      } else {
        return editions;
      }
    } catch (e) {
      return editions;
    }
  }

  static Future<List<EmployeeAttendanceModel>> getEmployeeAttendances(
      String departmentId, String entryDate) async {
    List<EmployeeAttendanceModel> attendances = [];
    try {
      var url =
          "${Settings.apiUrl}/hive/employee/attendances?departmentId=$departmentId&entryDate=$entryDate";

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
        attendances = decodedText
            .map<EmployeeAttendanceModel>(
                (json) => EmployeeAttendanceModel.fromJson(json))
            .toList();

        return attendances;
      } else {
        return attendances;
      }
    } catch (e) {
      return attendances;
    }
  }

  static Future<bool> clearCache(String type, String? empCode) async {
    try {
      var url =
          "${Settings.apiUrl}/hive/cache/clear?key=$type&empCode=$empCode";
      var uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
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

  static Future<DateTime?> take(
      String empCode, String latLng, int zoneId, DateTime clientTime) async {
    try {
      var url = "${Settings.apiUrl}/attendance/take";
      var uri = Uri.parse(url);
      var bodyData = jsonEncode({
        'empCode': empCode,
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

  static Future<List<BusEmployeeModel>> getBusEmployees() async {
    List<BusEmployeeModel> employees = [];
    try {
      var url = "${Settings.apiUrl}/hive/bus/employees";

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
        employees = decodedText
            .map<BusEmployeeModel>((json) => BusEmployeeModel.fromJson(json))
            .toList();

        return employees;
      } else {
        return employees;
      }
    } catch (e) {
      return employees;
    }
  }
}
