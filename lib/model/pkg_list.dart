class PackageList {
  int? no;
  String? packageName;
  String? subscribers;
  String? packageCd;
  String? createdDt;
  String? pricePackage;
  String? createdBy;
  String? changedBy;
  String? changedDt;

  PackageList(
      {this.no,
      this.packageName,
      this.subscribers,
      this.packageCd,
      this.createdDt,
      this.pricePackage,
      this.createdBy,
      this.changedBy,
      this.changedDt});

  PackageList.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    packageName = json['packageName'];
    subscribers = json['subscribers'];
    packageCd = json['packageCd'];
    createdDt = json['createdDt'];
    pricePackage = json['pricePackage'];
    createdBy = json['createdBy'];
    changedBy = json['changedBy'];
    changedDt = json['changedDt'];
  }
}

class PackageData {
  int? packageCd;
  String? packageName;
  int? totalSupplier;
  int? totalAccount;
  List<Role>? role;
  int? totalPoint;
  int? totalPart;
  bool? statusBlockchain;
  int? gasFee;
  String? colorCd;
  List<PackageInfo>? packageInfo;
  int? pricePackage;
  String? packageDesc;

  PackageData(
      {this.packageCd,
      this.packageName,
      this.totalSupplier,
      this.totalAccount,
      this.role,
      this.totalPoint,
      this.totalPart,
      this.statusBlockchain,
      this.gasFee,
      this.colorCd,
      this.packageInfo,
      this.pricePackage,
      this.packageDesc});

  PackageData.fromJson(Map<String, dynamic> json) {
    packageCd = json['packageCd'];
    packageName = json['packageName'];
    totalSupplier = json['totalSupplier'];
    totalAccount = json['totalAccount'];
    if (json['role'] != null) {
      role = <Role>[];
      json['role'].forEach((v) {
        role!.add(Role.fromJson(v));
      });
    }
    totalPoint = json['totalPoint'];
    totalPart = json['totalPart'];
    statusBlockchain = json['statusBlockchain'];
    gasFee = json['gasFee'];
    colorCd = json['colorCd'];
    if (json['packageInfo'] != null) {
      packageInfo = <PackageInfo>[];
      json['packageInfo'].forEach((v) {
        packageInfo!.add(PackageInfo.fromJson(v));
      });
    }
    pricePackage = json['pricePackage'];
    packageDesc = json['packageDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['packageCd'] = packageCd;
    data['packageName'] = packageName;
    data['totalSupplier'] = totalSupplier;
    data['totalAccount'] = totalAccount;
    if (role != null) {
      data['role'] = role!.map((v) => v.toJson()).toList();
    }
    data['totalPoint'] = totalPoint;
    data['totalPart'] = totalPart;
    data['statusBlockchain'] = statusBlockchain;
    data['gasFee'] = gasFee;
    data['colorCd'] = colorCd;
    if (packageInfo != null) {
      data['packageInfo'] = packageInfo!.map((v) => v.toJson()).toList();
    }
    data['pricePackage'] = pricePackage;
    data['packageDesc'] = packageDesc;
    return data;
  }
}

class Role {
  String? roleCd;

  Role({this.roleCd});

  Role.fromJson(Map<String, dynamic> json) {
    roleCd = json['roleCd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roleCd'] = roleCd;
    return data;
  }
}

class PackageInfo {
  String? packageInfo;
  String? packageInfoDesc;

  PackageInfo({this.packageInfo, this.packageInfoDesc});

  PackageInfo.fromJson(Map<String, dynamic> json) {
    packageInfo = json['packageInfo'];
    packageInfoDesc = json['packageInfoDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['packageInfo'] = packageInfo;
    data['packageInfoDesc'] = packageInfoDesc;
    return data;
  }
}

class StyleColour {
  String? colorCd;
  String? colorName;

  StyleColour({this.colorCd, this.colorName});

  StyleColour.fromJson(Map<String, dynamic> obj) {
    colorCd = obj['colorCd'];
    colorName = obj['colorName'];
  }
}

class Contacted {
  String? companyCd;
  String? companyName;
  int? packageCd;
  String? packageName;
  String? userName;
  String? fullName;
  String? email;
  int? countryId;
  String? dialCode;
  String? phoneNumber;
  String? packageTime;

  Contacted(
      {this.companyCd,
      this.companyName,
      this.packageCd,
      this.packageName,
      this.userName,
      this.fullName,
      this.email,
      this.countryId,
      this.dialCode,
      this.phoneNumber,
      this.packageTime});

  Contacted.fromJson(Map<String, dynamic> json) {
    companyCd = json['companyCd'];
    companyName = json['companyName'];
    packageCd = json['packageCd'];
    packageName = json['packageName'];
    userName = json['userName'];
    fullName = json['fullName'];
    email = json['email'];
    countryId = json['countryId'];
    dialCode = json['dialCode'];
    phoneNumber = json['phoneNumber'];
    packageTime = json['packageTime'];
  }
}
