import 'package:scc_web/model/PartVehicleType.dart';
import 'package:scc_web/model/PointType.dart';
import 'package:scc_web/model/company.dart';

class Point {
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  bool? deletedFlag;
  String? pointCd;
  String? pointCdSuffix;
  String? pointName;
  String? pointDesc;
  String? dbSchema;
  String? tblNameTp;
  String? tblNameStock;
  String? tblNameRaw;
  double? locLongi;
  double? locLati;
  bool? isPoint;
  String? pageSize;
  String? pageNo;
  String? companyCd;
  String? pointTypeCd;
  String? partVehicleTypeCd;
  bool? pdiFlag;
  bool? suppInvFlag;
  bool? suppStackFlag;
  bool? suppLoadingFlag;
  bool? suppDeliveryFlag;
  bool? tmminInvFlag;
  bool? tmminPlaneConsumedFlag;

  String? tblNameTpRaw;
  String? tblNameTpRawDtl;
  String? tblNameTpPrev;
  String? tblNameTpRawDtlChild;
  String? tblNameStockD;
  bool? reprocessFlag;

  int? maxLiveness;
  Company? company;
  PointType? pointType;
  PartVehicleType? partVehicleType;

  Point({
    this.isPoint,
    this.createdBy,
    this.createdDt,
    this.companyCd,
    this.pointTypeCd,
    this.changedBy,
    this.changedDt,
    this.deletedFlag,
    this.pointCd,
    this.pointCdSuffix,
    this.pointName,
    this.pointDesc,
    this.dbSchema,
    this.tblNameTp,
    this.tblNameStock,
    this.tblNameRaw,
    this.locLongi,
    this.locLati,
    this.company,
    this.pointType,
    this.partVehicleType,
    this.pageNo,
    this.pageSize,
    this.suppInvFlag,
    this.suppStackFlag,
    this.suppLoadingFlag,
    this.suppDeliveryFlag,
    this.tmminInvFlag,
    this.tmminPlaneConsumedFlag,
    this.tblNameTpRaw,
    this.tblNameTpRawDtl,
    this.tblNameTpPrev,
    this.tblNameTpRawDtlChild,
    this.tblNameStockD,
    this.reprocessFlag,
  });

