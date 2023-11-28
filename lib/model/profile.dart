class Profile {
  String? companyCd;
  String? companyName;
  String? fullName;
  String? division;
  String? email;
  String? dialCode;
  String? phoneNo;
  String? base64;
  String? base64BE;
  String? filename;
  List<RoleList>? roleList;

  Profile(
      {this.companyCd,
      this.companyName,
      this.fullName,
      this.division,
      this.email,
      this.dialCode,
      this.phoneNo,
      this.base64,
      this.base64BE,
      this.filename,
      this.roleList});

  Profile.fromJson(Map<String, dynamic> json) {
    companyCd = json['companyCd'];
    companyName = json['companyName'];
    fullName = json['fullName'];
    division = json['division'];
    email = json['email'];
    dialCode = json['dialCode'];
    phoneNo = json['phoneNo'];
    base64 = json['base64'];
    filename = json['filename'];
    if (json['roleList'] != null) {
      roleList = <RoleList>[];
      json['roleList'].forEach((v) {
        roleList!.add(RoleList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyCd'] = companyCd;
    data['companyName'] = companyName;
    data['fullName'] = fullName;
    data['division'] = division;
    data['email'] = email;
    data['dialCode'] = dialCode;
    data['phoneNo'] = phoneNo;
    data['filename'] = filename;
    if (roleList != null) {
      data['roleList'] = roleList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toUpdate() {
    Map<String, dynamic> data = {};
    data['email'] = email;
    data['phoneNo'] = phoneNo;
    data['division'] = division;
    data['dialCode'] = dialCode;
    data['base64BE'] = base64BE;
    return data;
  }
}

class RoleList {
  String? roleCd;
  String? roleName;

  RoleList({this.roleCd, this.roleName});

  RoleList.fromJson(Map<String, dynamic> json) {
    roleCd = json['roleCd'];
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roleCd'] = roleCd;
    data['roleName'] = roleName;
    return data;
  }
}
