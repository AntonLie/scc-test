// import 'package:vcc_web/helper/utils.dart';

class TempAttr {
  int? no;
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  bool? deletedFlag;
  String? tempAttrCd;
  String? tempAttrName;
  String? tempAttrDesc;
  List<TempAttDetail>? templateDetail;
  String? attrCode;
  String? attributeCd;
  String? attributeName;
  String? companyCd;
  String? attrTypeCd;
  String? attrDataTypeCd;
  int? attrDataTypeLen;
  int? attrDataTypePrec;
  String? attrDesc;
  String? attrIcon;
  String? attrIconName;
  String? attrIconPath;
  String? attrApiKey;
  String? iconBase64;
  String? updateDt;

  TempAttr(
      {this.no,
      this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.deletedFlag,
      this.tempAttrCd,
      this.tempAttrName,
      this.tempAttrDesc,
      this.templateDetail,
      this.attrCode,
      this.companyCd,
      this.attributeCd,
      this.attributeName,
      this.attrTypeCd,
      this.attrDataTypeCd,
      this.attrDataTypeLen,
      this.attrDataTypePrec,
      this.attrDesc,
      this.attrIcon,
      this.attrIconName,
      this.attrIconPath,
      this.attrApiKey,
      this.updateDt,
      this.iconBase64});

  TempAttr.map(Map<String, dynamic> obj) {
    no = obj['no'];
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];
    tempAttrCd = obj['tempAttrCd'];
    tempAttrName = obj['tempAttrName'];
    tempAttrDesc = obj['tempAttrDesc'];
    updateDt = obj['updateDt'];

    if (obj['templateDetail'] != null && obj['templateDetail'] is List) {
      templateDetail = [];
      for (var v in (obj['templateDetail'] as List)) {
        templateDetail!.add(TempAttDetail.map(v));
      }
    }
  }
  TempAttr.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    companyCd = json['companyCd'];
    attributeCd = json['attributeCd'];
    attributeName = json['attributeName'];
    attrTypeCd = json['attrTypeCd'];
    attrDataTypeCd = json['attrDataTypeCd'];
    attrDataTypeLen = json['attrDataTypeLen'];
    attrDataTypePrec = json['attrDataTypePrec'];
    attrDesc = json['attrDesc'];
    attrIcon = json['attrIcon'];
    attrIconName = json['attrIconName'];
    attrIconPath = json['attrIconPath'];
    attrApiKey = json['attrApiKey'];
    iconBase64 = json['iconBase64'];
    updateDt = json['updateDt'];
  }

  Map<String, dynamic> toAdd() {
    Map<String, dynamic> data = {};
    data['tempAttrCd'] = tempAttrCd;
    data['tempAttrName'] = tempAttrName;
    data['tempAttrDesc'] = tempAttrDesc;

    if (templateDetail != null) {
      data['templateDetail'] = templateDetail!.map((v) => v.toAdd()).toList();
    }

    return data;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['tempAttrCd'] = tempAttrCd;
    data['tempAttrName'] = tempAttrName;
    data['tempAttrDesc'] = tempAttrDesc;

    if (templateDetail != null) {
      data['templateDetail'] = templateDetail!.map((v) => v.toMap()).toList();
    }

    return data;
  }

  Map<String, dynamic> toSubmit() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attributeCd'] = attributeCd;
    data['attributeName'] = attributeName;
    data['companyCd'] = companyCd;
    data['attrTypeCd'] = attrTypeCd;
    data['tempAttrCd'] = tempAttrCd;
    return data;
  }
}

class TempAttDetail {
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  String? attributeCd;
  String? attributeName;
  String? dataType;
  String? attrApiKey;
  int? seq;
  bool? mandatoryFlag;
  bool? showTraceAbility;
  AttrCodeClass? attrCodeDetail;

  TempAttDetail(
      {this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.attrCodeDetail,
      this.seq,
      this.attrApiKey,
      this.dataType,
      this.mandatoryFlag,
      this.attributeCd,
      this.attributeName});

  TempAttDetail.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    seq = obj['seq'] ?? 0;
    mandatoryFlag = obj['mandatoryFlag'];
    showTraceAbility = obj['showTraceAbility'];
    attributeCd = obj['attrCd'];
    attributeName = obj['attrName'];
    dataType = obj['dataType'];
    attrApiKey = obj['apiKey'];

