import 'package:flutter/services.dart';
import 'package:scc_web/model/company.dart';

class MstAttribute {
  int? no;
  String? createdBy;
  String? createdDt;
  String? updateBy;
  String? updateDt;
  bool? deletedFlag;
  String? attributeCd;
  String? attributeName;
  int? attrDataTypeLen;
  int? attrDataTypePrec;
  String? attrDesc;
  String? attrApiKey;
  MstAttrType? attrType;
  MstAttrDataType? attrDataType;
  String? iconBase64;
  String? fileBase64;

  String? companyCd;
  String? attrIcon;
  String? attrIconName;
  String? attrIconPath;

  String? attrTypeCd;
  String? attrDataTypeCd;
  Uint8List? file;

  MstAttribute(
      {this.no,
      this.createdBy,
      this.createdDt,
      this.updateBy,
      this.updateDt,
      this.deletedFlag,
      this.attributeCd,
      this.attributeName,
      this.attrDataTypeLen,
      this.attrDataTypePrec,
      this.attrDesc,
      this.attrApiKey,
      this.companyCd,
      this.attrIcon,
      this.attrIconName,
      this.iconBase64,
      this.attrTypeCd,
      this.attrIconPath,
      this.fileBase64});

  MstAttribute.map(Map<String, dynamic> obj) {
    no = obj['no'];
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    updateBy = obj['updateBy'];
    updateDt = obj['updateDt'];
    deletedFlag = obj['deletedFlag'];
    attributeCd = obj['attributeCd'];
    attributeName = obj['attributeName'];
    attrDataTypeLen = obj['attrDataTypeLen'];
    attrDataTypePrec = obj['attrDataTypePrec'];
    companyCd = obj['companyCd'];
    attrIcon = obj['attrIcon'];
    attrIconName = obj['attrIconName'];
    attrIconPath = obj['attrIconPath'];
    attrDesc = obj['attrDesc'];
    attrApiKey = obj['attrApiKey'];
    iconBase64 = obj['iconBase64'];
    attrTypeCd = obj['attrTypeCd'];
    attrDataTypeCd = obj['attrDataTypeCd'];
    fileBase64 = obj['fileBase64'];
    // if (obj['attrTypeCd'] != null) {
    //   attrType = MstAttrType.map(obj['attrTypeCd']);
    //   attrTypeCd = attrType!.systemCd;
    // }
    // if (obj['attrDataTypeCd'] != null) {
    //   attrDataType = MstAttrDataType.map(obj['attrDataTypeCd']);
    //   attrDataTypeCd = attrDataType!.systemCd;
    // }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['updateBy'] = updateBy;
    data['updateDt'] = updateDt;
    data['deletedFlag'] = deletedFlag;
    data['attributeCd'] = attributeCd;
    data['attributeName'] = attributeName;
    data['attrDataTypeLen'] = attrDataTypeLen;
    data['attrDataTypePrec'] = attrDataTypePrec;
    data['attrDesc'] = attrDesc;
    data['attrApiKey'] = attrApiKey;
    data['companyCd'] = companyCd;
    data['attrIcon'] = attrIcon;
    data['attrIconName'] = attrIconName;
    data['attrIconPath'] = attrIconPath;
    data['iconBase64'] = iconBase64;
    data['attrTypeCd'] = attrTypeCd;
    data['attrDataTypeCd'] = attrDataTypeCd;
    data['fileBase64'] = fileBase64;

    // data['attrTypeCd'] =
    //     attrTypeCd ?? (attrType != null ? attrType!.toMap() : null);
    // data['attrDataTypeCd'] =
    //     attrDataTypeCd ?? (attrDataType != null ? attrDataType!.toMap() : null);
    return data;
  }

  Map<String, String> toSearch() {
    Map<String, String> data = {};
    data['attributeCd'] = attributeCd ?? "";
    data['attributeName'] = attributeName ?? "";
    data['attrTypeCd'] = attrTypeCd ?? "";
    data['companyCd'] = companyCd ?? "";
    return data;
  }

