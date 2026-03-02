import 'dart:convert';

import 'package:peoplepro/models/leave_application_model.dart';
import 'package:peoplepro/models/leave_approval_model.dart';
import 'package:peoplepro/models/outstation_duty_model.dart';
import 'package:peoplepro/models/outstation_model.dart';
import 'package:peoplepro/models/WorkflowTaskLine.dart';
import 'package:peoplepro/models/leave_balance_model.dart';
import 'package:peoplepro/services/http.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';

import 'package:http/http.dart' as http;

class LeaveService {
  static Future<List<LeaveApplicationModel>> getLeaveApplications() async {
    List<LeaveApplicationModel> leaves = [];
    var url =
        "${Settings.apiUrl}/hive/user/leave/applications?empId=${Session.empId}";

    var response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 200) {
      var decodedText = json.decode(response.body).cast<Map<String, dynamic>>();
      leaves = decodedText
          .map<LeaveApplicationModel>(
              (json) => LeaveApplicationModel.fromJson(json))
          .toList();
    }

    return leaves;
  }

  static Future<List<LeaveApprovalModel>> getLeaveApprovals(
      String docNumber) async {
    List<LeaveApprovalModel> approvals = [];
    var url =
        "${Settings.apiUrl}/hive/user/leave/approvals?empId=${Session.empId}&docNumber=$docNumber";

    var response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 200) {
      var decodedText = json.decode(response.body).cast<Map<String, dynamic>>();
      approvals = decodedText
          .map<LeaveApprovalModel>((json) => LeaveApprovalModel.fromJson(json))
          .toList();
    }

    return approvals;
  }

  static Future<List<OutstationDuty>> getLeaveOutstations() async {
    List<OutstationDuty> leaveApplications = [];

    var url =
        '${Http.api_url}queries/erp_OutstationDuty/getOutstationDutyListFromEmployeeId?employeeId=${Session.empId}';

    var response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 200) {
      leaveApplications = outstationDutyFromJson(response.body);
    }

    return leaveApplications;
  }

  static Future<List<WorkflowTaskLine>> getWorkflowTaskList() async {
    List<WorkflowTaskLine> tasks = [];

    var url =
        '${Http.api_url}queries/erp_WorkflowTaskLine/getWorkflowTaskListFromUser?userLogin=${Session.empCode}';

    print(url);
    var response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));
    print(response.body);

    if (response.statusCode == 200) {
      tasks = workflowTaskLineFromJson(response.body);
    }
    return tasks;
  }

  static Future<List<LeaveBalanaceModel>> getLeaveBalanceList() async {
    List<LeaveBalanaceModel> leaveBalanceList = [];

    var url =
        '${Http.api_url}queries/erp\$LeaveBalance/getLeaveBalanceListFromEmployeeId?employeeId=${Session.empId}';

    var response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 200) {
      var decodedText = json.decode(response.body).cast<Map<String, dynamic>>();
      leaveBalanceList = decodedText
          .map<LeaveBalanaceModel>((json) => LeaveBalanaceModel.fromJson(json))
          .toList();
    }
    return leaveBalanceList;
  }

  static Future<bool> approveWorkflowTaskItem(String workflowTaskNumber) async {
    var success = false;
    var url =
        '${Http.api_url}services/erp_WorkflowService/approveTask?workflowTaskNumber=$workflowTaskNumber';
    final response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 204) {
      success = true;
    }
    return success;
  }

  static Future<bool> rejectWorkflowTaskItem(String workflowTaskNumber) async {
    var success = false;
    var url =
        '${Http.api_url}services/erp_WorkflowService/declineTaskApproval?workflowTaskNumber=$workflowTaskNumber';
    final response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 204) {
      success = true;
    }
    return success;
  }

  static Future<bool> takeAttendance(String address, double distance) async {
    var success = false;
    var fakeDate = DateTime.now().toString();
    var url =
        '${Http.api_url}services/erp_LeaveSystemService/createAttendLogMobile?employeeCode=${Session.empCode}&attendDate=$fakeDate&address=$address&distanceInMeters=$distance';

    final response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 204) {
      success = true;
    }
    return success;
  }

  static Future<bool> createLeaveApplication(
      String leaveTypeCode,
      String dateFrom,
      String dateTo,
      String durType,
      String note,
      String base64Image,
      bool sendDocToHR,
      String docSentToHrDate) async {
    var success = false;
    var url =
        '${Http.api_url}services/erp_LeaveSystemService/createLeaveApplication?employeeCode=${Session.empCode}&leaveTypeCode=$leaveTypeCode&startDate=$dateFrom&endDate=$dateTo&durType=$durType&note=$note&imageAttach=$base64Image&isDocSentToHr=$sendDocToHR&docSentToHrDate=$docSentToHrDate';

    final response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 204) {
      success = true;
    }
    return success;
  }

  static Future<bool> createOutstation(String dateFrom, String dateTo,
      String durType, String purpose, String location) async {
    var success = false;
    var url =
        '${Http.api_url}services/erp_LeaveSystemService/createOutstationDuty?employeeCode=${Session.empCode}&startDate=$dateFrom&endDate=$dateTo&durType=$durType&purpose=$purpose&location=$location';

    final response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 204) {
      success = true;
    }
    return success;
  }

  static Future<List<OutstationDutyModel>> getOutstationDuties() async {
    List<OutstationDutyModel> leaves = [];
    var url =
        "${Settings.apiUrl}/hive/user/outstation/duties?empId=${Session.empId}";

    var response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 200) {
      var decodedText = json.decode(response.body).cast<Map<String, dynamic>>();
      leaves = decodedText
          .map<OutstationDutyModel>(
              (json) => OutstationDutyModel.fromJson(json))
          .toList();
    }

    return leaves;
  }

  static Future<List<LeaveApprovalModel>> getOutstationApprovals(
      String docNumber) async {
    List<LeaveApprovalModel> approvals = [];
    var url =
        "${Settings.apiUrl}/hive/user/outstation/approvals?empId=${Session.empId}&docNumber=$docNumber";

    var response =
        await http.get(Uri.parse(url), headers: Http.headers(true, false));

    if (response.statusCode == 200) {
      var decodedText = json.decode(response.body).cast<Map<String, dynamic>>();
      approvals = decodedText
          .map<LeaveApprovalModel>((json) => LeaveApprovalModel.fromJson(json))
          .toList();
    }

    return approvals;
  }
}
