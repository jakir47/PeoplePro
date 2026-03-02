class BusModel {
  String busId;
  String route;
  String driver;
  String mobile;

  BusModel(
      {this.busId = "bus1",
      this.route = "Mohammadpur",
      this.driver = "Driver 1",
      this.mobile = "01710123456"});

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      busId: json["busId"],
      route: json["route"],
      driver: json["driver"],
      mobile: json["mobile"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "busId": busId,
      "route": route,
      "driver": driver,
      "mobile": mobile,
    };
  }
}
