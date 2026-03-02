class EditionModel {
  int? editionId;
  String? name;

  EditionModel({
    this.editionId,
    this.name,
  });

  EditionModel.fromJson(Map<String, dynamic> json) {
    editionId = json['editionId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['editionId'] = editionId;
    data['name'] = name;

    return data;
  }
}
