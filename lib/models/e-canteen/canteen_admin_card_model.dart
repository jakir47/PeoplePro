class CanteenAdminCardModel {
  String? cardId;
  String? description;
  int? total;

  CanteenAdminCardModel({
    this.cardId = '',
    this.description = '',
    this.total = 0,
  });

  CanteenAdminCardModel.fromJson(Map<String, dynamic> json) {
    cardId = json['cardId'];
    description = json['description'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cardId'] = cardId;
    data['description'] = description;
    data['total'] = total;
    return data;
  }
}
