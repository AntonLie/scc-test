class NewEditRole {
  int? pageNo;
  int? pageSize;
  int? totalDataInPage;
  int? totalData;
  int? totalPages;
  List<ListDataNewEditRole>? listData;

  NewEditRole(
      {this.pageNo,
      this.pageSize,
      this.totalDataInPage,
      this.totalData,
      this.totalPages,
      this.listData});

  NewEditRole.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalDataInPage = json['totalDataInPage'];
    totalData = json['totalData'];
    totalPages = json['totalPages'];
    if (json['listData'] != null) {
      listData = <ListDataNewEditRole>[];
      json['listData'].forEach((v) {
        listData!.add(ListDataNewEditRole.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNo'] = pageNo;
    data['pageSize'] = pageSize;
    data['totalDataInPage'] = totalDataInPage;
    data['totalData'] = totalData;
    data['totalPages'] = totalPages;
    if (listData != null) {
      data['listData'] = listData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListDataNewEditRole {
  int? no;
  String? roleCd;
  String? roleName;
  String? roleDesc;
  String? updatedLatest;

  ListDataNewEditRole(
      {this.no, this.roleCd, this.roleName, this.roleDesc, this.updatedLatest});

  ListDataNewEditRole.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    roleCd = json['roleCd'];
    roleName = json['roleName'];
    roleDesc = json['roleDesc'];
    updatedLatest = json['updatedLatest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['roleCd'] = roleCd;
    data['roleName'] = roleName;
    data['roleDesc'] = roleDesc;
    data['updatedLatest'] = updatedLatest;
    return data;
  }
}

class EditRoleForm {
  String? roleCd;
  String? roleName;
  String? roleDesc;
  List<ListMenuFeat>? listMenuFeat;

  EditRoleForm({this.roleCd, this.roleName, this.roleDesc, this.listMenuFeat});

  EditRoleForm.fromJson(Map<String, dynamic> json) {
    roleCd = json['roleCd'];
    roleName = json['roleName'];
    roleDesc = json['roleDesc'];
    if (json['listMenuFeat'] != null) {
      listMenuFeat = <ListMenuFeat>[];
      json['listMenuFeat'].forEach((v) {
        listMenuFeat!.add(ListMenuFeat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roleCd'] = roleCd;
    data['roleName'] = roleName;
    data['roleDesc'] = roleDesc;
    if (listMenuFeat != null) {
      data['listMenuFeat'] = listMenuFeat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListMenuFeat {
  String? menuCd;
  String? menuName;
  List<ListFeature>? listFeature;

  ListMenuFeat({this.menuCd, this.menuName, this.listFeature});

  ListMenuFeat.fromJson(Map<String, dynamic> json) {
    menuCd = json['menuCd'];
    menuName = json['menuName'];
    if (json['listFeature'] != null) {
      listFeature = <ListFeature>[];
      json['listFeature'].forEach((v) {
        listFeature!.add(ListFeature.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuCd'] = menuCd;
    data['menuName'] = menuName;
    if (listFeature != null) {
      data['listFeature'] = listFeature!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListFeature {
  String? featureCd;
  String? featureName;
  bool? featureFlag;

  ListFeature({this.featureCd, this.featureName, this.featureFlag});

  ListFeature.fromJson(Map<String, dynamic> json) {
    featureCd = json['featureCd'];
    featureName = json['featureName'];
    featureFlag = json['featureFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['featureCd'] = featureCd;
    data['featureName'] = featureName;
    data['featureFlag'] = featureFlag;
    return data;
  }
}

class ListMenuDropdown {
  String? menuCd;
  String? menuName;

  ListMenuDropdown({this.menuCd, this.menuName});

  ListMenuDropdown.fromJson(Map<String, dynamic> json) {
    menuCd = json['menuCd'];
    menuName = json['menuName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuCd'] = menuCd;
    data['menuName'] = menuName;
    return data;
  }
}