  Map<String, String> toSubmit() {
    Map<String, String> data = {};
    data['attrCd'] = attributeCd ?? "";
    data['attrName'] = attributeName ?? "";
    data['attrTypeCd'] = attrTypeCd ?? "";
    data['attrDataTypeCd'] = attrDataTypeCd ?? "";
    data['attrDataTypeLen'] = (attrDataTypeLen ?? 0).toString();
    data['attrDataTypePrec'] = (attrDataTypePrec ?? 0).toString();
    data['attrDesc'] = attrDesc ?? "";
    data['attrApiKey'] = attrApiKey ?? "";
    data['iconBase64'] = iconBase64 ?? "";
    data['attrIconName'] = attrIconName ?? "";
    data['attrIconPath'] = attrIconPath ?? "";
    data['fileBase64'] = fileBase64 ?? "";
    // data['file'] = file;

    return data;
  }

  // Map<String, dynamic> toSubmit() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['no'] = no;
  //   data['companyCd'] = companyCd;
  //   data['attributeCd'] = attributeCd;
  //   data['attributeName'] = attributeName;
  //   data['attrTypeCd'] = attrTypeCd;
  //   data['attrDataTypeCd'] = attrDataTypeCd;
  //   data['attrDataTypeLen'] = attrDataTypeLen;
  //   data['attrDataTypePrec'] = attrDataTypePrec;
  //   data['attrDesc'] = attrDesc;
  //   data['attrIcon'] = attrIcon;
  //   data['attrIconName'] = attrIconName;
  //   data['attrIconPath'] = attrIconPath;
  //   data['attrApiKey'] = attrApiKey;
  //   data['iconBase64'] = iconBase64;
  //   data['createdBy'] = createdBy;
  //   data['updateDt'] = updateDt;
  //   return data;
  // }
}

class MstAttrDataType {
  String? createdBy;
  String? createdDt;
  String? updateBy;
  String? updateDt;
  bool? deletedFlag;
  String? systemCd;
  Company? company;
  String? systemValue;
  int? systemSeq;
  String? systemDesc;

  MstAttrDataType(
      {this.createdBy,
      this.createdDt,
      this.updateBy,
      this.updateDt,
      this.deletedFlag,
      this.systemCd,
      this.company,
      this.systemValue,
      this.systemSeq,
      this.systemDesc});

  MstAttrDataType.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    updateBy = obj['updateBy'];
    updateDt = obj['updateDt'];
    deletedFlag = obj['deletedFlag'];
    systemCd = obj['systemCd'];
    systemValue = obj['systemValue'];
    systemSeq = obj['systemSeq'];
    systemDesc = obj['systemDesc'];
    if (obj['company'] != null) {
      company = Company.map(obj['company']);
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['updateBy'] = updateBy;
    data['updateDt'] = updateDt;
    data['deletedFlag'] = deletedFlag;
    data['systemCd'] = systemCd;
    data['systemValue'] = systemValue;
    data['systemSeq'] = systemSeq;
    data['systemDesc'] = systemDesc;
    data['company'] = company != null ? company!.toMap() : null;
    return data;
  }
}

class MstAttrType {
  String? createdBy;
  String? createdDt;
  String? updateBy;
  String? updateDt;
  bool? deletedFlag;
  String? systemCd;
  Company? company;
  String? systemValue;
  int? systemSeq;
  String? systemDesc;

  MstAttrType(
      {this.createdBy,
      this.createdDt,
      this.updateBy,
      this.updateDt,
      this.deletedFlag,
      this.systemCd,
      this.company,
      this.systemValue,
      this.systemSeq,
      this.systemDesc});

  MstAttrType.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    updateBy = obj['updateBy'];
    updateDt = obj['updateDt'];
    deletedFlag = obj['deletedFlag'];
    systemCd = obj['systemCd'];
    systemValue = obj['systemValue'];
    systemSeq = obj['systemSeq'];
    systemDesc = obj['systemDesc'];
    if (obj['company'] != null) {
      company = Company.map(obj['company']);
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['updateBy'] = updateBy;
    data['updateDt'] = updateDt;
    data['deletedFlag'] = deletedFlag;
    data['systemCd'] = systemCd;
    data['systemValue'] = systemValue;
    data['systemSeq'] = systemSeq;
    data['systemDesc'] = systemDesc;
    data['company'] = company != null ? company!.toMap() : null;
    return data;
  }
}
