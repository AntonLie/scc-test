
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/master_attribute.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'mst_attr_event.dart';
part 'mst_attr_state.dart';

class MstAttrBloc extends Bloc<MstAttrEvent, MstAttrState> {
  RestApi api = RestApi();
  late Login _login;
  Paging? paging;

  MstAttrBloc() : super(MstAttrInitial()) {
    on<MstAttrEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is SearchMstAttr) {
          emit(MstAttrLoading());
          List<MstAttribute> listModel =
              await searchMstAttr(event.paging, event.model);
          emit(LoadTable(paging, listModel));
        } else if (event is ToMstAttrForm) {
          emit(MstAttrLoading());
          MstAttribute? submitModel;
          if (event.model != null) {
            submitModel = await getMstAttr(
              event.model!,
            ); // event.getMethod, event.getUrl);
          }
          List<SystemMaster> attrDataType =
              await searchSystemMaster(Constant.attrDataType);
          List<SystemMaster> attrType =
              await searchSystemMaster(Constant.attrType);
          emit(LoadForm(attrType, attrDataType, submitModel));
        } else if (event is SubmitMstAttr) {
          emit(MstAttrSuccess());
          String msg =
              await submitMstAttr(model: event.model, formMode: event.formMode);
          List<MstAttribute> listModel =
              await searchMstAttr(event.paging, event.model);
          emit(MstAttrSubmitted(msg, listModel, paging));
        } else if (event is DeleteAttr) {
          emit(MstAttrLoading());
          await api.deleteMstAttr(
            // event.method,
            // event.url,
            header: {
              "Authorization": "${_login.tokenType} ${_login.accessToken}"
            },
            attributeCd: event.attributeCd ?? "",
          );
          emit(AttrDeleted());
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutMstAttr());
          }
        } else if (e is InvalidSessionExpression) {
          await deleteUser(db);
          // print("Logout success..");
          emit(OnLogoutMstAttr());
        } else {
          emit(MstAttrError(e.toString()));
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

  refreshToken(DatabaseHelper db, {MstAttrEvent? event}) async {
    // print('RefreshToken..');
    String? username = _login.username;
    try {
      var result = await api.refreshToken(body: _login.toRefresh())
          as Map<String, dynamic>;
      _login = Login.map(result);
      _login.username = username;
      await db.saveUser(_login);
      // print('RerouteEventToken..');
      if (event != null) add(event);
    } catch (e) {
      throw InvalidSessionExpression('Session is Expired');
    }
  }

  deleteUser(db) async {
    // print("Delete user story..");

    await db.dbClear();
  }

  Future<List<MstAttribute>> searchMstAttr(
      Paging? paging, MstAttribute model) async {
    List<MstAttribute> listData = [];
    Map<String, String> param = model.toSearch();
    // {
    //   "attributeName": attributeName ?? "",
    //   "attributeCd": attributeCd ?? "",
    //   "attrTypeCd": attrTypeCd ?? "",
    // };

    if (paging != null) param.addAll(paging.toJson());
    var response = await api.searchMstAttr(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      param: param,
    ) as Map<String, dynamic>;

    // print(response);
    this.paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      MstAttribute wfResp = MstAttribute.map(element);
      listData.add(wfResp);
    }

    return listData;
  }

  Future<MstAttribute> getMstAttr(
    // String attributeCd,
    MstAttribute model,
  ) async {
    //String method, String url
    var response = await api.getMstAttr(
      // method,
      // url,
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      attributeCd: model.attributeCd!,
    ) as Map<String, dynamic>;
    return MstAttribute.map(response);
  }

  Future<List<SystemMaster>> searchSystemMaster(String systemTypeCd) async {
    List<SystemMaster> listSysMst = [];
    var response = await api.searchSystemMaster(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      param: {
        "pageSize": "1000",
        "pageNo": "1",
        "systemTypeCd": systemTypeCd,
      },
    );
    if (response['listData'] != null && response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listSysMst.add(SystemMaster.map(element));
      }
    }
    return listSysMst;
  }

  Future<String> submitMstAttr({
    required MstAttribute model,
    String? formMode,
    String? createMethod,
    String? updateMethod,
  }) async {
    String message = "";

    if (formMode == Constant.addMode) {
      await api.createMstAttr(
        createMethod ?? "POST",
        // createUrl,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toSubmit(),
      ) as Map;
      message =
          "${model.attributeCd ?? "[Attribute]"} has been successfully added to the master attribute list.";
    } else {
      await api.updateMstAttr(
        // String? updateMethod,
        // updateUrl,
        updateMethod ?? "PUT",
        attributeCd: model.attributeCd ?? "",
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toSubmit(),
      ) as Map;
      message =
          "${model.attributeCd ?? "[Attribute]"} has been successfully edited.";
    }

    return message;
  }
}
