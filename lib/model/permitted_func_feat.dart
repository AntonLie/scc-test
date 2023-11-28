class PermittedFunc {
  bool? superAdmin;
  bool? fullAccess;
  List<FeatureList>? featureList;

  PermittedFunc({this.superAdmin, this.fullAccess, this.featureList});

  PermittedFunc.fromJson(Map<String, dynamic> json) {
    superAdmin = json['superAdmin'];
    fullAccess = json['fullAccess'];
    if (json['featureList'] != null) {
      featureList = <FeatureList>[];
      json['featureList'].forEach((v) {
        featureList!.add(FeatureList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['superAdmin'] = superAdmin;
    data['fullAccess'] = fullAccess;
    if (featureList != null) {
      data['featureList'] = featureList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeatureList {
  String? featureCd;
  String? featureName;

  FeatureList({this.featureCd, this.featureName});

  FeatureList.fromJson(Map<String, dynamic> json) {
    featureCd = json['featureCd'];
    featureName = json['featureName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['featureCd'] = featureCd;
    data['featureName'] = featureName;
    return data;
  }
}
