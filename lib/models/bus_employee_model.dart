import 'package:flutter/animation.dart';

class BusEmployeeModel {
  String empCode;
  String name;
  String designation;
  String department;
  Color? color;

  BusEmployeeModel(
      {required this.empCode,
      required this.name,
      required this.designation,
      required this.department,
      this.color});

  factory BusEmployeeModel.fromJson(Map<String, dynamic> json) {
    return BusEmployeeModel(
      empCode: json['empCode'],
      name: json['name'],
      designation: json['designation'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['name'] = name;
    data['designation'] = designation;
    data['department'] = department;
    return data;
  }
}
