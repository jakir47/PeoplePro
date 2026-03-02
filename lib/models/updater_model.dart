import 'package:version/version.dart';

class UpdaterModel {
  Version? version;
  String? releaseDate;
  String? releaseNote;
  bool? required;
  bool? isAvailable;

  UpdaterModel(
      {this.version,
      this.releaseDate,
      this.releaseNote,
      this.required,
      this.isAvailable});

  UpdaterModel.fromJson(Map<String, dynamic> json) {
    version = Version.parse(json['version']);
    releaseDate = json['releaseDate'];
    releaseNote = json['releaseNote'];
    required = json['required'] == "True";
    isAvailable = json['isAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    data['releaseDate'] = releaseDate;
    data['releaseNote'] = releaseNote;
    data['required'] = required;
    data['isAvailable'] = isAvailable;
    return data;
  }
}
