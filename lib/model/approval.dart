class ListApproval {
  int? no;
  String? itemCd;
  String? itemName;
  String? itemDesc;
  String? useCaseCd;
  String? useCaseName;
  String? statusCd;
  String? supplierCd;
  String? supplierName;
  String? lastUpdated;
  String? searchBy;
  String? searchValue;

  ListApproval(
      {this.no,
      this.itemCd,
      this.itemName,
      this.searchBy,
      this.itemDesc,
      this.searchValue,
      this.useCaseCd,
      this.useCaseName,
      this.statusCd,
      this.supplierCd,
      this.supplierName,
      this.lastUpdated});

  ListApproval.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    itemCd = json['itemCd'];
    itemName = json['itemName'];
    itemDesc = json['itemDesc'];
    useCaseCd = json['useCaseCd'];
    useCaseName = json['useCaseName'];
    statusCd = json['statusCd'];
    supplierCd = json['supplierCd'];
    supplierName = json['supplierName'];
    lastUpdated = json['lastUpdated'];
  }
}

class GetViewApp {
  String? companyCd;
  String? supplierCd;
  String? supplierName;
  String? itemCd;
  String? itemName;
  String? itemDesc;
  String? uom;
  String? notes;
  String? uomType;
  String? useCaseCd;
  String? useCaseName;
  String? useCaseDesc;
  String? attributeSerialNumber;
  String? statusCd;
  String? lastUpdateBy;
  String? startDt;
  String? endDt;
  String? lastUpdatedDate;
  List<UseCasePointList>? useCasePointList;

  GetViewApp(
      {this.companyCd,
      this.supplierCd,
      this.supplierName,
      this.itemCd,
      this.itemName,
      this.itemDesc,
      this.uom,
      this.uomType,
      this.useCaseCd,
      this.useCaseName,
      this.useCaseDesc,
      this.attributeSerialNumber,
      this.statusCd,
      this.lastUpdateBy,
      this.startDt,
      this.endDt,
      this.lastUpdatedDate,
      this.useCasePointList});

  GetViewApp.fromJson(Map<String, dynamic> json) {
    companyCd = json['companyCd'];
    supplierCd = json['supplierCd'];
    supplierName = json['supplierName'];
    itemCd = json['itemCd'];
    itemName = json['itemName'];
    itemDesc = json['itemDesc'];
    uom = json['uom'];
    uomType = json['uomType'];
    useCaseCd = json['useCaseCd'];
    useCaseName = json['useCaseName'];
    useCaseDesc = json['useCaseDesc'];
    attributeSerialNumber = json['attributeSerialNumber'];
    statusCd = json['statusCd'] ?? "";
    lastUpdateBy = json['lastUpdateBy'];
    startDt = json['startDt'];
    endDt = json['endDt'];
    lastUpdatedDate = json['lastUpdatedDate'];
    if (json['useCasePointList'] != null) {
      useCasePointList = <UseCasePointList>[];
      json['useCasePointList'].forEach((v) {
        useCasePointList!.add(UseCasePointList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toSubmit() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemCd'] = itemCd;
    data['statusCd'] = statusCd;
    data['notes'] = notes;
    data['supplierCd'] = supplierCd;
    return data;
  }
}

class UseCasePointList {
  String? pointCd;
  int? seq;
  bool? checkParent;
  bool? pointSupplierFlag;
  bool? pointreceiveFlag;
  bool? blockchainFlag;
  String? entityCd;
  String? templateAttrCd;
  String? typePoint;
  String? typePointName;

  UseCasePointList(
      {this.pointCd,
      this.seq,
      this.checkParent,
      this.pointSupplierFlag,
      this.pointreceiveFlag,
      this.blockchainFlag,
      this.entityCd,
      this.templateAttrCd,
      this.typePoint,
      this.typePointName});

  UseCasePointList.fromJson(Map<String, dynamic> json) {
    pointCd = json['pointCd'];
    seq = json['seq'];
    checkParent = json['checkParent'];
    pointSupplierFlag = json['pointSupplierFlag'];
    pointreceiveFlag = json['pointreceiveFlag'];
    blockchainFlag = json['blockchainFlag'];
    entityCd = json['entityCd'];
    templateAttrCd = json['templateAttrCd'];
    typePoint = json['typePoint'];
    typePointName = json['typePointName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pointCd'] = pointCd;
    data['seq'] = seq;
    data['checkParent'] = checkParent;
    data['pointSupplierFlag'] = pointSupplierFlag;
    data['pointreceiveFlag'] = pointreceiveFlag;
    data['blockchainFlag'] = blockchainFlag;
    data['entityCd'] = entityCd;
    data['templateAttrCd'] = templateAttrCd;
    data['typePoint'] = typePoint;
    data['typePointName'] = typePointName;
    return data;
  }
}