  Point.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];
    pointCd = obj['pointCd'];
    pointName = obj['pointName'];
    pointDesc = obj['pointDesc'];
    dbSchema = obj['dbSchema'];
    tblNameTp = obj['tblNameTp'];
    tblNameStock = obj['tblNameStock'];
    tblNameRaw = obj['tblNameRaw'];
    locLongi = obj['locLongi'];
    locLati = obj['locLati'];

    pointCdSuffix = obj['pointCdSuffix'];
    pointDesc = obj['pointDesc'];
    locLongi = obj['locLongi'];
    locLati = obj['locLati'];
    pdiFlag = obj['pdiFlag'];
    suppInvFlag = obj['suppInvFlag'];
    suppStackFlag = obj['suppStackFlag'];
    suppLoadingFlag = obj['suppLoadingFlag'];
    suppDeliveryFlag = obj['suppDeliveryFlag'];
    tmminInvFlag = obj['tmminInvFlag'];
    tmminPlaneConsumedFlag = obj['tmminPlaneConsumedFlag'];
    maxLiveness = obj['maxLiveness'];
    tblNameTpRaw = obj['tblNameTpRaw'];
    tblNameTpRawDtl = obj['tblNameTpRawDtl'];
    tblNameTpPrev = obj['tblNameTpPrev'];
    tblNameTpRawDtlChild = obj['tblNameTpRawDtlChild'];
    tblNameStockD = obj['tblNameStockD'];
    reprocessFlag = obj['reprocessFlag'];

    if (obj['companyCd'] != null && obj['companyCd'] is String) {
      companyCd = obj['companyCd'];
    } else if (obj['companyCd'] != null && obj['companyCd'] is Map) {
      company = Company.map(obj['companyCd']);
      companyCd = company!.companyCd;
    } else if (obj['company'] != null && obj['company'] is Map) {
      company = Company.map(obj['company']);
      companyCd = company!.companyCd;
    }
    if (obj['pointTypeCd'] != null && obj['pointTypeCd'] is String) {
      pointTypeCd = obj['pointTypeCd'];
    } else if (obj['pointTypeCd'] != null && obj['pointTypeCd'] is Map) {
      pointType = PointType.map(obj['pointTypeCd']);
      pointTypeCd = pointType!.systemCd;
    }
    if (obj['partVehicleTypeCd'] != null &&
        obj['partVehicleTypeCd'] is String) {
      partVehicleTypeCd = obj['partVehicleTypeCd'];
    } else if (obj['partVehicleTypeCd'] != null &&
        obj['partVehicleTypeCd'] is Map) {
      partVehicleType = PartVehicleType.map(obj['partVehicleTypeCd']);
      partVehicleTypeCd = partVehicleType!.systemCd;
    } else if (obj['partVehicleType'] != null &&
        obj['partVehicleType'] is Map) {
      partVehicleType = PartVehicleType.map(obj['partVehicleType']);
      partVehicleTypeCd = partVehicleType!.systemCd;
    }

    //for transaction
    if (obj['partVehicleType'] != null && obj['partVehicleType'] is String) {
      partVehicleTypeCd = obj['partVehicleType'];
    } else if (obj['partVehicleType'] != null &&
        obj['partVehicleType'] is Map) {
      partVehicleType = PartVehicleType.map(obj['partVehicleType']);
      partVehicleTypeCd = partVehicleType!.systemCd;
    } else if (obj['partVehicleType'] != null &&
        obj['partVehicleType'] is Map) {
      partVehicleType = PartVehicleType.map(obj['partVehicleType']);
      partVehicleTypeCd = partVehicleType!.systemCd;
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['deletedFlag'] = deletedFlag;
    data['pointCd'] = pointCd;
    data['pointCdSuffix'] = pointCdSuffix;
    data['pointName'] = pointName;
    data['pointDesc'] = pointDesc;
    data['dbSchema'] = dbSchema;
    data['tblNameTp'] = tblNameTp;
    data['tblNameStock'] = tblNameStock;
    data['tblNameRaw'] = tblNameRaw;
    data['locLongi'] = locLongi;
    data['locLati'] = locLati;
    data['companyCd'] = company != null ? company!.toMap() : null;
    data['pointTypeCd'] = pointType != null ? pointType!.toMap() : null;
    data['partVehicleType'] =
        partVehicleType != null ? partVehicleType!.toMap() : null;
    data['pageSize'] = pageSize;
    data['pageNo'] = pageNo;
    data['tblNameTpRaw'] = tblNameTpRaw;
    data['tblNameTpRawDtl'] = tblNameTpRawDtl;
    data['tblNameTpPrev'] = tblNameTpPrev;
    data['tblNameTpRawDtlChild'] = tblNameTpRawDtlChild;
    data['tblNameStockD'] = tblNameStockD;
    data['reprocessFlag'] = reprocessFlag;

    return data;
  }

  Map<String, dynamic> toSubmit() {
    Map<String, dynamic> data = {};
    data['pointCdSuffix'] = pointCdSuffix;
    data['pointName'] = pointName;
    data['partVehicleTypeCd'] = partVehicleTypeCd;
    data['companyCd'] = companyCd ?? "";
    data['pointTypeCd'] = pointTypeCd;
    data['pointDesc'] = pointDesc;
    data['locLongi'] = locLongi;
    data['locLati'] = locLati;
    data['pdiFlag'] = pdiFlag ?? false;
    data['suppInvFlag'] = suppInvFlag ?? false;
    data['suppStackFlag'] = suppStackFlag ?? false;
    data['suppLoadingFlag'] = suppLoadingFlag ?? false;
    data['suppDeliveryFlag'] = suppDeliveryFlag ?? false;
    data['tmminInvFlag'] = tmminInvFlag ?? false;
    data['tmminPlaneConsumedFlag'] = tmminPlaneConsumedFlag ?? false;
    data['maxLiveness'] = maxLiveness;
    return data;
  }

  Map<String, dynamic> toUpdate() {
    Map<String, dynamic> data = {};
    data['pointCd'] = pointCd;
    data['companyCd'] = companyCd ?? "";
    data['pointTypeCd'] = pointTypeCd;
    data['pointCdSuffix'] = pointCdSuffix;
    data['pointName'] = pointName;
    data['partVehicleTypeCd'] = partVehicleTypeCd;
    data['pointDesc'] = pointDesc;
    data['locLongi'] = locLongi;
    data['locLati'] = locLati;
    data['pdiFlag'] = pdiFlag ?? false;
    data['suppInvFlag'] = suppInvFlag ?? false;
    data['suppStackFlag'] = suppStackFlag ?? false;
    data['suppLoadingFlag'] = suppLoadingFlag ?? false;
    data['suppDeliveryFlag'] = suppDeliveryFlag ?? false;
    data['tmminInvFlag'] = tmminInvFlag ?? false;
    data['tmminPlaneConsumedFlag'] = tmminPlaneConsumedFlag ?? false;
    data['maxLiveness'] = maxLiveness;
    return data;
  }

  Map<String, String> searchPoint() {
    final Map<String, String> data = {};
    data['pointCd'] = pointCd ?? "";
    data['pointName'] = pointName ?? "";
    data['pageSize'] = pageSize ?? "";
    data['pageNo'] = pageNo ?? "";
    return data;
  }
}

