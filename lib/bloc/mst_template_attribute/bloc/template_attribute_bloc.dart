
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/temp_attr.dart';
import 'package:scc_web/services/restapi.dart';

part 'template_attribute_event.dart';
part 'template_attribute_state.dart';

class TemplateAttributeBloc
    extends Bloc<TemplateAttributeEvent, TemplateAttributeState> {
  RestApi api = RestApi();
  late Login _login;
  Paging? paging;

  TemplateAttributeBloc() : super(TemplateAttributeInitial()) {
    on<TemplateAttributeEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is SearchTemplateAttr) {
          emit(TemplateAttributeLoading());
          List<TempAttr> listTempAttr = await searchAllTemplAttr(
            event.model,
            event.paging,
          ); // event.method, event.url);
          emit(SearchTempAttr(listTempAttr, paging));
        } else if (event is ViewTemplateAttr) {
          emit(TemplateAttributeLoading());
          TempAttr? submitModel;
          if (event.model != null) {
            submitModel = await getTmplAttr(event.model!);
          } //, event.method, event.url);
          emit(ViewTmplAttrLoaded(submitModel));
        } else if (event is AddTemplateAttribute) {
          emit(TemplateAttributeLoading());
          try {
            await addTmplAttr(event.model); //, event.method, event.url);
            emit(AddTmplAttrSubmit(
                "${event.model.tempAttrName} has been successfully added in Template Attribute"));
            // emit(AddTmplAttrSubmit(
            //     "${event.model.tempAttrName} has been successfully updated in Template Attribute"));
          } catch (e) {
            emit(ViewTmplAttrLoaded(event.model, errMsg: e.toString()));
          }
        } else if (event is SearchAttributeCd) {
          emit(TemplateAttributeLoading());
          List<AttrCodeClass> listAttr = await searchAttribute(
              paging: event.paging,
              attributeCd: event.attrCd,
              attributeName: event.attrName);
          emit(LoadAttribute(listAttr, paging));
        } else if (event is DeleteTemplateAttribute) {
          emit(TemplateAttributeLoading());
          await deleteTmplAttr(event.attrCd); //, event.method, event.url);
          emit(DeleteTmplAttrSubmit(""));
        } else if (event is EditTemplateAttribute) {
          emit(TemplateAttributeLoading());
          try {
            await updateTmplAttr(event.model); //, event.method, event.url);
            emit(EditTmplAttrSubmit(
                "${event.model.tempAttrName} has been successfully updated in Template Attribute"));
          } catch (e) {
            emit(ViewTmplAttrLoaded(event.model, errMsg: e.toString()));
          }
        } else if (event is ViewAllTemplateAttr) {
          emit(TemplateAttributeLoading());
          List<TempAttr> listViewTemplate =
              await viewAllTemplateAttr(event.model!, event.paging);
          emit(ViewTemplateAttrLoadedAll(listViewTemplate, paging));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutTemplateAttribute());
          }
        } else {
          emit(TemplateAttributeError(e.toString()));
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
      if ((date.difference(now).inSeconds).isNegative) {
        await refreshToken(db);
      }
    } else {
      throw UnauthorisedException('Session is Expired');
    }
  }

  refreshToken(DatabaseHelper db, {TemplateAttributeEvent? event}) async {
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

  Future<List<TempAttr>> searchAllTemplAttr(
    TempAttr model,
    Paging? paging,
    // String method, String url
  ) async {
    List<TempAttr> listTempAttr = [];
    Map<String, String> param = {
      "tempAttrCd": model.tempAttrCd ?? "",
      "tempAttrName": model.tempAttrName ?? "",
    };

    if (paging != null) param.addAll(paging.toJson());
    //if (method.isNotEmpty && url.isNotEmpty) {
    var response = await api.searchTemplAttr(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: param,
    ) as Map<String, dynamic>;

    this.paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      TempAttr templAttr = TempAttr.map(element);
      listTempAttr.add(templAttr);
    }
    //}
    return listTempAttr;
  }

  Future<List<TempAttr>> viewAllTemplateAttr(
    TempAttr model,
    Paging? paging,
    // String method, String url
  ) async {
    List<TempAttr> listTempAttr = [];
    Map<String, String> param = {
      "attributeCd": model.attributeCd ?? "",
      "attributeName": model.attributeName ?? "",
      "companyCd": model.companyCd ?? "",
      "attrDataTypeCd": model.attrDataTypeCd ?? "",
      "tempAttrCd": model.tempAttrCd ?? "",
    };

    if (paging != null) param.addAll(paging.toJson());
    //if (method.isNotEmpty && url.isNotEmpty) {
    var response = await api.viewFullTemplateAttr(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: param,
    ) as Map<String, dynamic>;

    this.paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      TempAttr templAttr = TempAttr.fromJson(element);
      listTempAttr.add(templAttr);
    }
    //}
    return listTempAttr;
  }

  Future<TempAttr> getTmplAttr(
    TempAttr modeldata,
  ) async {
    late TempAttr model;
    if (modeldata.tempAttrCd != null) {
      var response = await api.getTmplAttr(
        // method,
        // url,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        tempAttrCd: modeldata.tempAttrCd,
      ) as Map<String, dynamic>;

      model = TempAttr.map(response);
    } else {
      model = TempAttr(templateDetail: []);
    }
    return model;
  }

  Future<List<AttrCodeClass>> searchAttribute(
      {Paging? paging, String? attributeCd, String? attributeName}) async {
    List<AttrCodeClass> listAttr = [];
    Map<String, String> params = {
      "attributeCd": attributeCd ?? "",
      "attributeName": attributeName ?? "",
    };

    if (paging != null) params.addAll(paging.toJson());
    var response = await api.searchAttribute(header: {
      "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
    }, param: params);

    this.paging = Paging.map(response);
    if (response['listData'] != null && response['listData'] is List) {
      // print(response['listData']);
      for (var element in (response['listData'] as List)) {
        listAttr.add(AttrCodeClass.map(element));
      }
    }

    return listAttr;
  }

  deleteTmplAttr(
    String? attrCd,
    // String method, String url
  ) async {
    var response = await api.deleteTmplAttr(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      attrCd: attrCd,
    ) as Map<String, dynamic>;

    return response;
  }

  updateTmplAttr(
    TempAttr model,
    // String method, String url
  ) async {
    String tmplAttrCd = model.tempAttrCd ?? '';
    var response = await api.updateTmplAttr(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      body: model.toAdd(),
      tmplAttrCd: tmplAttrCd,
    ) as Map<String, dynamic>;

    return response;
  }

  addTmplAttr(
    TempAttr model,
    // String method, String url
  ) async {
    var response = await api.addTmplAttr(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      body: model.toAdd(),
    ) as Map<String, dynamic>;

    return response;
  }
}
