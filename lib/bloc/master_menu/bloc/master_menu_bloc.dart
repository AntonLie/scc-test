
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/menu_model.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'master_menu_event.dart';
part 'master_menu_state.dart';

class MasterMenuBloc extends Bloc<MasterMenuEvent, MasterMenuState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;

  MasterMenuBloc() : super(MasterMenuInitial()) {
    on<MasterMenuEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is SearchMasterMenu) {
          MasterMenuLoading();

          List<ParentMenu> listParents = await searchMasterParentMenu();
          List<MenuModel> listModel = await searchMenuFeat(
            event.paging,
            event.model,
          );
          emit(LoadTable(paging, listModel, listParents));
        } else if (event is ToMenuFeatDialog) {
          emit(MasterMenuLoading());
          MenuModel model = MenuModel();
          if (event.menu != null) {
            model = await getMenuFeat(event.menu!);
          }
          emit(MenuFeatLoaded(model));
        } else if (event is UpdateMenuFeat) {
          emit(UpdateMenuFeatLoading());
          await api.updateMenuFeat(
            event.menu.menuCd ?? "",
            header: {
              "Authorization": "${_login.tokenType} ${_login.accessToken}"
            },
            body: event.menu.toUpdate(),
          );
          emit(MenuFeatUpdated());
        } else if (event is UpdateMenuFeatForm) {
          //  UpdateMenuFeatLoading();
          try {
            await api.updateMenuFeat(
              event.menu.menuCd ?? "",
              header: {
                "Authorization": "${_login.tokenType} ${_login.accessToken}"
              },
              body: event.menu.toUpdate(),
            );
            emit(MenuFeatLoaded(event.menu, success: true));
          } catch (e) {
            emit(MenuFeatLoaded(event.menu, error: e.toString()));
          }
        } else if (event is ToMasterMenuForm) {
          emit(MasterMenuLoading());
          MenuModel? submitModel;

          if (event.menuCd != null) {
            submitModel = await getMasterMenu(
              event.menuCd!,
              event.method,
              event.url,
            );
          }

          List<SystemMaster> listSysMaster =
              await searchSystemMaster("MENU_TYPE");
          List<ParentMenu> listParents = await searchMasterParentMenu();

          emit(LoadForm(
            submitModel,
            listSysMaster,
            listParents,
          ));
        } else if (event is SubmitMasterMenu) {
          emit(MasterMenuLoading());
          String msg = await submitMasterMenu(
            event.model,
            event.formMode,
            event.createMethod,
            event.createUrl,
            event.updateMethod,
            event.updateUrl,
          );
          List<MenuModel> listModel = await searchMasterMenu(
            event.paging,
            MenuModel(),
            event.searchMethod,
            event.searchUrl,
          );
          emit(MasterMenuSubmitted(msg, listModel, paging));
        } else if (event is DeleteMasterMenu) {
          emit(MasterMenuLoading());
          await api.deleteMasterMenu(
            event.method,
            event.url,
            header: {
              "Authorization": "${_login.tokenType} ${_login.accessToken}"
            },
            menuCd: event.menuCd ?? "",
          );
          emit(MasterMenuDeleted());
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutMasterMenu());
          }
        } else if (e is InvalidSessionExpression) {
          await deleteUser(db);
          emit(OnLogoutMasterMenu());
        } else {
          emit(MasterMenuError(e.toString()));
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
      throw InvalidSessionExpression('Session is Expired');
    }
  }

  Future<MenuModel> getMenuFeat(MenuModel model) async {
    var response = await api.getMenuFeat(
      model.menuCd ?? "",
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
    ) as Map<String, dynamic>;

    return MenuModel.map(response);
  }

  refreshToken(DatabaseHelper db, {MasterMenuEvent? event}) async {
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

  Future<List<ParentMenu>> searchMasterParentMenu() async {
    List<ParentMenu> listData = [];
    Map<String, String> param = {
      "pageSize": "1000",
      "pageNo": "1",
    };

    var response = await api.searchMasterParentMenu(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      param: param,
    ) as Map<String, dynamic>;

    paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      ParentMenu wfResp = ParentMenu.map(element);
      listData.add(wfResp);
    }

    return listData;
  }

  Future<List<MenuModel>> searchMenuFeat(
    Paging? paging,
    MenuModel model,
  ) async {
    List<MenuModel> listData = [];
    Map<String, String> param = model.toSearch();
    if (paging != null) param.addAll(paging.toJson());
    var response = await api.searchMenuFeat(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      param: param,
    ) as Map<String, dynamic>;

    this.paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      MenuModel wfResp = MenuModel.map(element);
      listData.add(wfResp);
    }

    return listData;
  }

  Future<MenuModel> getMasterMenu(
    String roleCd,
    String method,
    String url,
  ) async {
    var response = await api.getMasterMenu(
      method,
      url,
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      menuCd: roleCd,
    ) as Map<String, dynamic>;
    // print(response.toString());
    return MenuModel.map(response);
  }

  Future<List<SystemMaster>> searchSystemMaster(String systemTypeCd) async {
    List<SystemMaster> listSysMaster = [];
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
        listSysMaster.add(SystemMaster.map(element));
      }
    }
    return listSysMaster;
  }

  Future<String> submitMasterMenu(
    MenuModel model,
    String? formMode,
    String createMethod,
    String createUrl,
    String updateMethod,
    String updateUrl,
  ) async {
    var response;

    if (formMode == Constant.addMode) {
      response = await api.createMasterMenu(
        createMethod,
        createUrl,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toSubmit(),
      ) as Map;
      response = "${model.menuName ?? "[MENU]"} has been successfully added to the master MenuModel list.";
    } else {
      response = await api.editMasterMenu(
        updateMethod,
        updateUrl,
        menuCd: model.menuCd ?? "",
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toSubmit(),
      ) as Map;
      response =
          "${model.menuName ?? "[MENU]"} has been successfully edited.";
    }

    return response;
  }

  Future<List<MenuModel>> searchMasterMenu(
    Paging? paging,
    MenuModel model,
    String method,
    String url,
  ) async {
    List<MenuModel> listData = [];
    Map<String, String> param = model.toSearch();
    if (method.isNotEmpty && url.isNotEmpty) {
      if (paging != null) param.addAll(paging.toJson());
      var response = await api.searchMasterMenu(
        method,
        url,
        header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
        param: param,
      ) as Map<String, dynamic>;

      this.paging = Paging.map(response);
      for (var element in (response['listData'] as List)) {
        MenuModel wfResp = MenuModel.map(element);
        listData.add(wfResp);
      }
    }

    return listData;
  }
}
