import 'package:scc_web/model/feature.dart';

class ParentMenu {
  String? menuCd;
  String? menuName;

  ParentMenu({this.menuCd, this.menuName});

  ParentMenu.map(Map<String, dynamic> obj) {
    menuCd = obj['menuCd'];
    menuName = obj['menuName'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['menuCd'] = menuCd;
    data['menuName'] = menuName;
    return data;
  }
}

class MenuModel {
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  bool? deletedFlag;
  String? menuCd;
  String? menuName;
  String? menuDesc;
  String? menuTypeCdStr;
  MenuTypeCd? menuTypeCd;
  int? menuSeq;
  int? no;
  List<Feature>? listFeature;
  String? parentMenuCd;
  String? menuTypeName;
  String? parentMenuName;
  List<MenuFunctionFeature>? menuFunctionFeature;
  List<String>? features;

  MenuModel(
      {this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.deletedFlag,
      this.menuCd,
      this.menuName,
      this.menuDesc,
      this.menuTypeCdStr,
      this.menuTypeCd,
      this.menuSeq,
      this.parentMenuCd,
      this.listFeature,
      this.features,
      this.no,
      this.menuFunctionFeature});

  MenuModel.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];
    menuCd = obj['menuCd'];
    menuName = obj['menuName'];
    menuDesc = obj['menuDesc'];
    menuTypeCd = obj['menuTypeCd'] != null
        ? MenuTypeCd.map(obj['menuTypeCd'])
        : null;
    menuTypeCdStr = (obj['menuTypeCd'] is String)
        ? obj['menuTypeCd']
        : menuTypeCd?.systemCd;
    menuSeq = obj['menuSeq'];
    no = obj['no'];
    menuTypeName = obj['menuTypeName'];
    parentMenuName = obj['parentMenuName'];
    parentMenuCd = obj['parentMenuCd'];
    listFeature = [];
    if (obj['listFeature'] is List) {
      for (var v in (obj['listFeature'] as List)) {
        listFeature!.add(Feature.map(v));
      }
    }
    menuFunctionFeature = [];
    if (obj['menuFunctionFeature'] is List) {
      for (var v in (obj['menuFunctionFeature'] as List)) {
        menuFunctionFeature!.add(MenuFunctionFeature.map(v));
      }
    }
  }

  Map<String, String> toSearch() {
    final Map<String, String> data = {};
    data['menuCd'] = menuCd ?? "";
    data['menuName'] = menuName ?? "";
    data['parentMenuCd'] = parentMenuCd ?? "";
    return data;
  }

  Map<String, dynamic> toSubmit() {
    final Map<String, dynamic> data = {};
    data['menuCd'] = menuCd;
    data['menuName'] = menuName;
    data['menuDesc'] = menuDesc;
    data['menuTypeCd'] = menuTypeCdStr;
    data['menuSeq'] = menuSeq;
    data['parentMenuCd'] = parentMenuCd;
    if (menuFunctionFeature != null) {
      data['menuFunctionFeatureList'] =
          menuFunctionFeature!.map((v) => v.toSubmit()).toList();
    }
    return data;
  }

  Map<String, dynamic> toUpdate() {
    final Map<String, dynamic> data = {};
    data['features'] = features ?? [];
    return data;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['deletedFlag'] = deletedFlag;
    data['menuCd'] = menuCd;
    data['menuName'] = menuName;
    data['menuDesc'] = menuDesc;
    data['menuTypeName'] = menuTypeName;
    data['parentMenuName'] = parentMenuName;
    if (menuTypeCd != null) {
      data['menuTypeCd'] = menuTypeCd!.toMap();
    }
    data['menuSeq'] = menuSeq;
    data['parentMenuCd'] = parentMenuCd;
    if (menuFunctionFeature != null) {
      data['menuFunctionFeature'] =
          menuFunctionFeature!.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

class MenuTypeCd {
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  bool? deletedFlag;
  String? systemCd;
  String? company;
  String? systemValue;
  int? systemSeq;
  String? systemDesc;

  MenuTypeCd(
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

  MenuTypeCd.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];
    systemCd = obj['systemCd'];
    company = obj['company'];
    systemValue = obj['systemValue'];
    systemSeq = obj['systemSeq'];
    systemDesc = obj['systemDesc'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
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

class MenuFunctionFeature {
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  bool? deletedFlag;
  String? menuCd;
  String? functionCd;
  String? featureCd;

  MenuFunctionFeature(
      {this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.deletedFlag,
      this.menuCd,
      this.functionCd,
      this.featureCd});

  MenuFunctionFeature.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];
    menuCd = obj['menuCd'];
    functionCd = obj['functionCd'];
    featureCd = obj['featureCd'];
  }

  Map<String, dynamic> toSubmit() {
    final Map<String, dynamic> data = {};
    data['functionCd'] = functionCd;
    data['featureCd'] = featureCd;
    return data;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['deletedFlag'] = deletedFlag;
    data['menuCd'] = menuCd;
    data['functionCd'] = functionCd;
    data['featureCd'] = featureCd;
    return data;
  }
}
