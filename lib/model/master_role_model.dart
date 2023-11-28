// class ListMenuFeat {
//   String? menuCd;
//   String? menuName;
//   List<ListFeature>? listFeature;

//   ListMenuFeat({this.menuCd, this.menuName, this.listFeature});

//   ListMenuFeat.fromJson(Map<String, dynamic> json) {
//     menuCd = json['menuCd'];
//     menuName = json['menuName'];
//     if (json['listFeature'] != null) {
//       listFeature = <ListFeature>[];
//       json['listFeature'].forEach((v) {
//         listFeature!.add(ListFeature.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['menuCd'] = menuCd;
//     data['menuName'] = menuName;
//     if (listFeature != null) {
//       data['listFeature'] = listFeature!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class ListFeature {
//   String? featureCd;
//   String? featureName;
//   bool? featureFlag;

//   ListFeature({this.featureCd, this.featureName, this.featureFlag});

//   ListFeature.fromJson(Map<String, dynamic> json) {
//     featureCd = json['featureCd'];
//     featureName = json['featureName'];
//     featureFlag = json['featureFlag'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['featureCd'] = featureCd;
//     data['featureName'] = featureName;
//     data['featureFlag'] = featureFlag;
//     return data;
//   }
// }

// class EditRoleForm {
//   String? roleCd;
//   String? roleName;
//   String? roleDesc;
//   List<ListMenuFeat>? listMenuFeat;

//   EditRoleForm({this.roleCd, this.roleName, this.roleDesc, this.listMenuFeat});

//   EditRoleForm.fromJson(Map<String, dynamic> json) {
//     roleCd = json['roleCd'];
//     roleName = json['roleName'];
//     roleDesc = json['roleDesc'];
//     if (json['listMenuFeat'] != null) {
//       listMenuFeat = <ListMenuFeat>[];
//       json['listMenuFeat'].forEach((v) {
//         listMenuFeat!.add(ListMenuFeat.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['roleCd'] = roleCd;
//     data['roleName'] = roleName;
//     data['roleDesc'] = roleDesc;
//     if (listMenuFeat != null) {
//       data['listMenuFeat'] = listMenuFeat!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class ListDataNewEditRole {
//   int? no;
//   String? roleCd;
//   String? roleName;
//   String? roleDesc;
//   String? updatedLatest;

//   ListDataNewEditRole(
//       {this.no, this.roleCd, this.roleName, this.roleDesc, this.updatedLatest});

//   ListDataNewEditRole.fromJson(Map<String, dynamic> json) {
//     no = json['no'];
//     roleCd = json['roleCd'];
//     roleName = json['roleName'];
//     roleDesc = json['roleDesc'];
//     updatedLatest = json['updatedLatest'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['no'] = no;
//     data['roleCd'] = roleCd;
//     data['roleName'] = roleName;
//     data['roleDesc'] = roleDesc;
//     data['updatedLatest'] = updatedLatest;
//     return data;
//   }
// }
