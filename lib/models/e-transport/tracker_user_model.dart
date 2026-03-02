class TrackerUserModel {
  String? username;
  String? name;
  String? designation;
  String? department;
  DateTime? activityTime;
  String? connectionId;
  bool? isTracker;

  TrackerUserModel(
      {this.username,
      this.name,
      this.designation,
      this.department,
      this.activityTime,
      this.connectionId,
      this.isTracker});

  TrackerUserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    designation = json['designation'];
    department = json['department'];
    activityTime = DateTime.parse(json['activityTime']);
    connectionId = json['connectionId'];
    isTracker = json['isTracker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['name'] = name;
    data['designation'] = designation;
    data['department'] = department;
    data['activityTime'] = activityTime;
    data['connectionId'] = connectionId;
    data['isTracker'] = isTracker;
    return data;
  }
}
