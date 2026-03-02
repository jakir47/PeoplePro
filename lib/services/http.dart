class Http {
  static String api_url =
      "http://hris.bengalgroup.com:8080/inteaccERP/rest/v2/";
//  static String api_url = "http://43.224.118.54:8080/inteaccERP/rest/v2/";
  static String access_token = "";
  static Map<String, String> headers(bool useToken, bool useLogin) {
    if (useLogin) {
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic Y2xpZW50OnNlY3JldA=='
      };
      return headers;
    } else if (useToken) {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $access_token',
      };

      return headers;
    } else {
      var header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      return header;
    }
  }
}
