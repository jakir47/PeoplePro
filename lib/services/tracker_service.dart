import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peoplepro/models/e-transport/location_model.dart';
import 'package:peoplepro/models/e-transport/locator_model.dart';
import 'package:peoplepro/models/e-transport/position_model.dart';

class TrackerServcie {
  static Future<bool> updateLocation(int busId, double latitude,
      double longitude, double heading, String speed, String empCode) async {
    const url = 'http://202.84.46.93:2010/api/v1/tracker/update';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var data = {
      'busId': busId,
      'latitude': latitude,
      'longitude': longitude,
      'heading': heading,
      'speed': speed,
      'empCode': empCode,
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: headers);
    return response.statusCode == 200;
  }

  static Future<LocationModel> getLocation(int busId) async {
    var url = Uri.parse(
        'http://202.84.46.93:2010/api/v1/tracker/location?busId=$busId');

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.get(url, headers: headers);
    var json = jsonDecode(response.body);
    var data = LocationModel.fromJson(json);
    return data;
  }

  static Future<List<LocatorModel>> getLocators(int busId) async {
    var url = Uri.parse(
        'http://202.84.46.93:2010/api/v1/tracker/locators?busId=$busId');

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.get(url, headers: headers);
    var data = parseLocators(response.body);
    return data;
  }

  static Future<List<PositionModel>> getRoadCoordinates(int busId) async {
    var url = Uri.parse(
        'http://202.84.46.93:2010/api/v1/tracker/road/coordinates?busId=$busId');

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.get(url, headers: headers);
    var data = parseRoadCoordinates(response.body);
    return data;
  }

  static List<LocatorModel> parseLocators(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<LocatorModel>((json) => LocatorModel.fromJson(json))
        .toList();
  }

  static List<PositionModel> parseRoadCoordinates(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<PositionModel>((json) => PositionModel.fromJson(json))
        .toList();
  }

  static Future<bool> sendOwnLocation(
      int busId, double latitude, double longitude, String empCode) async {
    const url = 'http://202.84.46.93:2010/api/v1/tracker/update/own';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var data = {
      'busId': busId,
      'latitude': latitude,
      'longitude': longitude,
      'empCode': empCode,
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: headers);
    return response.statusCode == 200;
  }

  static Future<bool> resetLocation(int busId) async {
    const url = 'http://202.84.46.93:2010/api/v1/tracker/location/reset';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var data = {
      'busId': busId,
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: headers);
    return response.statusCode == 200;
  }

  static Future<bool> resetLocationOwn(int busId) async {
    const url = 'http://202.84.46.93:2010/api/v1/tracker/location/own/reset';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var data = {
      'busId': busId,
    };
    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: headers);
    return response.statusCode == 200;
  }

  static Future<bool> createPlace(String latitude, String longitude,
      String name, int busId, bool notification) async {
    const url = 'http://202.84.46.93:2010/api/v1/tracker/place/create';

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var data = {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'busId': busId,
      'notification': notification,
    };

    var response = await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: headers);
    return response.statusCode == 200;
  }
}
