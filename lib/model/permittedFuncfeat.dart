// ignore_for_file: file_names

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

class FunctionList {
  String? functionCd;
  String? url;
  String? method;
  FunctionList({this.functionCd, this.url, this.method});

  FunctionList.map(Map<String, dynamic> obj) {
    functionCd = obj['functionCd'];
    method = obj['method'];
    url = obj['url'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['functionCd'] = functionCd;
    data['method'] = method;
    data['url'] = url;
    return data;
  }
}
