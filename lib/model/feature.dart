class Feature {
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  bool? deletedFlag;
  String? featureCd;
  String? featureName;
  String? featureDesc;

  Feature({
    createdBy,
    createdDt,
    changedBy,
    changedDt,
    deletedFlag,
    featureCd,
    featureDesc,
    featureName,
  });
  Feature.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];
    featureCd = obj['featureCd'];
    featureDesc = obj['featureDesc'];
    featureName = obj['featureName'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['featureCd'] = featureCd;
    data['featureName'] = featureName;
    data['featureDesc'] = featureDesc;
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['deletedFlag'] = deletedFlag;

    return data;
  }
}
