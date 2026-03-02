class AdminFactoryGuestTokenModel {
  int tokenId;
  String tokenNo;
  String requestedAt;
  String factoryGuestId;

  AdminFactoryGuestTokenModel({
    required this.tokenId,
    required this.tokenNo,
    required this.requestedAt,
    required this.factoryGuestId,
  });

  factory AdminFactoryGuestTokenModel.fromJson(Map<String, dynamic> json) {
    return AdminFactoryGuestTokenModel(
      tokenId: json['tokenId'],
      tokenNo: json['tokenNo'],
      requestedAt: json['requestedAt'],
      factoryGuestId: json['factoryGuestId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokenId': tokenId,
      'tokenNo': tokenNo,
      'requestedAt': requestedAt,
      'factoryGuestId': factoryGuestId,
    };
  }
}
