// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/new_edit_role.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/point.dart';
import 'package:scc_web/services/restapi.dart';

part 'new_edit_role_event.dart';
part 'new_edit_role_state.dart';

class NewEditRoleBloc extends Bloc<NewEditRoleEvent, NewEditRoleState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;

  NewEditRoleBloc() : super(NewEditRoleInitial()) {
    on<NewEditRoleEvent>((event, emit) async {
      var db = DatabaseHelper();

      try {
        await _query(db);
        if (event is InitNewEditRole) {
          emit(NewEditRoleLoading());
          List<ListDataNewEditRole> listRole = await searchRole(
            event.paging,
            event.roleName,
          );
          emit(ListRoleLoaded(
            listRole,
            paging,
          ));
        } else if (event is ToNewEditRoleForm) {
          emit(NewEditRoleLoading());
          EditRoleForm role = EditRoleForm();
          if (event.roleCd != null) role = await getRoleData(event.roleCd);
          var listMenu = await getListMenu();
          emit(DataRoleEditLoaded(role, listMenu));
        } else if (event is SubmitNewEditRole) {
          emit(NewEditRoleLoading());
          String msg = await submitNewEditData(
            event.model,
            event.formMode,
          );
          emit(NewEditRoleSubmitted(msg));
        } else if (event is DeleteEditRole) {
          emit(NewEditRoleLoading());
          await api.deleteNewEditRole(
            header: {
              "Authorization": "${_login.tokenType} ${_login.accessToken}"
            },
            roleCd: event.roleCd ?? "",
          );
          emit(EditRoleDeleted());
        } else if (event is GetFeatList) {
          emit(NewEditRoleLoading());
          var listFeat = await getListFeatDetail(event.menuCd);
          emit(ListFeatLoaded(listFeat));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success");
            emit(OnLogoutNewEditRole());
          }
        } else if (e is InvalidInputException) {
          await deleteUser(db);
          // print("Logout success");
          emit(OnLogoutNewEditRole());
        } else {
          emit(EditRoleError(e.toString()));
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

  refreshToken(DatabaseHelper db, {NewEditRoleEvent? event}) async {
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

  Future<List<ListDataNewEditRole>> searchRole(
    Paging? paging,
    String? roleName,
  ) async {
    List<ListDataNewEditRole> listPoint = [];
    Map<String, String> params = {
      "roleName": roleName ?? "",
    };
    if (paging != null) params.addAll(paging.toJson());
    var response = await api.searchNewEditRole(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: params,
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);

    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listPoint.add(ListDataNewEditRole.fromJson(element));
      }
    }
    return listPoint;
  }

  Future<List<ListMenuDropdown>> getListMenu() async {
    List<ListMenuDropdown> listData = [];
    var response = await api.getListMenu(
      param: {
        "pageSize": "99999",
        "pageNo": "1",
      },
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;

    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listData.add(ListMenuDropdown.fromJson(element));
      }
    }
    return listData;
  }

  Future<EditRoleForm> getRoleData(String? roleCd) async {
    EditRoleForm listData;
    var response = await api.getRoleData(
      roleCd: roleCd,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;
    listData = EditRoleForm.fromJson(response);
    return listData;
  }

  Future<List<ListFeature>> getListFeatDetail(
    String? menuCd,
  ) async {
    List<ListFeature> listData = [];

    var response = await api.getListFeatD(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      menuCd: menuCd,
    );

    if (response is List) {
      for (var element in (response)) {
        listData.add(ListFeature.fromJson(element));
      }
    }
    return listData;
  }

  Future<String> submitNewEditData(
    EditRoleForm model,
    String? formMode,
  ) async {
    String msg = "";

    if (formMode == Constant.addMode) {
      await api.addNewEditRole(
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toJson(),
      ) as Map;
      msg = "${model.roleName} has been successfully added to the master Role";
    } else {
      await api.editNewEditRole(
        roleCd: model.roleCd ?? "",
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toJson(),
      ) as Map;
      msg =
          "${model.roleName} has been successfully edited to the master Role";
    }

    return msg;
  }
}
