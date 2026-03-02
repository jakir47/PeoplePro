import 'package:peoplepro/models/user_access_model.dart';

class Settings {
  static String apiUrl = "";
  static String apiKey = "985a741bc666da9f6f5f0f1ea3cb39f6"; // Login only

  static String jwtToken = ""; // All request.
  static DateTime serverToday = DateTime.now();

  static String appVersion = "0.0.0";
  static String deviceStatus = "none";
  static String deviceId = "none";
  static String brand = "none";

  static String model = "none";
  static String osVersion = "none";
  static String architecture = "none";
  static String manufacturer = "none";
  static String supportedAbis = "none";
  static String tags = "none";
  static int sdk = 0;
  static bool isPhysicalDevice = false;
  static bool isActivated = false;
  static int serviceDays = 0;

  static bool isEarnLeaveApplicable = false;
  static int popupNotificationId = 0;
  static String popupNotificationImageUrl = "";
  static DateTime? lastSuccessAttendanceAt;
  static DateTime shiftStartTime = DateTime.now();
  static DateTime shiftEndTime = DateTime.now();
  static bool isConfettiBlast = false;
  static String edition = "";
  static int editionId = 0;
  static UserAccessModel userAccess = UserAccessModel();
  static DateTime eDirectoryLastUpdated = DateTime.now();
  static String eAttendanceMonitor = "1.0.1";
  static String eDirectoryVersion = "1.5.0";
  static String ePollVersion = "1.1.0";
  static String eCanteen = "2.0.1";
  static String eTransport = "1.0.1";

  static bool debug = false;
}