    // if (obj['attributeCd'] != null && obj['attributeCd'] is Map) {
    //   attrCodeDetail = AttrCodeClass.map(obj['attributeCd']);
    //   attributeCd = attrCodeDetail!.attributeCd;
    //   attributeName = attrCodeDetail!.attributeName;
    //   attrApiKey = attrCodeDetail!.attrApiKey;
    //   dataType = attrCodeDetail!.dataType;
    // }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;

    data['attributeCd'] = attributeCd;
    data['seq'] = seq;
    data['mandatoryFlag'] = mandatoryFlag == true;
    data['showTraceAbility'] = showTraceAbility == true;
    return data;
  }

  Map<String, dynamic> toAdd() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['attrCd'] = attributeCd;
    data['seq'] = seq;
    data['mandatoryFlag'] = mandatoryFlag == true;
    data['showTraceAbility'] = showTraceAbility == true;
    return data;
  }
}

class AttrCodeClass {
  String? createdBy;
  String? createdDt;
  dynamic changedBy;
  dynamic changedDt;
  bool? deletedFlag;
  String? attributeCd;
  String? attributeName;
  String? dataType;
  String? attrDataTypeCd;
  String? attrTypeCd;
  int? attrDataTypeLen;
  int? attrDataTypePrec;
  String? attrDesc;
  String? attrApiKey;

  AttrCodeClass(
      {this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.deletedFlag,
      this.attributeCd,
      this.attributeName,
      this.attrDataTypeCd,
      this.attrTypeCd,
      this.dataType,
      this.attrDataTypeLen,
      this.attrDataTypePrec,
      this.attrDesc,
      this.attrApiKey});

  AttrCodeClass.map(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdDt = json['createdDt'];
    changedBy = json['changedBy'];
    changedDt = json['changedDt'];
    deletedFlag = json['deletedFlag'];
    attributeCd = json['attributeCd'];
    attributeName = json['attributeName'];
    attrDataTypeCd = json['attrDataTypeCd'];
    attrTypeCd = json['attrTypeCd'];
    // attrDataTypeCd = AttrDataTypeCd.map(json['attrDataTypeCd']);
    // if (attrDataTypeCd != null) {
    //   dataType = attrDataTypeCd!.systemValue;
    // }
    // attrTypeCd = json['attrTypeCd'] != null
    //     ? attrDataTypeCd.map(json['attrTypeCd'])
    //     : null;
    attrDataTypeLen = json['attrDataTypeLen'];
    attrDataTypePrec = json['attrDataTypePrec'];
    attrDesc = json['attrDesc'];
    attrApiKey = json['attrApiKey'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['deletedFlag'] = deletedFlag;
    data['attrCd'] = attributeCd;
    data['attributeName'] = attributeName;
    data['attrDataTypeCd'] = attrDataTypeCd;
    data['attrTypeCd'] = attrTypeCd;
    // if (attrDataTypeCd != null) {
    //   data['attrDataTypeCd'] = attrDataTypeCd!.toMap();
    // }
    // if (attrTypeCd != null) {
    //   data['attrTypeCd'] = attrTypeCd!.toMap();
    // }
    data['attrDataTypeLen'] = attrDataTypeLen;
    data['attrDataTypePrec'] = attrDataTypePrec;
    data['attrDesc'] = attrDesc;
    data['attrApiKey'] = attrApiKey;
    return data;
  }
}

class AttrDataTypeCd {
  String? createdBy;
  String? createdDt;
  dynamic changedBy;
  dynamic changedDt;
  bool? deletedFlag;
  String? systemCd;
  dynamic company;
  String? systemValue;
  int? systemSeq;
  String? systemDesc;
  String? systemTypeCd;

  AttrDataTypeCd(
      {this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.deletedFlag,
      this.systemCd,
      this.systemTypeCd,
      this.company,
      this.systemValue,
      this.systemSeq,
      this.systemDesc});

  AttrDataTypeCd.map(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdDt = json['createdDt'];
    changedBy = json['changedBy'];
    changedDt = json['changedDt'];
    deletedFlag = json['deletedFlag'];
    systemCd = json['systemCd'];
    systemTypeCd = json['systemTypeCd'];
    company = json['company'];
    systemValue = json['systemValue'];
    systemSeq = json['systemSeq'];
    systemDesc = json['systemDesc'];
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
