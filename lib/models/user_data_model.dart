import 'package:peoplepro/models/attendance_base_latlng_model.dart';
import 'package:peoplepro/models/attendance_zone_model.dart';
import 'package:peoplepro/models/birthday_model.dart';
import 'package:peoplepro/models/duration_model.dart';
import 'package:peoplepro/models/holiday_model.dart';
import 'package:peoplepro/models/notice_model.dart';
import 'package:peoplepro/models/policy_model.dart';
import 'package:peoplepro/models/popup_notification_model.dart';
import 'package:peoplepro/models/user_information_model.dart';

class UserDataModel {
  UserInformationModel? userInformation;
  List<AttendanceZoneModel>? attendanceZones;
  List<NoticeModel>? notices;
  List<HolidayModel>? holidays;
  List<PolicyModel>? policies;
  DateTime? serverToday;
  int? lastNotificationId;
  AttendanceBaseLatLng? attendanceBaseLatLng;
  PopupNotificationModel? popNotification;
  BirthdayModel? birthday;
  DurationModel? serviceDuration;
  int? approvalPendingCount;

  UserDataModel({
    this.userInformation,
    this.attendanceZones,
    this.notices,
    this.holidays,
    this.policies,
    this.serverToday,
    this.lastNotificationId = 0,
    this.attendanceBaseLatLng,
    this.popNotification,
    this.birthday,
    this.serviceDuration,
    this.approvalPendingCount = 0,
  });

  UserDataModel.fromJson(Map<String, dynamic> json) {
    userInformation = json['userInformation'] != null
        ? UserInformationModel.fromJson(json['userInformation'])
        : null;

    if (json['attendanceZones'] != null) {
      attendanceZones = <AttendanceZoneModel>[];
      json['attendanceZones'].forEach((v) {
        attendanceZones!.add(AttendanceZoneModel.fromJson(v));
      });
    }

    if (json['notices'] != null) {
      notices = <NoticeModel>[];
      json['notices'].forEach((v) {
        notices!.add(NoticeModel.fromJson(v));
      });
    }

    if (json['holidays'] != null) {
      holidays = <HolidayModel>[];
      json['holidays'].forEach((v) {
        holidays!.add(HolidayModel.fromJson(v));
      });
    }

    if (json['policies'] != null) {
      policies = <PolicyModel>[];
      json['policies'].forEach((v) {
        policies!.add(PolicyModel.fromJson(v));
      });
    }

    serverToday = DateTime.parse(json['serverToday']);
    lastNotificationId = int.parse(json['lastNotificationId'].toString());
    approvalPendingCount = int.parse(json['approvalPendingCount'].toString());
    attendanceBaseLatLng = json['attendanceBaseLatLng'] != null
        ? AttendanceBaseLatLng.fromJson(json['attendanceBaseLatLng'])
        : AttendanceBaseLatLng(latitude: 0, longitude: 0);

    popNotification = json['popNotification'] != null
        ? PopupNotificationModel.fromJson(json['popNotification'])
        : PopupNotificationModel(notificationId: 0);

    birthday = json['birthday'] != null
        ? BirthdayModel.fromJson(json['birthday'])
        : BirthdayModel(year: 0, month: 0, day: 0, isBirthdayToday: false);

    serviceDuration = json['serviceDuration'] != null
        ? DurationModel.fromJson(json['serviceDuration'])
        : DurationModel(year: 0, month: 0, day: 0, isOneYearToday: false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userInformation != null) {
      data['userInformation'] = userInformation!.toJson();
    }
    if (attendanceZones != null) {
      data['attendanceZones'] =
          attendanceZones!.map((v) => v.toJson()).toList();
    }
    if (notices != null) {
      data['notices'] = notices!.map((v) => v.toJson()).toList();
    }
    if (holidays != null) {
      data['holidays'] = holidays!.map((v) => v.toJson()).toList();
    }
    if (policies != null) {
      data['policies'] = policies!.map((v) => v.toJson()).toList();
    }
    data['serverToday'] = serverToday;
    data['lastNotificationId'] = lastNotificationId;
    data['approvalPendingCount'] = approvalPendingCount;
    if (attendanceBaseLatLng != null) {
      data['attendanceBaseLatLng'] = attendanceBaseLatLng!.toJson();
    }
    if (popNotification != null) {
      data['popNotification'] = popNotification!.toJson();
    }

    if (birthday != null) {
      data['birthday'] = birthday!.toJson();
    }

    if (serviceDuration != null) {
      data['serviceDuration'] = serviceDuration!.toJson();
    }
    return data;
  }
}
