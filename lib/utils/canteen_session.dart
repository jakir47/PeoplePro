class CanteenSession {
  static String username = "";
  static String password = "";
  static String jwtToken = "";
  static bool isMealClosedToday = false;

  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (CanteenSession.jwtToken.isNotEmpty)
        'Authorization': 'Bearer ${CanteenSession.jwtToken}',
    };
  }
}
