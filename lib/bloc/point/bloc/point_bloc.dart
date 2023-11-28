// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';

import 'package:scc_web/services/restapi.dart';

import '../../../model/point.dart';

part 'point_event.dart';
part 'point_state.dart';

class PointBloc extends Bloc<PointEvent, PointState> {
  RestApi api = RestApi();

  Paging? paging;

  late Login _login;
  PointBloc() : super(PointInitial()) {
    on<PointEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is GetPointData) {
          emit(PointLoading());
          List<ListDataNewPoint> searchPointList = await searchPoint(
            event.paging,
            event.pointCd,
            event.pointName,
            event.type,
          );
          emit(DataPoint(
            searchPointList,
            paging,
          ));
        } else if (event is GetViewData) {
          emit(PointLoading());
          dynamic model = await viewJson(event.pointCd, event.formMode);

          emit(PointView(model));
        } else if (event is LoadFormPoint) {
          emit(PointLoading());

          List<KeyVal> listPointTyp = await getPointType("POINT_TYPE_CD");
          List<KeyVal> listTyp = await getType();
          List<KeyVal> listProType = await getProductType();
          List<KeyVal> listNodeBlock = await getNodeBlock("ENTITY_CODE");
          List<KeyVal> listTempAttr = await getTemplateAttr();
          List<KeyVal> listAttr = await getAttr();
          dynamic model;
          if (event.formMode != Constant.addMode) {
            model = await viewJson(event.pointCd, event.formMode);
          }

          emit(PointFormState(listPointTyp, listProType, listTyp, listNodeBlock,
              listTempAttr, listAttr, model));
        } else if (event is SubmitedPoint) {
          emit(PointLoading());
          String msg = await submitForm(event.model!, event.formMode);

          emit(PointSubmited(msg));
        } else if (event is DeletePoint) {
          emit(PointLoading());

          await api.deleteMstPoint(
            header: {
              "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
            },
            pointCd: event.pointCd!,
          );
          emit(PointDeleted());
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success");
            emit(OnLogoutPoint());
          }
        } else if (e is InvalidInputException) {
          await deleteUser(db);
          // print("Logout success");
          emit(OnLogoutPoint());
        } else {
          emit(PointError(e.toString()));
        }
      }
    });
  }
  _query(DatabaseHelper db) async {
    final user = await db.getUser();
    if (user != null) {
      _login = user;
      DateTime now = DateTime.now();
      DateTime date = convertStringToDateFormat(
          _login.accessTokenExpDate!, "dd-MMM-yyyy HH:mm:ss");
      if ((date.difference(now).inSeconds - 10).isNegative) {
        await refreshToken(db);
      }
    } else {
      throw UnauthorisedException('Session is Expired');
    }
  }

  refreshToken(DatabaseHelper db, {PointEvent? event}) async {
    // print('RefreshToken..');
    String? username = _login.username;
    var result = await api.refreshToken(body: _login.toRefresh())
        as Map<String, dynamic>;
    _login = Login.map(result);
    _login.username = username;
    await db.saveUser(_login);
    // print('RerouteEventToken..');
    if (event != null) add(event);
  }

  deleteUser(db) async {
    // print("Delete user story..");

    await db.dbClear();
  }

  Future<List<ListDataNewPoint>> searchPoint(
    Paging? paging,
    String? pointCd,
    String? pointName,
    String? type,
    // String? companyCd,
    // String method,
    // String url,
  ) async {
    List<ListDataNewPoint> listPoint = [];
    Map<String, String> params = {
      "pointTypeCd": pointCd ?? "",
      "pointName": pointName ?? "",
      "type": type ?? "",
      // "companyCd": companyCd ?? "",
    };
    if (paging != null) params.addAll(paging.toJson());
    var response = await api.searchPoint(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: params,
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);

    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listPoint.add(ListDataNewPoint.fromJson(element));
      }
    }
    //// print(response);

    return listPoint;
  }

  Future<dynamic> viewJson(
    String? pointCd,
    String? formMode,
  ) async {
    if (formMode == Constant.viewMode || formMode == Constant.editMode) {
      var response = await api.pointView(
        // method,
        // url,
        pointCd: pointCd,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
      ) as Map<String, dynamic>;

      return ViewPointModel.fromJson(response);
    } else {
      String? test;
      var response = await api.jsonView(
        // method,
        // url,
        pointCd: pointCd,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
      ) as Map<String, dynamic>;
      test = response['viewJSON'];
      return test;
    }
  }

  Future<List<KeyVal>> getPointType(String systemTypeCd) async {
    List<KeyVal> listPointType = [];

    var response = await api.searchSystemMaster(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: {
        "pageSize": "1000",
        "pageNo": "1",
        "systemTypeCd": systemTypeCd,
      },
    );

    if (response['listData'] != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listPointType
              .add(KeyVal(element["systemValue"], element["systemCd"]));
        }
      }
    }
    return listPointType;
  }

  Future<List<KeyVal>> getType() async {
    List<KeyVal> listType = [];

    var response = await api.getType(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    );

    if (response != null) {
      for (var element in (response as List)) {
        if (element is Map) {
          listType.add(KeyVal(element["pointTypeName"], element["pointType"]));
        }
      }
    }
    return listType;
  }

  Future<List<KeyVal>> getProductType() async {
    List<KeyVal> listProductType = [];

    var response = await api.getProductDataTable(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: {
        "pageNo": "1",
        "pageSize": "1000",
        "productCd": "",
        "productName": "",
        "touchPoint": ""
      },
    );

    if (response['listData'] != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listProductType
              .add(KeyVal(element["productName"], element["productCd"]));
        }
      }
    }
    return listProductType;
  }

  Future<List<KeyVal>> getNodeBlock(String systemTypeCd) async {
    List<KeyVal> listPointType = [];

    var response = await api.searchSystemMaster(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: {
        "pageSize": "1000",
        "pageNo": "1",
        "systemTypeCd": systemTypeCd,
      },
    );

    if (response['listData'] != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listPointType
              .add(KeyVal(element["systemValue"], element["systemCd"]));
        }
      }
    }
    return listPointType;
  }

  Future<List<KeyVal>> getTemplateAttr() async {
    List<KeyVal> listTempAttr = [];

    var response = await api.searchTemplAttr(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: {
        "pageSize": "1000",
        "pageNo": "1",
        "tempAttrCd": "",
        "tempAttrName": ""
      },
    );

    if (response['listData'] != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listTempAttr
              .add(KeyVal(element["tempAttrName"], element["tempAttrCd"]));
        }
      }
    }
    return listTempAttr;
  }

  Future<List<KeyVal>> getAttr() async {
    List<KeyVal> listAttr = [];

    var response = await api.searchAttribute(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: {
        "pageSize": "1000",
        "pageNo": "1",
        "attributeCd": "",
        "attributeName": "",
        "companyCd": "",
        "attrTypeCd": ""
      },
    );

    if (response['listData'] != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listAttr
              .add(KeyVal(element["attributeName"], element["attributeCd"]));
        }
      }
    }
    return listAttr;
  }

  Future<String> submitForm(
    ViewPointModel model,
    String? formMode,
    // String createMethod,
    // String createUrl,
    // String updateMethod,
    // String updateUrl,
  ) async {
    String message = "";

    if (formMode == Constant.addMode) {
      await api.savePoint(
        // createMethod,
        // createUrl,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toSave(),
      ) as Map;
      message =
          "${model.pointName ?? "[Username]"} has been successfully added to the master role list.";
    } else {
      await api.editPoint(
          // updateMethod,
          // updateUrl,
          pointCd: model.pointCd,
          header: {
            "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
          },
          body: model.toSave()) as Map;
      message =
          "${model.pointName ?? "[UserName]"} has been successfully edited.";
    }

    return message;
  }
}