// New Point Changes 28 Jun 2022
class NewPoint {
  int? pageNo;
  int? pageSize;
  int? totalDataInPage;
  int? totalData;
  int? totalPages;
  List<ListDataNewPoint>? listData;

  NewPoint(
      {this.pageNo,
      this.pageSize,
      this.totalDataInPage,
      this.totalData,
      this.totalPages,
      this.listData});

  NewPoint.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalDataInPage = json['totalDataInPage'];
    totalData = json['totalData'];
    totalPages = json['totalPages'];
    if (json['listData'] != null) {
      listData = <ListDataNewPoint>[];
      json['listData'].forEach((v) {
        listData!.add(ListDataNewPoint.fromJson(v));
      });
    }
  }
}

class ListDataNewPoint {
  int? no;
  String? pointCd;

  String? pointTypeCd;
  String? pointType;

  String? pointName;

  String? tmplAttrCd;

  bool? flagConsume;
  String? lastUpdated;

  ListDataNewPoint(
      {this.no,
      this.pointCd,
      this.pointTypeCd,
      this.pointType,
      this.pointName,
      this.tmplAttrCd,
      this.flagConsume,
      this.lastUpdated});

  ListDataNewPoint.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    pointCd = json['pointCd'];
    pointTypeCd = json['pointTypeCd'];
    pointType = json['pointType'];
    pointName = json['pointName'];
    tmplAttrCd = json['tmplAttrCd'];
    flagConsume = json['flagConsume'];
    lastUpdated = json['lastUpdated'];
  }
}

class GetNewPointData {
  String? pointCd;
  String? pointTypeCd;
  String? pointCdSuffix;
  String? type;
  String? pointName;
  String? partVehicleTypeCd;
  String? pointDesc;
  String? inventory;
  String? tmplAttrCd;
  int? maxliveness;
  List<String>? entityCd;
  String? iconBase64;
  String? pointType;

  String? pointProductCd;
  int? maxLiveness;
  List<String>? nodeBlockchain;
  int? maxConsumeDt;

  bool? flagConsume;
  String? pointAttrIndate;
  String? pointAttrInOutdate;
  List<String>? attrKey;

  GetNewPointData(
      {this.pointCd,
      this.type,
      this.pointTypeCd,
      this.pointCdSuffix,
      this.pointName,
      this.partVehicleTypeCd,
      this.pointDesc,
      this.inventory,
      this.tmplAttrCd,
      this.maxliveness,
      this.entityCd,
      this.pointType,
      this.pointProductCd,
      this.maxLiveness,
      this.nodeBlockchain,
      this.maxConsumeDt,
      this.iconBase64,
      this.flagConsume,
      this.pointAttrIndate,
      this.pointAttrInOutdate,
      this.attrKey});

  GetNewPointData.fromJson(Map<String, dynamic> json) {
    pointCd = json['pointCd'];
    pointTypeCd = json['pointTypeCd'];
    pointCdSuffix = json['pointCdSuffix'];
    pointName = json['pointName'];
    partVehicleTypeCd = json['partVehicleTypeCd'];
    pointDesc = json['pointDesc'];
    inventory = json['inventory'];
    tmplAttrCd = json['tmplAttrCd'];
    maxliveness = json['maxliveness'];
    entityCd = json['entityCd'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pointCd'] = pointCd;
    data['pointTypeCd'] = pointTypeCd;
    data['pointCdSuffix'] = pointCdSuffix;
    data['pointName'] = pointName;
    data['partVehicleTypeCd'] = partVehicleTypeCd;
    data['pointDesc'] = pointDesc;
    data['inventory'] = inventory;
    data['tmplAttrCd'] = tmplAttrCd;
    data['maxliveness'] = maxliveness;
    data['entityCd'] = entityCd;
    return data;
  }

  Map<String, dynamic> toSave() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pointTypeCd'] = pointTypeCd;
    data['pointName'] = pointName;
    data['pointType'] = pointType;
    data['pointCdSuffix'] = pointCdSuffix;
    data['pointProductCd'] = pointProductCd;
    data['maxLiveness'] = maxLiveness;
    data['nodeBlockchain'] = nodeBlockchain;
    data['maxConsumeDt'] = maxConsumeDt;
    data['pointDesc'] = pointDesc;
    data['iconBase64'] = iconBase64;
    data['tmplAttrCd'] = tmplAttrCd;
    data['flagConsume'] = flagConsume;
    data['pointAttrIndate'] = pointAttrIndate;
    data['pointAttrInOutdate'] = pointAttrInOutdate;
    data['attrKey'] = attrKey;
    return data;
  }
}

