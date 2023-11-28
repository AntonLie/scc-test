// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/countries.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/user_role.dart';
import 'package:scc_web/services/restapi.dart';

part 'mst_usr_role_event.dart';
part 'mst_usr_role_state.dart';

class MstUsrRoleBloc extends Bloc<MstUsrRoleEvent, MstUsrRoleState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;
  MstUsrRoleBloc() : super(MstUsrRoleInitial()) {
    on<MstUsrRoleEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is SearchMasterRole) {
          emit(MasterRoleLoading());
          List<MasterRole> listRole = await searchMasterRole(
            event.model,
            event.paging,
            // event.method,
            // event.url,
          );
          List<MasterRolee> listUserRole = await searchUserRole(
            event.model,
            event.paging,
            // event.method,
            // event.url,
          );
          emit(SearchMasterRoleSuccess(listUserRole, listRole, paging));
        } else if (event is GetMenuFeature) {
          emit(MasterRoleLoading());
          RoleUser? submitModel;
          if (event.roleCd != null) {
            submitModel = await getMenuList(event.roleCd!);
          }
          emit(LoadMenuList(submitModel));
        } else if (event is UpdateMenuFeature) {
          emit(UserRoleSubmitLoading());
          await api.submitUserRole(
            header: {
              "Authorization": "${_login.tokenType} ${_login.accessToken}"
            },
            username: event.submitModel.username,
            validFrom: event.submitModel.validFromDt,
            body: event.submitModel.toSubmit(),
          );

          emit(UserRoleSubmitted());
        } else if (event is ToMasterRoleForm) {
          emit(MasterRoleLoading());
          MasterRoleSubmit submitModel = MasterRoleSubmit();
          if (event.model != null) {
            submitModel = await getUserRole(event.model!);
          }
          var listBrand = await getListBrand();
          var listCompany = await getListCompany();

          var listDivision = await getListDivision();
          List<Countries> listCountry = await getListCountry();
          emit(LoadShape(submitModel, listCompany, listDivision, listBrand,
              listCountry, event.model?.validFromDt));
        } else if (event is SubmitMasterRole) {
          emit(MasterRoleLoading());
          String msg = await submitForm(
            event.model,
            event.formMode,
          );
          List<MasterRole> listRole = await searchMasterRole(
            event.modelRole!,
            event.paging,
          );
          emit(MasterRoleSubmitted(msg, listRole, paging));
        } else if (event is DeleteRole) {
          emit(MasterRoleLoading());
          await api.deleteUserRole(
            // event.method,
            // event.url,
            header: {
              "Authorization": "${_login.tokenType} ${_login.accessToken}"
            },
            usernameRole: event.username,
            validFromDt: event.validFrom,
          );
          emit(DeleteRoleSuccess());
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutMasterRole());
          }
        } else {
          emit(MasterRoleError(e.toString()));
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

  refreshToken(DatabaseHelper db, {MstUsrRoleEvent? event}) async {
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

  Future<MasterRoleSubmit> getUserRole(
    MasterRole model,
  ) async {
    var response = await api.getUserRole(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      username: model.username.toString(),
      companyCd: model.companyCd.toString(),
    ) as Map<String, dynamic>;

    return MasterRoleSubmit.fromJson(response);
  }

  Future<List<KeyVal>> getCountryDrop() async {
    List<KeyVal> listPlantOpt = [];
    var response = await api.getCountry();

    if (response != null) {
      for (var element in (response['countries'] as List)) {
        if (element is Map) {
          listPlantOpt
              .add(KeyVal(element[""], element["countryId"].toString()));
        }
      }
    }
    return listPlantOpt;
  }

  Future<RoleUser> getMenuList(
    String roleCd,
  ) async {
    var response = await api.getMenuList(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      roleCd: roleCd,
    ) as Map<String, dynamic>;

    // print(response.toString());
    return RoleUser.map(response);
  }

  Future<String> submitForm(
    MasterRoleSubmit model,
    String? formMode,
    // String createMethod,
    // String createUrl,
    // String updateMethod,
    // String updateUrl,
  ) async {
    String message = "";

    if (formMode == Constant.addMode) {
      await api.createMasterRole(
        // createMethod,
        // createUrl,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toSubmit(),
      ) as Map;
      message =
          "${model.username ?? "[Username]"} has been successfully added to the master role list.";
    } else {
      await api.updateMasterRole(
        // updateMethod,
        // updateUrl,
        username: model.username.toString(),
        validFrom: model.validFromDt.toString(),
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toSubmit(),
      ) as Map;
      message =
          "${model.username ?? "[UserName]"} has been successfully edited.";
    }

    return message;
  }

  Future<List<MasterRole>> searchMasterRole(
    MasterRole model,
    Paging? paging,
    // String method,
    // String url,
  ) async {
    List<MasterRole> listMasterRole = [];
    Map<String, String> param = {
      "roleCd": "",
      "roleName": "",
      "pageNo": "1",
      "pageSize": "10000",
      // if (model.superAdminFlag != null) "superAdmin": model.superAdminFlag.toString()
    };

    var response = await api.searchMasterRole(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: param,
    ) as Map<String, dynamic>;

    // this.paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      MasterRole userRole = MasterRole.map(element);
      listMasterRole.add(userRole);
    }
    // }
    return listMasterRole;
  }

  Future<List<MasterRolee>> searchUserRole(
    MasterRole model,
    Paging? paging,
    // String method,
    // String url,
  ) async {
    List<MasterRolee> listMasterRole = [];
    Map<String, String> param = {
      "roleCd": model.roleCd ?? "",
      "username": model.username ?? "",
      "email": model.email ?? "",
    };
    // if (method.isNotEmpty && url.isNotEmpty) {
    if (paging != null) param.addAll(paging.toJson());

    var response = await api.searchUserRole(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: param,
    ) as Map<String, dynamic>;

    this.paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      MasterRolee userRole = MasterRolee.fromJson(element);
      listMasterRole.add(userRole);
    }
    // }
    return listMasterRole;
  }

  Future<List<String>> getListBrand() async {
    List<String> listBrand = [];

    var response = await api.searchBrand(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
    );

    if (response != null) {
      listBrand = List.from(response["listBrand"]);
    }
    return listBrand;
  }

  Future<List<DataCompany>> getListCompany() async {
    List<DataCompany> listCompany = [];
    var response = await api.searchCompany(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
    ) as Map<String, dynamic>;
    // print(response);
    // print("ini response\n");
    if (response['listCompany'] != null && response['listCompany'] is List) {
      for (var element in (response['listCompany'] as List)) {
        listCompany.add(DataCompany.map(element));
      }
    }
    return listCompany;
  }

  Future<List<DataDivision>> getListDivision() async {
    List<DataDivision> listDivision = [];
    var response = await api.searchDivision(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      param: {
        "pageSize": "99999",
        "pageNo": "1",
      },
    ) as Map<String, dynamic>;

    paging = Paging.map(response);
    // print(response);

    if (response['listData'] != null && response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listDivision.add(DataDivision.map(element));
      }
    }
    return listDivision;
  }

  Future<List<Countries>> getListCountry() async {
    List<Countries> listCountry = [];
    var response = await api.getCountry();

    if (response != null) {
      for (var element in (response['countries'] as List)) {
        listCountry.add(Countries.fromJson(element));
      }
    }
    return listCountry;
  }
}
