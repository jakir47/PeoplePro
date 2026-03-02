class TrackerDataModel {
  String? empCode;
  String? name;
  double? latitude;
  double? longitude;
  int? editionId;
  String? designation;
  String? trackerId;
  bool? isTracker;
  double? heading;
  String? image;

  TrackerDataModel(
      {this.empCode,
      this.name,
      this.latitude,
      this.longitude,
      this.editionId,
      this.designation,
      this.trackerId,
      this.isTracker,
      this.heading,
      this.image});

  TrackerDataModel.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    editionId = json['editionId'];
    designation = json['designation'];
    trackerId = json['trackerId'];
    isTracker = json['isTracker'];
    heading = json['heading'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['editionId'] = editionId;
    data['designation'] = designation;
    data['trackerId'] = trackerId;
    data['isTracker'] = isTracker;
    data['heading'] = heading;
    data['image'] = image;
    return data;
  }
}