class TempAttrDetail {
  String? tmplAttrCd;
  String? tmplAttrName;
  String? tmplAttrDesc;
  List<ListAttributeDetail>? listAttribute;

  TempAttrDetail(
      {this.tmplAttrCd,
      this.tmplAttrName,
      this.tmplAttrDesc,
      this.listAttribute});

  TempAttrDetail.fromJson(Map<String, dynamic> json) {
    tmplAttrCd = json['tmplAttrCd'];
    tmplAttrName = json['tmplAttrName'];
    tmplAttrDesc = json['tmplAttrDesc'];
    if (json['listAttribute'] != null) {
      listAttribute = <ListAttributeDetail>[];
      json['listAttribute'].forEach((v) {
        listAttribute!.add(ListAttributeDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tmplAttrCd'] = tmplAttrCd;
    data['tmplAttrName'] = tmplAttrName;
    data['tmplAttrDesc'] = tmplAttrDesc;
    if (listAttribute != null) {
      data['listAttribute'] = listAttribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListAttributeDetail {
  String? attributeCd;

  ListAttributeDetail({this.attributeCd});

  ListAttributeDetail.fromJson(Map<String, dynamic> json) {
    attributeCd = json['attributeCd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attributeCd'] = attributeCd;
    return data;
  }
}

class ViewPointModel {
  String? pointCd;
  String? pointTypeCd;
  String? pointName;
  String? pointType;
  String? pointCdSuffix;
  String? pointProductCd;
  int? maxLiveness;
  List<String>? nodeBlockchain;
  int? maxConsumeDt;
  String? pointDesc;
  String? iconBase64;
  String? iconPath;
  String? iconName;
  String? tmplAttrCd;
  List<String>? attrKey;
  bool? flagConsume;
  String? pointAttrIndate;
  String? pointAttrInOutdate;

  ViewPointModel(
      {this.pointCd,
      this.pointTypeCd,
      this.pointName,
      this.pointType,
      this.pointCdSuffix,
      this.pointProductCd,
      this.maxLiveness,
      this.nodeBlockchain,
      this.maxConsumeDt,
      this.pointDesc,
      this.iconBase64,
      this.iconPath,
      this.iconName,
      this.tmplAttrCd,
      this.flagConsume,
      this.pointAttrInOutdate,
      this.pointAttrIndate,
      this.attrKey});

  ViewPointModel.fromJson(Map<String, dynamic> json) {
    pointCd = json['pointCd'];
    pointTypeCd = json['pointTypeCd'];
    pointName = json['pointName'];
    pointType = json['pointType'];
    pointCdSuffix = json['pointCdSuffix'];
    pointProductCd = json['pointProductCd'];
    maxLiveness = json['maxLiveness'];
    nodeBlockchain = json['nodeBlockchain'].cast<String>();
    maxConsumeDt = json['maxConsumeDt'];
    pointDesc = json['pointDesc'];
    iconBase64 = json['iconBase64'];
    iconPath = json['iconPath'];
    iconName = json['iconName'];
    flagConsume = json['flagConsume'];
    pointAttrIndate = json['pointAttrIndate'];
    pointAttrInOutdate = json['pointAttrInOutdate'];
    tmplAttrCd = json['tmplAttrCd'];
    attrKey = json['attrKey'].cast<String>();
  }
  Map<String, dynamic> toSave() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pointTypeCd'] = pointTypeCd;
    data['pointName'] = pointName;
    data['pointType'] = pointType;
    data['pointCdSuffix'] = pointCdSuffix;
    data['pointProductCd'] = pointProductCd;
    data['maxLiveness'] = maxLiveness;
    data['nodeBlockchain'] = nodeBlockchain;
    data['maxConsumeDt'] = maxConsumeDt;
    data['pointDesc'] = pointDesc;
    data['iconBase64'] = iconBase64;
    data['tmplAttrCd'] = tmplAttrCd;
    data['flagConsume'] = flagConsume;
    data['pointAttrIndate'] = pointAttrIndate;
    data['pointAttrInOutdate'] = pointAttrInOutdate;
    data['attrKey'] = attrKey;
    return data;
  }
}
