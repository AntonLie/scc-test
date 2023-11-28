// ignore_for_file: unnecessary_question_mark, prefer_void_to_null

import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/theme/colors.dart';

class MasterRolee {
  bool? buttonSetting;
  List<MasterRole>? userList;

  MasterRolee({this.buttonSetting, this.userList});

  MasterRolee.fromJson(Map<String, dynamic> json) {
    buttonSetting = json['buttonSetting'];
    if (json['userList'] != null) {
      userList = <MasterRole>[];
      json['userList'].forEach((v) {
        userList!.add(new MasterRole.map(v));
      });
    }
  }
}

class MasterRole {
  bool? buttonSetting;
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  bool? deletedFlag;
  String? roleCd;
  String? roleName;
  String? roleDesc;
  bool? superAdminFlag;
  String? username;
  String? brand;
  String? companyCd;
  String? companyName;
  String? validFromDt;
  String? validToDt;
  String? email;
  String? dialCode;
  String? division;
  int? seq;
  List<RoleUser>? roleList;
  List<String>? selectedRoles;

  MasterRole({
    this.buttonSetting,
    this.seq,
    this.createdBy,
    this.createdDt,
    this.changedBy,
    this.changedDt,
    this.deletedFlag,
    this.roleCd,
    this.roleDesc,
    this.roleName,
    this.superAdminFlag,
    this.username,
    this.brand,
    this.dialCode,
    this.companyCd,
    this.companyName,
    this.validFromDt,
    this.validToDt,
    this.email,
    this.division,
    this.roleList,
    this.selectedRoles,
  });

  MasterRole.map(Map<String, dynamic> obj) {
    buttonSetting = obj['buttonSetting'];
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];
    roleCd = obj['roleCd'];
    roleDesc = obj['roleDesc'];
    roleName = obj['roleName'];
    superAdminFlag = obj['superAdminFlag'];
    seq = obj['seq'];
    username = obj['username'];
    brand = obj['brand'];
    companyCd = obj['companyCd'];
    companyName = obj['companyName'];
    validFromDt = obj['validFromDt'];
    validToDt = obj['validToDt'];
    email = obj['email'];
    division = obj['division'];
    roleList = [];
    if (obj['roleList'] is List) {
      for (var v in (obj['roleList'] as List)) {
        roleList!.add(RoleUser.map(v));
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['deletedFlag'] = deletedFlag;
    data['roleCd'] = roleCd;
    data['roleDesc'] = roleDesc;
    data['roleName'] = roleName;
    data['division'] = disabled;
    data['superAdminFlag'] = superAdminFlag;

    return data;
  }

  Map<String, dynamic> toSubmit() {
    Map<String, dynamic> data = {};
    data['roleList'] = selectedRoles ?? [];

    return data;
  }
}

class MasterRoleSubmit {
  Null? seq;
  String? username;
  String? validFromDt;
  String? validToDt;
  String? email;
  String? companyCd;
  String? companyName;
  String? confirmPassword;
  String? brand;
  String? password;
  String? dialCode;
  String? fullName;
  String? division;
  String? phoneNumber;
  int? phoneCode;
  int? countryId;
  List<String>? role;
  List<Role>? roleList;

  MasterRoleSubmit(
      {this.seq,
      this.username,
      this.validFromDt,
      this.validToDt,
      this.email,
      this.companyCd,
      this.companyName,
      this.brand,
      this.dialCode,
      this.password,
      this.fullName,
      this.division,
      this.phoneNumber,
      this.phoneCode,
      this.countryId,
      this.roleList});

  MasterRoleSubmit.fromJson(Map<String, dynamic> json) {
    seq = json['seq'];
    username = json['username'];
    validFromDt = json['validFromDt'];
    validToDt = json['validToDt'];
    email = json['email'];
    companyCd = json['companyCd'];
    companyName = json['companyName'];
    brand = json['brand'];
    password = json['password'];
    fullName = json['fullName'];
    division = json['division'];
    phoneNumber = json['phoneNumber'];
    phoneCode = json['phoneCode'];
    countryId = json['countryId'];
    if (json['role'] != null) {
      roleList = <Role>[];
      json['role'].forEach((v) {
        roleList!.add(Role.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toSubmit() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand'] = brand;
    data['companyCd'] = companyCd;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['fullName'] = fullName;
    data['division'] = division;
    data['phoneNumber'] = phoneNumber;
    data['dialCode'] = dialCode;
    data['phoneCode'] = phoneCode;
    data['countryId'] = countryId;
    data['role'] = role;
    return data;
  }
}

class RoleUser {
  String? username;
  String? roleCd;
  String? roleName;
  List<MenuFeature>? menuList;

  RoleUser({this.username, this.roleCd, this.roleName, this.menuList});

  RoleUser.map(Map<String, dynamic> obj) {
    username = obj['username'];
    roleCd = obj['roleCd'];
    roleName = obj['roleName'];
    menuList = [];
    if (obj['menuList'] is List) {
      for (var v in (obj['menuList'] as List)) {
        menuList!.add(MenuFeature.map(v));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['roleCd'] = roleCd;
    data['roleName'] = roleName;
    return data;
  }
}

class MenuFeature {
  int? no;
  String? menuCd;
  String? menuName;
  Map? menuFeatureList;

  MenuFeature({this.menuCd, this.menuName, this.no});

  MenuFeature.map(Map<String, dynamic> obj) {
    no = obj['no'];
    menuCd = obj['menuCd'];
    menuName = obj['menuName'];
    menuFeatureList =
        (obj['menuFeatureList'] != null) ? obj['menuFeatureList'] : {};
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuCd'] = menuCd;
    data['menuName'] = menuName;
    data['menuFeatureList'] = menuFeatureList;
    return data;
  }
}

class DataBrand {
  List<String>? listBrand;

  DataBrand({this.listBrand});

  DataBrand.fromJson(Map<String, dynamic> json) {
    listBrand = json['listBrand'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['listBrand'] = listBrand;
    return data;
  }
}

class DataCompany {
  String? companyCd;
  String? companyName;

  DataCompany({this.companyCd, this.companyName});

  DataCompany.map(Map<String, dynamic> obj) {
    companyCd = obj['companyCd'];
    companyName = obj['companyName'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['companyCd'] = companyCd;
    data['companyName'] = companyName;
    return data;
  }
}

class DataDivision {
  int? organId;
  String? positionName;
  String? division;

  DataDivision({this.organId, this.positionName, this.division});

  DataDivision.map(Map<String, dynamic> obj) {
    organId = obj['organId'];
    positionName = obj['positionName'];
    division = obj['division'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['organId'] = organId;
    data['positionName'] = positionName;
    data['division'] = division;
    return data;
  }
}

class DataPhone {
  int? countryId;
  String? iso;
  String? countryName;
  String? niceName;
  String? iso3;
  String? numCode;
  int? phoneCode;

  DataPhone(
      {this.countryId,
      this.iso,
      this.countryName,
      this.niceName,
      this.iso3,
      this.numCode,
      this.phoneCode});

  DataPhone.fromJson(Map<String, dynamic> json) {
    countryId = json['countryId'];
    iso = json['iso'];
    countryName = json['countryName'];
    niceName = json['niceName'];
    iso3 = json['iso3'];
    numCode = json['numCode'];
    phoneCode = json['phoneCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryId'] = countryId;
    data['iso'] = iso;
    data['countryName'] = countryName;
    data['niceName'] = niceName;
    data['iso3'] = iso3;
    data['numCode'] = numCode;
    data['phoneCode'] = phoneCode;
    return data;
  }
}
