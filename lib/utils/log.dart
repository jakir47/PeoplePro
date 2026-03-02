import 'package:peoplepro/dtos/log_dto.dart';
import 'package:peoplepro/services/security_service.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Log {
  static void createLogin() {
    var log = LogDto();
    log.userId = Session.empCode;
    log.logText = "Logged in.";
    log.logData = Settings.deviceId;
    log.logTypeId = "1";
    SecurityService.createLog(log);
  }

  static void createLogout() {
    var log = LogDto();
    log.userId = Session.empCode;
    log.logText = "Logged out.";
    log.logData = Settings.deviceId;
    log.logTypeId = "1";
    SecurityService.createLog(log);
  }

  static Future<bool> createMock(LatLng latLng) async {
    var log = LogDto();
    log.userId = Session.empCode;
    log.logText = "Trying to access from device [${Settings.deviceId}].";
    log.logData = "${latLng.latitude},${latLng.longitude}";
    log.logTypeId = "2";
    var created = await SecurityService.createLog(log);
    return created;
  }

  static Future<bool> create(String logText, String logData) async {
    var log = LogDto();
    log.userId = Session.empCode;
    log.logText = logText;
    log.logData = logData;
    log.logTypeId = "3";
    var created = await SecurityService.createLog(log);
    return created;
  }

  static void createDeviceActivation() {
    var log = LogDto();
    log.userId = Session.empCode;
    log.logText = "Device activation request from [${Session.empCode}].";
    log.logData = Settings.deviceId;
    log.logTypeId = "3";
    SecurityService.createLog(log);
  }
}
