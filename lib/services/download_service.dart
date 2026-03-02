import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:peoplepro/utils/settings.dart';

class DownloadService {
  static Future<String?> downloadAttendanceCard(
      String empCode, String fromDate, String toDate, String fileName) async {
    final String pdfUrl =
        "${Settings.apiUrl}/report/job-card?empCode=$empCode&&fromDate=$fromDate&&toDate=$toDate";
    final response = await http.get(Uri.parse(pdfUrl));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.pdf';
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      return null;
    }
  }

  static Future<String?> downloadRegularization(
      String empCode, String json) async {
    final String pdfUrl =
        "${Settings.apiUrl}/report/regularization?empCode=$empCode&&lines=$json";
    final response = await http.get(Uri.parse(pdfUrl));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Regularization.pdf';
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      return null;
    }
  }
}
