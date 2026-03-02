class MealCountSummaryModel {
  String? title;
  int? mealCount;

  MealCountSummaryModel({
    this.title = '',
    this.mealCount = 0,
  });

  MealCountSummaryModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    mealCount = json['mealCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['mealCount'] = mealCount;

    return data;
  }
}
