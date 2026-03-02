import 'package:peoplepro/models/e-canteen/meal_closing_model.dart';
import 'package:peoplepro/models/user_data_model.dart';
import 'package:flutter/services.dart';

class Session {
  static UserDataModel userData = UserDataModel();
  static Uint8List empImage = Uint8List(0);
  static String empId = "";
  static String empCode = "";
  static String empName = "";
  static String designation = "";
  static String department = "";
  static String operatingLocation = "";
  static List<MealClosingModel> mealClosings = [];
  static int approvalPendingCount = 0;
}
