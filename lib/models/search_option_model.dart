class SearchOptionModel {
  List<OptionModel>? companies;
  List<OptionModel>? departments;
  List<OptionModel>? designations;
  List<OptionModel>? locations;
  List<OptionModel>? bloodGroups;
  List<OptionModel>? genders;
  List<OptionModel>? religions;

  SearchOptionModel({
    this.companies,
    this.departments,
    this.designations,
    this.locations,
    this.bloodGroups,
    this.genders,
    this.religions,
  });

  SearchOptionModel.fromJson(Map<String, dynamic> json) {
    if (json['companies'] != null) {
      companies = <OptionModel>[];
      json['companies'].forEach((v) {
        companies!.add(OptionModel.fromJson(v));
      });
    }
    if (json['departments'] != null) {
      departments = <OptionModel>[];
      json['departments'].forEach((v) {
        departments!.add(OptionModel.fromJson(v));
      });
    }
    if (json['designations'] != null) {
      designations = <OptionModel>[];
      json['designations'].forEach((v) {
        designations!.add(OptionModel.fromJson(v));
      });
    }
    if (json['locations'] != null) {
      locations = <OptionModel>[];
      json['locations'].forEach((v) {
        locations!.add(OptionModel.fromJson(v));
      });
    }
    if (json['bloodGroups'] != null) {
      bloodGroups = <OptionModel>[];
      json['bloodGroups'].forEach((v) {
        bloodGroups!.add(OptionModel.fromJson(v));
      });
    }
    if (json['genders'] != null) {
      genders = <OptionModel>[];
      json['genders'].forEach((v) {
        genders!.add(OptionModel.fromJson(v));
      });
    }
    if (json['religions'] != null) {
      religions = <OptionModel>[];
      json['religions'].forEach((v) {
        religions!.add(OptionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companies != null) {
      data['companies'] = companies!.map((v) => v.toJson()).toList();
    }
    if (departments != null) {
      data['departments'] = departments!.map((v) => v.toJson()).toList();
    }
    if (designations != null) {
      data['designations'] = designations!.map((v) => v.toJson()).toList();
    }
    if (locations != null) {
      data['locations'] = locations!.map((v) => v.toJson()).toList();
    }
    if (bloodGroups != null) {
      data['bloodGroups'] = bloodGroups!.map((v) => v.toJson()).toList();
    }
    if (genders != null) {
      data['genders'] = genders!.map((v) => v.toJson()).toList();
    }
    if (religions != null) {
      data['religions'] = religions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionModel {
  String? name;

  OptionModel({this.name});

  OptionModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
