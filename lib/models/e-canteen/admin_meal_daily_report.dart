import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peoplepro/models/e-canteen/meal_daily_summary_model.dart';
import 'package:peoplepro/services/canteen_service.dart';

class AdminMealDailyReport extends StatefulWidget {
  const AdminMealDailyReport({super.key});

  @override
  AdminMealDailyReportState createState() => AdminMealDailyReportState();
}

class AdminMealDailyReportState extends State<AdminMealDailyReport> {
  DateTime selectedDate = DateTime.now();
  List<MealDailySummaryModel> mealReportList = [];
  bool isLoading = false;
  String? errorMessage;

  // Load daily report
  Future<void> loadDailyReport(DateTime reportDate) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await CanteenService.getAdminDailyReport(reportDate);
      setState(() {
        mealReportList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load data. Please try again.";
        isLoading = false;
      });
    }
  }

  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      await loadDailyReport(pickedDate);
    }
  }

  @override
  void initState() {
    super.initState();
    loadDailyReport(selectedDate);
  }

  // Group data by Unit and calculate totals
  Map<String, Map<String, dynamic>> _groupByUnit() {
    Map<String, Map<String, dynamic>> groupedData = {};
    for (var meal in mealReportList) {
      if (!groupedData.containsKey(meal.unit)) {
        groupedData[meal.unit!] = {
          'meals': <MealDailySummaryModel>[],
          'totalMeals': 0,
          'totalPresent': 0,
          'totalClosed': 0,
          'totalAbsent': 0,
        };
      }
      groupedData[meal.unit]!['meals'].add(meal);
      groupedData[meal.unit]!['totalMeals'] += meal.totalMeal ?? 0;
      if (meal.statusText == 'P') {
        groupedData[meal.unit]!['totalPresent'] += 1;
      } else if (meal.statusText == 'C') {
        groupedData[meal.unit]!['totalClosed'] += 1;
      } else if (meal.statusText == 'A') {
        groupedData[meal.unit]!['totalAbsent'] += 1;
      }
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = _groupByUnit();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Canteen Meal Daily Report"),
      ),
      body: Column(
        children: [
          // Date Picker Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text("Pick Date"),
                ),
              ],
            ),
          ),

          // Show loading indicator or error message
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage != null)
            Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          else if (mealReportList.isEmpty)
            const Center(
              child: Text(
                "No data available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          else
            // Display the meal report list grouped by Unit
            Expanded(
              child: ListView(
                children: groupedData.entries.map((entry) {
                  final unit = entry.key;
                  final data = entry.value;
                  final meals = data['meals']
                      as List<MealDailySummaryModel>; // Explicit cast
                  final totalMeals = data['totalMeals'] as int;
                  final totalPresent = data['totalPresent'] as int;
                  final totalClosed = data['totalClosed'] as int;
                  final totalAbsent = data['totalAbsent'] as int;

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        "Unit: $unit",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Meals: $totalMeals"),
                          Text("Present: $totalPresent"),
                          Text("Closed: $totalClosed"),
                          Text("Absent: $totalAbsent"),
                        ],
                      ),
                      children: meals.map((meal) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Employee ID and Name
                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      size: 20, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${meal.empId} - ${meal.name}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Employee Meals
                              _buildMealInfoRow("Employee Meals",
                                  meal.empMeal.toString(), Icons.fastfood),

                              // Guest Meals
                              _buildMealInfoRow("Guest Meals",
                                  meal.guestMeal.toString(), Icons.people),

                              // Driver Meals
                              _buildMealInfoRow(
                                  "Driver Meals",
                                  meal.driverMeal.toString(),
                                  Icons.directions_car),

                              // Total Meals
                              _buildMealInfoRow("Total Meals",
                                  meal.totalMeal.toString(), Icons.calculate),

                              // Status
                              Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    size: 20,
                                    color: _getStatusColor(meal.statusText),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Status: ${_getStatusText(meal.statusText)}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _getStatusColor(meal.statusText),
                                    ),
                                  ),
                                ],
                              ),

                              // Meal Closed Status
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    meal.isMealClosed!
                                        ? Icons.lock
                                        : Icons.lock_open,
                                    color: meal.isMealClosed!
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    meal.isMealClosed! ? "Closed" : "Open",
                                    style: TextStyle(
                                      color: meal.isMealClosed!
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build meal info rows
  Widget _buildMealInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Helper method to get status text
  String _getStatusText(String? statusText) {
    switch (statusText) {
      case 'A':
        return 'Absent';
      case 'C':
        return 'Closed';
      case 'P':
        return 'Present';
      default:
        return 'Unknown';
    }
  }

  // Helper method to get status color
  Color _getStatusColor(String? statusText) {
    switch (statusText) {
      case 'A':
        return Colors.red;
      case 'C':
        return Colors.orange;
      case 'P':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
