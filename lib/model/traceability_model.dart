class ListTraceability {
  int? no;
  String? companyCd;
  String? itemCd;
  String? supplierCd;
  String? itemId;
  String? itemName;
  String? dtlTracebilityTop;
  String? pointCdBlockchain;
  String? dtlTracebilityBottom;
  String? dtlOnTraceTop;
  String? dtlOnTraceBottom;
  String? dtlOnChildTop;
  String? dtlOnChildBottom;
  String? tableNameTp;
  String? lastPointCd;
  String? dbName;
  String? blockChainStatus;
  String? productionDt;
  String? status;
  bool? supplierPointFlag;
  bool? reciverPointFlag;
  String? consumedUom;
  String? consumedUomType;
  bool? blockChain;
  int? consumedQty;
  String? dbSchema;
  List<AttrTop>? attrTop;
  List<AttrBottom>? attrBottom;

  ListTraceability(
      {this.no,
      this.companyCd,
      this.itemCd,
      this.itemId,
      this.itemName,
      this.dtlTracebilityTop,
      this.pointCdBlockchain,
      this.dtlTracebilityBottom,
      this.dtlOnTraceTop,
      this.dtlOnTraceBottom,
      this.dtlOnChildTop,
      this.dtlOnChildBottom,
      this.tableNameTp,
      this.lastPointCd,
      this.dbName,
      this.dbSchema,
      this.blockChainStatus,
      this.productionDt,
      this.status,
      this.consumedUom,
      this.consumedUomType,
      this.consumedQty,
      this.attrTop,
      this.attrBottom,
      this.blockChain});

  ListTraceability.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    companyCd = json['companyCd'];
    supplierCd = json['supplierCd'];
    itemCd = json['itemCd'];
    itemId = json['itemId'];
    itemName = json['itemName'];
    dtlTracebilityTop = json['dtlTracebilityTop'];
    pointCdBlockchain = json['pointCdBlockchain'];
    dtlTracebilityBottom = json['dtlTracebilityBottom'];
    dtlOnTraceTop = json['dtlOnTraceTop'];
    dtlOnTraceBottom = json['dtlOnTraceBottom'];
    dtlOnChildTop = json['dtlOnChildTop'];
    dtlOnChildBottom = json['dtlOnChildBottom'];
    tableNameTp = json['tableNameTp'];
    lastPointCd = json['lastPointCd'];
    dbName = json['dbName'];
    dbSchema = json['dbSchema'];
    blockChainStatus = json['blockChainStatus'];
    productionDt = json['productionDt'];
    status = json['status'];
    blockChain = json['blockChain'];
    if (json['attrTop'] != null) {
      attrTop = <AttrTop>[];
      json['attrTop'].forEach((v) {
        attrTop!.add(AttrTop.fromJson(v));
      });
    } else {
      json['attrTop'] = [];
    }
    if (json['attrBottom'] != null) {
      attrBottom = <AttrBottom>[];
      json['attrBottom'].forEach((v) {
        attrBottom!.add(AttrBottom.fromJson(v));
      });
    }
  }
  ListTraceability.consume(Map<String, dynamic> json) {
    no = json['no'];
    companyCd = json['companyCd'];
    supplierCd = json['supplierCd'];
    itemCd = json['itemCd'];
    itemName = json['itemName'];
    itemId = json['itemId'];
    dtlTracebilityTop = json['dtlTracebilityTop'];
    dtlTracebilityBottom = json['dtlTracebilityBottom'];
    dtlOnTraceTop = json['dtlOnTraceTop'];
    dtlOnTraceBottom = json['dtlOnTraceBottom'];
    dtlOnChildTop = json['dtlOnChildTop'];
    dtlOnChildBottom = json['dtlOnChildBottom'];
    tableNameTp = json['tableNameTp'];
    lastPointCd = json['lastPointCd'];
    dbName = json['dbName'];
    dbSchema = json['dbSchema'];
    blockChainStatus = json['blockChainStatus'];
    productionDt = json['productionDt'];
    consumedUom = json['consumedUom'];
    consumedUomType = json['consumedUomType'];
    consumedQty = json['consumedQty'];
    if (json['attrTop'] != null) {
      attrTop = <AttrTop>[];
      json['attrTop'].forEach((v) {
        attrTop!.add(AttrTop.fromJson(v));
      });
    }
    if (json['attrBottom'] != null) {
      attrBottom = <AttrBottom>[];
      json['attrBottom'].forEach((v) {
        attrBottom!.add(AttrBottom.fromJson(v));
      });
    }
  }
  ListTraceability.toForm(Map<String, dynamic> json) {
    itemName = json['itemName'];
    itemId = json['itemId'];
    itemCd = json['itemCd'];
    if (json['attrTop'] != null) {
      attrTop = <AttrTop>[];
      json['attrTop'].forEach((v) {
        attrTop!.add(AttrTop.fromJson(v));
      });
    }
    if (json['attrBottom'] != null) {
      attrBottom = <AttrBottom>[];
      json['attrBottom'].forEach((v) {
        attrBottom!.add(AttrBottom.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toForm() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyCd'] = companyCd;
    data['supplierCd'] = supplierCd;
    data['itemId'] = itemId;
    data['itemName'] = itemName;
    data['dtlOnTraceTop'] = dtlOnTraceTop;
    data['dtlOnTraceBottom'] = dtlOnTraceBottom;
    data['tableNameTp'] = tableNameTp;
    data['dbName'] = dbName;
    data['dbSchema'] = dbSchema;
    return data;
  }
}

class DetailId {
  String? useCaseCd;
  String? useCaseName;
  List<TpList>? tpList;

  DetailId({this.useCaseCd, this.useCaseName, this.tpList});

  DetailId.fromJson(Map<String, dynamic> json) {
    useCaseCd = json['useCaseCd'];
    useCaseName = json['useCaseName'];
    if (json['tpList'] != null) {
      tpList = <TpList>[];
      json['tpList'].forEach((v) {
        tpList!.add(TpList.fromJson(v));
      });
    }
  }
}

class AttrTop {
  String? icon;
  String? title;
  String? value;

  AttrTop({this.icon, this.title, this.value});

  AttrTop.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['title'] = title;
    data['value'] = value;
    return data;
  }
}

class AttrBottom {
  String? icon;
  String? title;
  String? value;

  AttrBottom({this.icon, this.title, this.value});

  AttrBottom.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['title'] = title;
    data['value'] = value;
    return data;
  }
}

class TraceForm {
  String? useCaseCd;
  String? useCaseName;
  List<TpList>? tpList;

  TraceForm({this.useCaseCd, this.useCaseName, this.tpList});

  TraceForm.fromJson(Map<String, dynamic> json) {
    useCaseCd = json['useCaseCd'];
    useCaseName = json['useCaseName'];
    if (json['tpList'] != null) {
      tpList = <TpList>[];
      json['tpList'].forEach((v) {
        tpList!.add(TpList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['useCaseCd'] = useCaseCd;
    data['useCaseName'] = useCaseName;
    if (tpList != null) {
      data['tpList'] = tpList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TpList {
  int? rowNo;
  String? itemId;
  String? itemCd;
  String? pointCd;
  String? pointName;
  String? pointIconPath;
  String? iconBase64;
  bool? lastPointFlag;
  bool? passed;
  List<TpAttribute>? tpAttribute;

  TpList(
      {this.rowNo,
      this.itemId,
      this.itemCd,
      this.pointCd,
      this.pointName,
      this.lastPointFlag,
      this.tpAttribute});

  TpList.fromJson(Map<String, dynamic> json) {
    rowNo = json['rowNo'];
    itemId = json['itemId'];
    itemCd = json['itemCd'];
    pointCd = json['pointCd'];
    pointName = json['pointName'];
    pointIconPath = json['pointIconPath'];
    iconBase64 = json['iconBase64'];
    lastPointFlag = json['lastPointFlag'] ?? false;
    passed = json['passed'];
    if (json['tpAttribute'] != null) {
      tpAttribute = <TpAttribute>[];
      json['tpAttribute'].forEach((v) {
        tpAttribute!.add(TpAttribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rowNo'] = rowNo;
    data['itemId'] = itemId;
    data['itemCd'] = itemCd;
    data['pointCd'] = pointCd;
    data['pointName'] = pointName;
    data['pointIconPath'] = pointIconPath;
    data['iconBase64'] = iconBase64;
    data['lastPointFlag'] = lastPointFlag;
    if (tpAttribute != null) {
      data['tpAttribute'] = tpAttribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TpAttribute {
  String? attrNo;
  String? attrCd;
  String? attrName;
  String? attrValue;

  TpAttribute({this.attrNo, this.attrCd, this.attrName, this.attrValue});

  TpAttribute.fromJson(Map<String, dynamic> json) {
    attrNo = json['attrNo'];
    attrCd = json['attrCd'];
    attrName = json['attrName'];
    attrValue = json['attrValue'];
  }
  TpAttribute.map(Map<String, dynamic> obj) {
    attrNo = obj['attrNo'];
    attrCd = obj['attrCd'];
    attrName = obj['attrName'];
    attrValue = obj['attrValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attrNo'] = attrNo;
    data['attrCd'] = attrCd;
    data['attrName'] = attrName;
    data['attrValue'] = attrValue;
    return data;
  }
}

class ListId {
  int? no;
  String? itemId;

  ListId({this.no, this.itemId});

  ListId.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    itemId = json['itemId'];
  }
}

class TraceSearch {
  String? period;
  String? tpType;
  String? product;
  String? searchByKey;
  String? searchByValue;
  String? businessUeCase;
  String? blockchain;
  String? sortBy;
  String? itemCd;
  String? productionDateStart;
  String? productionDateEnd;

  TraceSearch(
      {this.period,
      this.tpType,
      this.product,
      this.searchByKey,
      this.businessUeCase,
      this.blockchain,
      this.sortBy,
      this.itemCd,
      this.searchByValue,
      this.productionDateEnd,
      this.productionDateStart});

  Map<String, String> toSearch() {
    final Map<String, String> data = <String, String>{};
    data['period'] = period ?? "";
    data['tpType'] = tpType ?? "ITEM";
    data['product'] = product ?? "";
    data['searchByKey'] = searchByKey ?? "item_id";
    data['searchByValue'] = searchByValue ?? "";
    data['businessUeCase'] = businessUeCase ?? "";
    data['blockchain'] = blockchain ?? "";
    data['sortBy'] = sortBy ?? "";
    data['itemCd'] = itemCd ?? "";
    data['productionDateStart'] = productionDateStart ?? "";
    data['productionDateEnd'] = productionDateEnd ?? "";
    return data;
  }
}
