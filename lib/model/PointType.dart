// ignore_for_file: file_names

class PointType {
  //& Mapping map => model
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;

  bool? deletedFlag;

  String? systemCd;
  String? systemTypeCd;
  dynamic company;

  String? systemValue;
  int? systemSeq;
  String? systemDesc;

  PointType({
    this.createdBy,
    this.createdDt,
    this.changedBy,
    this.changedDt,
    this.deletedFlag,
    this.systemCd,
    this.systemTypeCd,
    this.company,
    this.systemValue,
    this.systemSeq,
    this.systemDesc,
  });

  PointType.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];

    systemCd = obj['systemCd'];
    systemTypeCd = obj['systemTypeCd'];
    company = obj['company'];
    systemValue = obj['systemValue'];
    systemSeq = obj['systemSeq'];
    systemDesc = obj['systemDesc'];

    // if (obj['systemTypeCd'] != null)
    //   systemTypeCd = PointTypeCd.map(obj['systemTypeCd']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['deletedFlag'] = deletedFlag;

    data['systemCd'] = systemCd;
    data['systemTypeCd'] = systemTypeCd;
    data['company'] = company;
    data['systemValue'] = systemValue;
    data['systemSeq'] = systemSeq;
    data['systemDesc'] = systemDesc;
    return data;
  }
}
