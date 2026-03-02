class PolicyModel {
  int? policyId;
  String? title;
  String? subtitle;
  String? content;

  PolicyModel({
    this.policyId,
    this.title,
    this.subtitle,
    this.content,
  });

  PolicyModel.fromJson(Map<String, dynamic> json) {
    policyId = json['policyId'];
    title = json['title'];
    subtitle = json['subtitle'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['policyId'] = policyId;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['content'] = content;

    return data;
  }
}
