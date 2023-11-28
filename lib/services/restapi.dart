import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/services/api_url.dart';
import 'package:scc_web/mock/detail_transaction.dart';
import 'package:scc_web/mock/transaction.dart';
import 'package:scc_web/services/net_util.dart';

class RestApi extends UrlAPI {
  final NetworkUtil _util = NetworkUtil();

  Future<dynamic> teksImage(
      {Map<String, String>? headers, Map<String, String>? param}) {
    return _util
        .get(
      "$sccSubscription/request/teks-image",
      // "$sccSubscription/request/teks-image",
      param: param,
      headers: headers,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];

      return value['data'];
    });
  }

  Future<dynamic> teksCard(
      {Map<String, String>? headers, Map<String, String>? param}) {
    return _util
        .get(
      "$sccSubscription/request/teks-card",
      param: param,
      headers: headers,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];

      return value['data'];
    });
  }

  Future<dynamic> login(
      {Map<String, dynamic>? body, Map<String, String>? param}) {
    return _util
        .post(
      "$sccIdentity/login",
      body: body,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];

      return value['data'];
    });
  }

  Future<dynamic> permittedMenu(
      {Map<String, String>? headers, Map<String, String>? param}) {
    return _util
        .get(
      "$sccUserMgmt/role/permitted-menu",
      param: param,
      headers: headers,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];

      return value['data'];
    });
  }

  Future<dynamic> logout(
      {Map<String, String>? header,
      Map<String, dynamic>? body,
      Map<String, String>? param}) {
    return _util
        .post(
      "$sccIdentity/logout",
      headers: header,
      body: body,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> refreshToken(
      {Map<String, dynamic>? body, Map<String, String>? param}) {
    return _util
        .post(
      "$sccIdentity/refresh-token",
      body: body,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getPricing({
    Map<String, String>? header,
    Map<String, String>? param,
  }) {
    return _util
        .get(
      "$sccSubscription/request/pricing",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];

      return value['data'];
    });
  }

  Future<dynamic> getPackageType({
    Map<String, String>? header,
    Map<String, String>? param,
  }) {
    return _util
        .get(
      "$sccSubscription/request/package-types",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];

      return value['data'];
    });
  }

  Future<dynamic> getSystemDropdown(
      {Map<String, String>? header, Map<String, String>? params}) {
    return _util
        .get(
      "$sccSubscription/request/system",
      param: params,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getCountry({
    Map<String, String>? header,
    Map<String, String>? param,
  }) {
    return _util
        .get(
      "$sccSubscription/request/countries",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];

      return value['data'];
    });
  }

  Future<dynamic> submitContact(
      {Map<String, String>? header,
      Map<String, dynamic>? body,
      Map<String, String>? param}) {
    return _util
        .post(
      "$sccSubscription/subscription/contact-admin",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getSubsFeatures({
    Map<String, String>? header,
    Map<String, String>? param,
  }) {
    return _util
        .get(
      "$sccSubscription/request/compared-features",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchSystemMaster(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterMain/system",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getPackageColor(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccSubscription/package/color",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getPackageBlock(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccSubscription/package/blockchain",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getRoleAll(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccSubscription/package/role",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchMasterParentMenu(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccUserMgmt/menu/parent-menu",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchMenuFeat(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccUserMgmt/menu-feat",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getMenuFeat(String menuCd,
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccUserMgmt/menu-feat/$menuCd",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> updateMenuFeat(String menuCd,
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, dynamic>? body}) {
    return _util
        .put(
      "$sccUserMgmt/menu-feat/$menuCd",
      headers: header,
      param: param,
      body: body,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getMasterMenu(
    String method,
    String url, {
    required String menuCd,
    Map<String, String>? header,
  }) {
    return _util
        .freeReq(
      method,
      url.isEmpty ? "$sccUserMgmt/menu/$menuCd" : "$baseUrl$url/$menuCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> createMasterMenu(
    String method,
    String url, {
    Map<String, String>? header,
    Map<String, String>? param,
    Map<String, dynamic>? body,
  }) {
    return _util
        .freeReq(
      method,
      url.isEmpty ? "$sccUserMgmt/menu" : baseUrl + url,
      body: body,
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> editMasterMenu(
    String method,
    String url, {
    Map<String, String>? header,
    Map<String, String>? param,
    Map<String, dynamic>? body,
    required String menuCd,
  }) {
    return _util
        .freeReq(
      method,
      url.isEmpty ? "$sccUserMgmt/menu/$menuCd" : "$baseUrl$url/$menuCd",
      body: body,
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> deleteMasterMenu(
    String method,
    String url, {
    Map<String, String>? header,
    Map<String, String>? param,
    required String menuCd,
  }) {
    return _util
        .freeReq(
      method,
      url.isEmpty ? "$sccUserMgmt/menu/$menuCd" : "$baseUrl$url/$menuCd",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> searchMasterMenu(String method, String url,
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccUserMgmt/menu-feat",

      //   .freeReq(
      // method,
      // url.isEmpty
      //     ? "$sccUserMgmt/menu-feat"
      //     : baseUrl + url,
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> submitUserRole({
    String? username,
    String? validFrom,
    Map<String, String>? header,
    Map<String, dynamic>? body,
  }) {
    return _util
        .put(
      "$sccUserMgmt/user-role/role/$username::$validFrom",
      headers: header,
      body: body,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> deleteUserRole(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param,
      required String usernameRole,
      required String validFromDt}) {
    return _util
        //     .freeReq(
        //   method,
        //   (url.isEmpty ? (vccUserMgmt + "/user-role") : (baseUrl + url)) + '/$username::$validFrom',
        //   param: param,
        //   headers: header,
        // )
        .delete(
      "$sccUserMgmt/user-role/$usernameRole::$validFromDt",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> getUserRole(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param,
      required String username,
      required String companyCd}) {
    return _util
        .get(
      "$sccUserMgmt/user-role/get-for-edit/$username::$companyCd",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getMenuList({
    String? roleCd,
    Map<String, String>? header,
  }) {
    return _util
        .get(
      "$sccUserMgmt/user-role/role-menu-feature/$roleCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> createMasterRole(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, dynamic>? body}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccUserMgmt + "/role" : baseUrl + url,
        //   body: body,
        //   param: param,
        //   headers: header,
        // )
        .post(
      "$sccUserMgmt/user-role/add",
      body: body,
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> updateMasterRole(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, dynamic>? body,
      required String username,
      required String validFrom}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccUserMgmt + "/role/$roleCd" : baseUrl + url + "/$roleCd",
        //   body: body,
        //   param: param,
        //   headers: header,
        // )
        .put(
      "$sccUserMgmt/user-role/edit/$username::$validFrom",
      body: body,
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> searchMasterRole(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccUserMgmt + "/role" : baseUrl + url,
        //   headers: header,
        //   param: param,
        // )
        .get(
      "$sccUserMgmt/role",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchUserRole(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccUserMgmt + "/user-role" : baseUrl + url,
        //   headers: header,
        //   param: param,
        // )
        .get(
      "$sccUserMgmt/user-role",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> deleteNewEditRole(
      {Map<String, String>? header,
      Map<String, String>? param,
      required String roleCd}) {
    return _util
        .delete(
      "$sccUserMgmt/role-menu-feat/delete/$roleCd",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> searchNewEditRole(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccUserMgmt/role-menu-feat/search",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getListMenu(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccUserMgmt/role-menu-feat/get-menu",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getRoleData({
    Map<String, String>? header,
    String? roleCd,
  }) {
    return _util
        .get(
      "$sccUserMgmt/role-menu-feat/get/$roleCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getListFeatD({
    Map<String, String>? header,
    String? menuCd,
  }) {
    return _util
        .get(
      "$sccUserMgmt/role-menu-feat/get-list-feat/$menuCd",
      headers: header,
    )
        .then((value) {
      return value['data'];
    });
  }

  Future<dynamic> addNewEditRole(
      // String method,
      // String url,
      {
    Map<String, String>? header,
    Map<String, String>? param,
    Map<String, dynamic>? body,
  }) {
    return _util
        .post(
      "$sccUserMgmt/role-menu-feat",
      body: body,
      headers: header,
      param: param,
    )
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/point" : baseUrl + url,
        //   body: body,
        //   param: param,
        //   headers: header,
        // )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> editNewEditRole(
      // String method,
      // String url,
      {
    Map<String, String>? header,
    Map<String, String>? param,
    Map<String, dynamic>? body,
    required String roleCd,
  }) {
    return _util
        //   .freeReq(
        // method,
        // url.isEmpty ? vccMaster + "/point/$pointCd" : baseUrl + url + "/$pointCd",
        .put(
      "$sccUserMgmt/role-menu-feat/$roleCd",
      body: body,
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> customUrlGet(
      {required String url,
      Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        .get(
      url,
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getSubsDataTable(
      {Map<String, String>? header, Map<String, String>? params}) {
    return _util
        .get(
      "$sccSubscription/package/search",
      headers: header,
      param: params,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  // GET DATA SUBS
  Future<dynamic> getDataPackage({
    int? pkgCd,
    Map<String, String>? header,
  }) {
    return _util
        .get(
      "$sccSubscription/package/view/$pkgCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  // EDIT & CREATE DATA SUBS
  Future<dynamic> createPackageList({
    Map<String, String>? header,
    Map<String, String>? param,
    Map<String, dynamic>? body,
  }) {
    return _util
        .post(
      "$sccSubscription/package/create",
      body: body,
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> updatePackageList({
    Map<String, String>? header,
    Map<String, String>? param,
    Map<String, dynamic>? body,
  }) {
    return _util
        .post(
      "$sccSubscription/package/update",
      body: body,
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  // DELETE DATA SUBS
  Future<dynamic> deletePakageList(
      {Map<String, String>? header,
      Map<String, String>? param,
      required int pckCd}) {
    return _util
        .delete(
      "$sccSubscription/package/delete/$pckCd",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> searchBrand({Map<String, String>? header}) {
    return _util
        .get(
      "$sccUserMgmt/user-role/brand",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchCompany(
      // String method,
      // String url,
      {Map<String, String>? header}) {
    return _util
        .get(
      "$sccUserMgmt/user-role/company",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      // print("data");
      // return value;
      // return value['data'];
      return value['data'];
    });
  }

  Future<dynamic> searchDivision(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterMain/organization/search",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      // print(value.toString());
      return value['data'];
    });
  }

  Future<dynamic> deleteMstAttr(
      // String method,
      // String url,
      {
    Map<String, String>? header,
    Map<String, String>? param,
    required String attributeCd,
  }) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/attribute/$attributeCd" : baseUrl + url + "/$attributeCd",
        //   param: param,
        //   headers: header,
        // )
        .delete(
      "$sccMasterProduct/attribute/delete/$attributeCd",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> searchMstAttr(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/attribute" : baseUrl + url,
        //   headers: header,
        //   param: param,
        // )
        .get(
      "$sccMasterProduct/attribute/search",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      // print(value['data']);
      return value['data'];
    });
  }

  Future<dynamic> getMstAttr(
      // method,
      // url,
      {
    required String attributeCd,
    Map<String, String>? header,
  }) {
    return _util
        .get(
      "$sccMasterProduct/attribute/get/$attributeCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> createMstAttr(String createMethod, //String url,
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, String>? body}) {
    return _util
        .multipartOneFile(
      createMethod,
      "$sccMasterProduct/attribute/save",
      body: body,
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> updateMstAttr(
    String updateMethod, {
    Map<String, String>? header,
    Map<String, String>? param,
    Map<String, String>? body,
    required String attributeCd,
  }) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/attribute/$attributeCd" : baseUrl + url + "/$attributeCd",
        //   body: body,
        //   param: param,
        //   headers: header,
        // )
        .multipartOneFile(
      updateMethod,
      "$sccMasterProduct/attribute/update/$attributeCd",
      body: body,
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> searchTemplAttr(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute" : baseUrl + url,
        //   headers: header,
        //   param: param,
        // )
        .get(
      "$sccMasterProduct/template/search",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> viewFullTemplateAttr(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute" : baseUrl + url,
        //   headers: header,
        //   param: param,
        // )
        .get(
      "$sccMasterProduct/attribute/searchAttrPoint",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getTmplAttr(
      // String method,
      // String url,
      {
    String? tempAttrCd,
    Map<String, String>? header,
  }) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute/$tmplAttrCd" : baseUrl + url + "/$tmplAttrCd",
        //   headers: header,
        // )
        .get(
      "$sccMasterProduct/template/get/$tempAttrCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchAttribute(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/attribute/search",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> deleteTmplAttr(
      // String method,
      // String url,
      {
    String? attrCd,
    Map<String, String>? header,
  }) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute/$attrCd" : baseUrl + url + '/$attrCd',
        //   headers: header,
        // )
        .delete(
      "$sccMasterProduct/template/deleted/$attrCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> updateTmplAttr(
      // String method, String url,
      {String? tmplAttrCd,
      Map<String, String>? header,
      Map<String, dynamic>? body}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute/$tmplAttrCd" : baseUrl + url + '/$tmplAttrCd',
        //   body: body,
        //   headers: header,
        // )
        .put(
      "$sccMasterProduct/template/update/$tmplAttrCd",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> addTmplAttr(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, dynamic>? body}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute" : baseUrl + url,
        //   body: body,
        //   headers: header,
        // )
        .post(
      "$sccMasterProduct/template/save",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchMstSupplier(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterMain/supplier/searchSupp",
      headers: header,
      param: param,
    )
        .then((value) {
      // print(value);
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      // print(value['data']);
      return value['data'];
    });
  }

  Future<dynamic> getSupplier(
      // String method,
      // String url,
      {
    String? supplierCd,
    Map<String, String>? header,
  }) {
    return _util
        .get(
      "$sccMasterMain/supplier/view/$supplierCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> updateMstSupplier(
      //String createMethod, //String url,
      {Map<String, String>? header,
      Map<String, dynamic>? body}) {
    return _util
        .put(
      "$sccMasterMain/supplier/update",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> deleteMstSupplier(
      // String method,
      // String url,
      {
    Map<String, String>? header,
    Map<String, String>? param,
    required String supplierCd,
  }) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/attribute/$attributeCd" : baseUrl + url + "/$attributeCd",
        //   param: param,
        //   headers: header,
        // )
        .delete(
      "$sccMasterMain/supplier/delete/$supplierCd",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> getMstSupplier(
      // method,
      // url,
      {
    required String supplierCd,
    Map<String, String>? header,
  }) {
    return _util
        .get(
      "$sccMasterMain/supplier/view/$supplierCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getGasFee(
      {Map<String, String>? header, Map<String, String>? params}) {
    return _util
        .get(
      "$sccSubscription/subscribers/card",
      headers: header,
      param: params,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getSubrDataTable(
      {Map<String, String>? header, Map<String, String>? params}) {
    return _util
        .get(
      "$sccSubscription/subscribers/search",
      headers: header,
      param: params,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];

      return value['data'];
    });
  }

  Future<dynamic> addMstSupplier(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, dynamic>? body}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute" : baseUrl + url,
        //   body: body,
        //   headers: header,
        // )
        .post(
      "$sccMasterMain/supplier/create-supplier",
      headers: header,
      body: body,
    );
  }

  Future<dynamic> getSubsCreate({
    String? companyCd,
    int? packageCd,
    Map<String, String>? header,
  }) {
    return _util
        .get(
      "$sccSubscription/subscribers/get-data/create/$companyCd::$packageCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getSubsEdit({
    String? companyCd,
    int? packageCd,
    Map<String, String>? header,
  }) {
    return _util
        .get(
      "$sccSubscription/subscribers/get-data/edit/$companyCd::$packageCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getSubsView({
    String? companyCd,
    int? packageCd,
    Map<String, String>? header,
  }) {
    return _util
        .get(
      "$sccSubscription/subscribers/get-data/view/$companyCd::$packageCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> subsCreate({
    Map<String, String>? header,
    Map<String, dynamic>? body,
  }) {
    return _util
        .post(
      "$sccSubscription/subscribers/create",
      headers: header,
      body: body,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> subsEdit({
    String? companyCd,
    int? packageCd,
    Map<String, String>? header,
    Map<String, dynamic>? body,
  }) {
    return _util
        .put(
      "$sccSubscription/subscribers/edit/$companyCd::$packageCd",
      headers: header,
      body: body,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> subsNotif({
    String? companyCd,
    int? packageCd,
    Map<String, String>? header,
    Map<String, dynamic>? body,
  }) {
    return _util
        .post(
      "$sccSubscription/subscribers/notif/$companyCd::$packageCd",
      headers: header,
      body: body,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> searchPoint(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/point/search",
      headers: header,
      param: param,
    )
        .then((value) {
      // print(value);
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> deleteMasterProduct({
    Map<String, String>? header,
    Map<String, String>? param,
    required String productCd,
  }) {
    return _util
        .delete(
      "$sccMasterProduct/product/delete/$productCd",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> getMstProduct(
      // method,
      // url,
      {
    required String productCd,
    Map<String, String>? header,
  }) {
    return _util
        .get(
      "$sccMasterProduct/product/view/$productCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      // print(value['data']);
      return value['data'];
    });
  }

  Future<dynamic> updateMstProduct(String createMethod, //String url,
      {Map<String, String>? header,
      required String? productCd,
      Map<String, dynamic>? body}) {
    return _util
        .put(
      "$sccMasterProduct/product/update/$productCd",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> addMstProduct(String createMethod, //String url,
      {Map<String, String>? header,
      Map<String, dynamic>? body}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute" : baseUrl + url,
        //   body: body,
        //   headers: header,
        // )
        .post(
      "$sccMasterProduct/product/create",
      body: body,
      headers: header,
    );
  }

  Future<dynamic> getProductDataTable(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/product/search",
      headers: header,
      param: param,
    )
        .then((value) {
      // print(value);
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> pointView({Map<String, String>? header, String? pointCd}) {
    return _util
        .get(
      "$sccMasterProduct/point/view/$pointCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> jsonView({Map<String, String>? header, String? pointCd}) {
    return _util
        .get(
      "$sccMasterProduct/point/get-json/$pointCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getType(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/point/get-type",
      headers: header,
      param: param,
    )
        .then((value) {
      // print(value);
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> savePoint(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, dynamic>? body}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute" : baseUrl + url,
        //   body: body,
        //   headers: header,
        // )
        .post(
      "$sccMasterProduct/point/save",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> editPoint(
      // String method, String url,

      {Map<String, String>? header,
      String? pointCd,
      Map<String, dynamic>? body}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute" : baseUrl + url,
        //   body: body,
        //   headers: header,
        // )
        .put(
      "$sccMasterProduct/point/update/$pointCd",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> deleteMstPoint(
      // String method, String url,
      {
    Map<String, String>? header,
    Map<String, String>? param,
    required String pointCd,
  }) {
    return _util
        //     .freeReq(
        //   method,
        //   (url.isEmpty ? (vccUserMgmt + "/user-role") : (baseUrl + url)) + '/$username::$validFrom',
        //   param: param,
        //   headers: header,
        // )
        .delete(
      "$sccMasterProduct/point/delete/$pointCd",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  // use case

  Future<dynamic> searchUseCase(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/usecase/search",
      headers: header,
      param: param,
    )
        .then((value) {
      // print(value);
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getMstItemDataTable(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/assignMasterItem/search",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      // print(value);
      return value['data'];
    });
  }

  Future<dynamic> getDetailTransactionTable(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) async {
    if (param?['pageNo'] == "2") {
      return responseDetailTransactionPage2['data'];
    }

    return responseDetailTransaction['data'];

    return _util
        .get(
      "$sccDashboard/detail-transaction/search",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      // print(value['data']);
      return value['data'];
    });
  }

  Future<dynamic> getTransactionTable(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) async {
    return responseTransaction['data'];

    // return _util
    //     .get(
    //   "$sccDashboard/transaction/search",
    //   headers: header,
    //   param: param,
    // )
    //     .then((value) {
    //   if (value['status'] != Constant.statusSuccess) throw value['message'];
    //   // print(value['data']);
    //   return value['data'];
    // });
  }

  Future<dynamic> viewUseCase(
      {Map<String, String>? header, String? useCaseCd}) {
    return _util
        .get(
      "$sccMasterProduct/usecase/view/$useCaseCd",
      headers: header,
    )
        .then((value) {
      // print(value);
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> deleteUseCase(
      // String method, String url,
      {
    Map<String, String>? header,
    Map<String, String>? param,
    required String useCaseCd,
  }) {
    return _util
        //     .freeReq(
        //   method,
        //   (url.isEmpty ? (vccUserMgmt + "/user-role") : (baseUrl + url)) + '/$username::$validFrom',
        //   param: param,
        //   headers: header,
        // )
        .delete(
      "$sccMasterProduct/usecase/deleted/$useCaseCd",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value;
    });
  }

  Future<dynamic> saveUseCase(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, dynamic>? body}) {
    return _util
        //     .freeReq(
        //   method,
        //   url.isEmpty ? vccMaster + "/temp-attribute" : baseUrl + url,
        //   body: body,
        //   headers: header,
        // )
        .post(
      "$sccMasterProduct/usecase/save",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> editUseCase(
      // String method, String url,

      {Map<String, String>? header,
      String? useCaseCd,
      Map<String, dynamic>? body}) {
    return _util
        .put(
      "$sccMasterProduct/usecase/update/$useCaseCd",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> addMstItem(
      {Map<String, String>? header, Map<String, dynamic>? body}) {
    return _util
        .put(
      "$sccMasterProduct/assignMasterItem/createUpdate",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getMstItemView(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/assignMasterItem/viewEdit",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      // print(value['data']);
      return value['data'];
    });
  }

  Future<dynamic> viewApproval(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get("$sccMasterProduct/approvalMasterItem/view",
            headers: header, param: param)
        .then((value) {
      // print(value);
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchApproval(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/approvalMasterItem/search",
      headers: header,
      param: param,
    )
        .then((value) {
      // print(value);
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> submitApproval(
      {Map<String, String>? header, Map<String, dynamic>? body}) {
    return _util
        .put(
      "$sccMasterProduct/approvalMasterItem/approvalReject",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getPermittdFeat({
    String? menuCd,
    Map<String, String>? header,
  }) {
    return _util
        .get(
      "$sccUserMgmt/permitted-feat/$menuCd",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> downloadTemplateItem(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/item-batch/download-template-master-item",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> downloadTemplateMaterial(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/Upload-Bill-Master/download-tamplate",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchCompanyAgent(
      // String method,
      // String url,
      {Map<String, String>? header}) {
    return _util
        .get(
      "$sccMonitor/mon_agent/allCompanyTenant",
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];

      return value['data'];
    });
  }

  Future<dynamic> getAgentDataTable(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        .get(
      "$sccMonitor/mon_agent/agent",
      headers: header,
      param: param,
    )
        .then((value) {
      // print(value);
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchAgentTp(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMonitor/mon_agent/tpAgent",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> uploadMstItem(
      // String method, String url,
      {Map<String, String>? header,
      // Map<String, String>? param,
      Map<String, dynamic>? body}) {
    return _util.post(
      "$sccMasterProduct/item-batch/item-upload",
      headers: header,
      body: body,
    );
  }

  Future<dynamic> uploadBillMaterial(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, dynamic>? body}) {
    return _util.post(
      "$sccMasterProduct/Upload-Bill-Master/upload-bill-item",
      headers: header,
      body: body,
    );
  }

  Future<dynamic> getProductName(
      // String method, String url,
      {Map<String, String>? header,
      Map<String, String>? param}) {
    return _util
        .get(
      "$sccMasterProduct/Upload-Bill-Master/get-item-name",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchAllLog(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMonitor/log/logging-succes-and-fail",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchFailLog(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMonitor/log/logging-fail",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchLog(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMonitor/log",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchLogDtl(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMonitor/log/detail",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> searchLogDtlProcessId(String processId,
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMonitor/log/detail/$processId",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> checkLog(String processId,
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .put(
      "$sccMonitor/log/$processId",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> downloadLogDetail(String processId,
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccMonitor/log/detail-download/$processId",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getContact({
    Map<String, String>? header,
    final int? packageCd,
    Map<String, String>? param,
  }) {
    return _util
        .get(
      "$sccSubscription/subscription/get-contact-admin/$packageCd",
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];

      return value['data'];
    });
  }

  // Traceability
  Future<dynamic> searchTraceability(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccDashboard/traceabilityController/search",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> dropdownUseCase(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccDashboard/traceabilityController/getUseCase",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> dropdownTouchPoint(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccDashboard/traceabilityController/getTouchPoint",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> dropdownKey(
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, String>? body}) {
    return _util
        .post(
      "$sccDashboard/traceabilityController/getKey",
      headers: header,
      body: body,
    )
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getItemIdList(
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, String>? body}) {
    return _util
        .post("$sccDashboard/traceabilityController/getItemIdList",
            body: body, headers: header)
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getItemIdDetail(
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, String>? body}) {
    return _util
        .post("$sccDashboard/traceabilityController/getItemIdDetail",
            body: body, headers: header)
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getContainerFormConsume(
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, String>? body}) {
    return _util
        .post("$sccDashboard/traceabilityController/getDataChildAttributeTrace",
            body: body, headers: header)
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getContainerForm(
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, String>? body}) {
    return _util
        .post("$sccDashboard/traceabilityController/getDataAttributeTrace",
            body: body, headers: header)
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getDetailList(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .post("$sccDashboard/traceabilityController/getItemIdDetail",
            headers: header, param: param)
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getConsumeList(
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, String>? body}) {
    return _util
        .post("$sccDashboard/traceabilityController/searchConsume",
            headers: header, body: body)
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getAttributeList(
      {Map<String, String>? header, Map<String, String>? body}) {
    return _util
        .post("$sccDashboard/traceabilityController/getTpAttributeList",
            headers: header, body: body)
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getProduct(
      {Map<String, String>? header, Map<String, dynamic>? body}) {
    return _util
        .post("$sccDashboard/traceabilityController/getProduct",
            body: body, headers: header)
        .then((value) {
      if (value['status'] != Constant.statusSuccess) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getProfile(
      {Map<String, String>? header, Map<String, String>? param}) {
    return _util
        .get(
      "$sccUserMgmt/user-profile/getProfile",
      headers: header,
      param: param,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> updateProfile(
      {Map<String, String>? header,
      Map<String, String>? param,
      Map<String, dynamic>? body}) {
    return _util
        .put(
      "$sccUserMgmt/user-profile/update",
      body: body,
      param: param,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value;
    });
  }

  Future<dynamic> updatePassword(
      {Map<String, String>? header, Map<String, dynamic>? body}) {
    return _util
        .put(
      "$sccUserMgmt/user-profile/updatePass",
      body: body,
      headers: header,
    )
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }

  Future<dynamic> getPointUpload({Map<String, String>? header}) {
    return _util
        .get("$sccMasterProduct/Upload-Bill-Master/get-touch-point-item",
            headers: header)
        .then((value) {
      if (value['status'] != Constant.STATUS_SUCCESS) throw value['message'];
      return value['data'];
    });
  }
}
