import 'package:http/http.dart' as http;
import 'package:peoplepro/services/canteen_service2.dart';

class ApiUrl {
  static Future<bool> _isIpOnline(String ipUrl) async {
    try {
      final response =
          await http.get(Uri.parse(ipUrl)).timeout(const Duration(seconds: 1));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<String> _getApiUrl(
      List<String> urls, String fallbackUrl) async {
    for (String url in urls) {
      var isOnline = await _isIpOnline("$url/hive");
      if (isOnline) {
        return url;
      }
    }
    return fallbackUrl;
  }

  static Future<String> getApiUrl() async {
    List<String> urls = [
      //  "http://10.0.3.2:4005/api/v1", // Geny Motion (Emulator)
      "http://182.163.117.78:4005/api/v1", // BOL
      "http://43.224.118.50:4005/api/v1", // Next Online
      "http://bgi.com.bd:4005/api/v1" // Cloudflare
    ];

    String fallbackUrl = "http://172.16.18.59:4005/api/v1"; // Local

    var apiUrl = await _getApiUrl(urls, fallbackUrl);

    return apiUrl;
  }
}
