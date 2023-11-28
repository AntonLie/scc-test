// import 'package:vcc_web/helper/utils.dart';

class TemplateAttribute {
  int? no;
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  bool? deletedFlag;
  String? tmplAttrCd;
  String? tmplAttrName;
  String? tmplAttrDesc;
  List<TemplateAttributeDetail>? detail;
  String? attrCode;

  TemplateAttribute(
      {this.no,
      this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.deletedFlag,
      this.tmplAttrCd,
      this.tmplAttrName,
      this.tmplAttrDesc,
      this.detail,
      this.attrCode});

  TemplateAttribute.map(Map<String, dynamic> obj) {
    no = obj['no'];
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];
    tmplAttrCd = obj['tmplAttrCd'];
    tmplAttrName = obj['tmplAttrName'];
    tmplAttrDesc = obj['tmplAttrDesc'];

    if (obj['detail'] != null && obj['detail'] is List) {
      detail = [];
      for (var v in (obj['detail'] as List)) {
        detail!.add(TemplateAttributeDetail.map(v));
      }
    }
  }

  Map<String, dynamic> toAdd() {
    Map<String, dynamic> data = {};
    data['tmplAttrCd'] = tmplAttrCd;
    data['tmplAttrName'] = tmplAttrName;
    data['tmplAttrDesc'] = tmplAttrDesc;

    if (detail != null) {
      data['detail'] = detail!.map((v) => v.toAdd()).toList();
    }

    return data;
  }

  // Map<String, dynamic> toMap() {
  //   final Map<String, dynamic> data= {};
  //   data['createdBy'] = this.createdBy;
  //   data['createdDt'] = this.createdDt;
  //   data['changedBy'] = this.changedBy;
  //   data['changedDt'] = this.changedDt;
  //   data['deletedFlag'] = this.deletedFlag;
  //   data['tmplAttrCd'] = this.tmplAttrCd;
  //   data['tmplAttrName'] = this.tmplAttrName;
  //   data['tmplAttrDesc'] = this.tmplAttrDesc;

  //   if (this.detail != null) {
  //     data['detail'] = this.detail!.map((v) => v.toMap()).toList();
  //   }

  //   return data;
  // }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['tmplAttrCd'] = tmplAttrCd;
    data['tmplAttrName'] = tmplAttrName;
    data['tmplAttrDesc'] = tmplAttrDesc;

    if (detail != null) {
      data['detail'] = detail!.map((v) => v.toMap()).toList();
    }

    return data;
  }
}

class TemplateAttributeDetail {
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  String? attrCd;
  String? attrName;
  String? dataType;
  String? attrApiKey;
  int? seq;
  bool? mandatoryFlag;
  bool? showOnTraceabilityFlag;
  AttributeCd? attrCodeDetail;

  TemplateAttributeDetail(
      {this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.attrCodeDetail,
      this.seq,
      this.attrApiKey,
      this.dataType,
      this.mandatoryFlag,
      this.attrCd,
      this.attrName});

  TemplateAttributeDetail.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    seq = obj['seq'] ?? 0;
    mandatoryFlag = obj['mandatoryFlag'];
    showOnTraceabilityFlag = obj['showOnTraceabilityFlag'];

    if (obj['attrCd'] != null && obj['attrCd'] is Map) {
      attrCodeDetail = AttributeCd.map(obj['attrCd']);
      attrCd = attrCodeDetail!.attrCd;
      attrName = attrCodeDetail!.attrName;
      attrApiKey = attrCodeDetail!.attrApiKey;
      dataType = attrCodeDetail!.dataType;
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;

    data['attrCd'] = attrCd;
    data['seq'] = seq;
    data['mandatoryFlag'] = mandatoryFlag == true;
    data['showOnTraceabilityFlag'] = showOnTraceabilityFlag == true;
    return data;
  }

  Map<String, dynamic> toAdd() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['attrCd'] = attrCd;
    data['seq'] = seq;
    data['mandatoryFlag'] = mandatoryFlag == true;
    data['showOnTraceabilityFlag'] = showOnTraceabilityFlag == true;
    return data;
  }
}

class AttributeCd {
  String? createdBy;
  String? createdDt;
  dynamic changedBy;
  dynamic changedDt;
  bool? deletedFlag;
  String? attrCd;
  String? attrName;
  String? dataType;
  AttrDataTypeCd? attrDataTypeCd;
  AttrDataTypeCd? attrTypeCd;
  int? attrDataTypeLen;
  int? attrDataTypePrec;
  String? attrDesc;
  String? attrApiKey;

  AttributeCd(
      {this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.deletedFlag,
      this.attrCd,
      this.attrName,
      this.attrDataTypeCd,
      this.attrTypeCd,
      this.dataType,
      this.attrDataTypeLen,
      this.attrDataTypePrec,
      this.attrDesc,
      this.attrApiKey});

  AttributeCd.map(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdDt = json['createdDt'];
    changedBy = json['changedBy'];
    changedDt = json['changedDt'];
    deletedFlag = json['deletedFlag'];
    attrCd = json['attrCd'];
    attrName = json['attrName'];
    attrDataTypeCd = json['attrDataTypeCd'] != null
        ? AttrDataTypeCd.map(json['attrDataTypeCd'])
        : null;
    if (attrDataTypeCd != null) {
      dataType = attrDataTypeCd!.systemValue;
    }
    attrTypeCd = json['attrTypeCd'] != null
        ? AttrDataTypeCd.map(json['attrTypeCd'])
        : null;
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
    data['attrCd'] = attrCd;
    data['attrName'] = attrName;
    if (attrDataTypeCd != null) {
      data['attrDataTypeCd'] = attrDataTypeCd!.toMap();
    }
    if (attrTypeCd != null) {
      data['attrTypeCd'] = attrTypeCd!.toMap();
    }
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

  AttrDataTypeCd(
      {this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.deletedFlag,
      this.systemCd,
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
    data['company'] = company;
    data['systemValue'] = systemValue;
    data['systemSeq'] = systemSeq;
    data['systemDesc'] = systemDesc;
    return data;
  }
}
