import 'dart:convert';
import 'package:peoplepro/dtos/profile_update_dto.dart';
import 'package:peoplepro/models/approval_task_line_model.dart';
import 'package:peoplepro/models/attendance_location_model.dart';
import 'package:peoplepro/models/attendance_zone_model.dart';
import 'package:peoplepro/models/employee_profile_model.dart';
import 'package:peoplepro/models/payslip_line_model.dart';
import 'package:peoplepro/models/payslip_model.dart';
import 'package:peoplepro/models/provident_fund_model.dart';
import 'package:peoplepro/models/user_app_updated_model.dart';
import 'package:peoplepro/models/user_auth_model.dart';
import 'package:peoplepro/models/user_data_model.dart';
import 'package:peoplepro/services/http.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<UserAuthModel> login(String userId, String password) async {
    try {
      var url = "${Settings.apiUrl}/security/user/login";
      print(url);

      var uri = Uri.parse(url);
      var bodyData = jsonEncode({
        'userId': userId,
        'password': password,
        'version': Settings.appVersion,
        'deviceId': Settings.deviceId
      });

      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ApiKey': Settings.apiKey,
          },
          body: bodyData);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var data = UserAuthModel.fromJson(json);
        data.success = true;
        data.message = "Success";
        return data;
      } else {
        return UserAuthModel(
            success: false,
            message: "Invalid user ID or password (${response.statusCode})");
      }
    } catch (e) {
      return UserAuthModel(
          success: false, message: "Exception: ${e.toString()}");
    }
  }

  static Future<UserDataModel?> getUserData(String empCode) async {
    try {
      var url = "${Settings.apiUrl}/hive/user/data?empCode=$empCode";

      var uri = Uri.parse(url);
      final response = await http.get(uri, headers: Http.headers(true, false));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        var data = UserDataModel.fromJson(json);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<PayslipModel>> getPayslips() async {
    List<PayslipModel> payslips = [];
    try {
      var url = "${Settings.apiUrl}/hive/user/payslips?empId=${Session.empId}";
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
        payslips = decodedText
            .map<PayslipModel>((json) => PayslipModel.fromJson(json))
            .toList();

        return payslips;
      } else {
        return payslips;
      }
    } catch (e) {
      return payslips;
    }
  }

  static Future<List<ApprovalTaskLineModel>> getPendingApprovals() async {
    List<ApprovalTaskLineModel> approvals = [];
    try {
      var url =
          "${Settings.apiUrl}/hive/user/pending/approvals?empCode=${Session.empCode}";
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

        approvals = decodedText
            .map<ApprovalTaskLineModel>(
                (json) => ApprovalTaskLineModel.fromJson(json))
            .toList();

        return approvals;
      } else {
        return approvals;
      }
    } catch (e) {
      return approvals;
    }
  }

  static Future<List<ProvidentFundModel>> getProvidentFunds() async {
    List<ProvidentFundModel> providentFunds = [];
    try {
      var url = "${Settings.apiUrl}/hive/user/pf?empId=${Session.empId}";
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
        providentFunds = decodedText
            .map<ProvidentFundModel>(
                (json) => ProvidentFundModel.fromJson(json))
            .toList();

        return providentFunds;
      } else {
        return providentFunds;
      }
    } catch (e) {
      return providentFunds;
    }
  }

  static Future<List<PayslipLineModel>> getPayslipLine(String payrollId) async {
    List<PayslipLineModel> lines = [];
    try {
      var url =
          "${Settings.apiUrl}/hive/user/payslip/lines?payrollId=$payrollId";
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
            .map<PayslipLineModel>((json) => PayslipLineModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }

  static Future<bool> updateProfile(ProfileUpdateDto data) async {
    try {
      var url = "${Settings.apiUrl}/hive/user/profile/update";
      var uri = Uri.parse(url);
      print(uri);
      var bodyData = jsonEncode(data);
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

  static Future<EmployeeProfileModel?> getProfile() async {
    try {
      var url =
          "${Settings.apiUrl}/hive/user/profile?empCode=${Session.empCode}";
      var uri = Uri.parse(url);
      final response = await http.get(uri, headers: Http.headers(true, false));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        var data = EmployeeProfileModel.fromJson(json);

        print(json);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<AttendanceLocationModel>> getAttendanceLocations() async {
    List<AttendanceLocationModel> lines = [];
    try {
      var url = "${Settings.apiUrl}/hive/user/attendance/locations";
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
            .map<AttendanceLocationModel>(
                (json) => AttendanceLocationModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }

  static Future<List<AttendanceZoneModel>> getAttendanceZones(
      String attendanceLocationId) async {
    List<AttendanceZoneModel> lines = [];
    try {
      var url =
          "${Settings.apiUrl}/hive/user/attendance/zones?attendanceLocationId=$attendanceLocationId";

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
            .map<AttendanceZoneModel>(
                (json) => AttendanceZoneModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }

  static Future<bool> saveAttendanceZone(List<AttendanceZoneModel> data) async {
    try {
      var url = "${Settings.apiUrl}/hive/user/attendance/zone/save";
      var uri = Uri.parse(url);
      var bodyData = jsonEncode(data);
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

  static Future<bool> updateAttendanceLocation(
      String empCode, String? attendanceLocationId) async {
    try {
      var url =
          "${Settings.apiUrl}/hive/user/attendance/location/update?empCode=$empCode&attendanceLocationId=$attendanceLocationId";
      var uri = Uri.parse(url);

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ApiKey': Settings.apiKey,
        },
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> changePassword(String empCode, String password) async {
    try {
      var url = "${Settings.apiUrl}/hive/user/password/change";
      var uri = Uri.parse(url);
      var bodyData = jsonEncode({"empCode": empCode, "password": password});
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

  static Future<List<UserAppUpdatedModel>> getUserAppUpdated() async {
    List<UserAppUpdatedModel> lines = [];
    try {
      var url = "${Settings.apiUrl}/hive/user/updated";
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
            .map<UserAppUpdatedModel>(
                (json) => UserAppUpdatedModel.fromJson(json))
            .toList();

        return lines;
      } else {
        return lines;
      }
    } catch (e) {
      return lines;
    }
  }
}
