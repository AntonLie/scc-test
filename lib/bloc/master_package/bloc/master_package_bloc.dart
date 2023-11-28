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
import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/model/user_role.dart' as role;
import 'package:scc_web/model/user_role.dart';
import 'package:scc_web/services/restapi.dart';

part 'master_package_event.dart';
part 'master_package_state.dart';

class MasterPackageBloc extends Bloc<MasterPackageEvent, MasterPackageState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;
  MasterPackageBloc() : super(MasterPackageInitial()) {
    on<MasterPackageEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is GetPackageData) {
          emit(PackageLoading());
          var data = await getPkgDataTbl(
            event.paging,
            event.pkgNm,
          );
          emit(PackageDataLoaded(data, paging));
        } else if (event is GetMenuFeature) {
          emit(PackageLoading());
          RoleUser? submitModel;
          if (event.roleCd != null) {
            submitModel = await getMenuList(event.roleCd!);
          }
          emit(LoadMenuList(submitModel));
        } else if (event is SubmitPackageForm) {
          emit(PackageLoading());

          var msg = await submitPkgForm(
            event.model,
            event.formMode,
          );
          emit(PackageDataSubmited(msg));
        } else if (event is DeletePackageData) {
          emit(PackageLoading());
          await api.deletePakageList(
            header: {
              "Authorization": "${_login.tokenType} ${_login.accessToken}"
            },
            pckCd: event.pckCd!,
          );
          emit(PackageDataDeleted());
        } else if (event is ToPackageForm) {
          emit(PackageLoading());
          PackageData? pkgData;
          if (event.pkgCd != null) {
            pkgData = await getPkgData(event.pkgCd);
          }

          List<KeyVal> listColor = await getPackageColour();
          List<KeyVal> listBlock = await getPackageBlock();
          List<KeyVal> listRoleAll = await getRoleAll();
          emit(PackageFormLoaded(pkgData, listColor, listBlock, listRoleAll));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success");
            emit(OnLogout());
          }
        } else if (e is InvalidInputException) {
          await deleteUser(db);
          // print("Logout success");
          emit(OnLogout());
        } else {
          emit(PackageError(e.toString()));
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

  refreshToken(DatabaseHelper db, {MasterPackageEvent? event}) async {
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

  Future<List<PackageList>> getPkgDataTbl(
    Paging? paging,
    String? pktNm,
  ) async {
    List<PackageList> listData = [];
    Map<String, String> param = {
      "packageName": pktNm ?? "",
    };
    if (paging != null) param.addAll(paging.toJson());
    var response = await api.getSubsDataTable(
      params: param,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);
    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listData.add(PackageList.fromJson(element));
      }
    }
    return listData;
  }

  Future<String> submitPkgForm(
    PackageData model,
    String? formMode,
  ) async {
    String msg = "";
    if (formMode == Constant.addMode) {
      await api.createPackageList(
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toJson(),
      ) as Map;
      // msg = "${model.packageName} has been successfully added to the master point";
      msg =
          "${model.packageName ?? "[MENU]"} Your package has been successfully created.";
    } else {
      await api.updatePackageList(
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toJson(),
      ) as Map;
      // msg = "${model.packageName} has been successfully updated to the master point";
      msg =
          "${model.packageName ?? "[MENU]"}Your package has been successfully updated.";
    }
    return msg;
  }

  Future<List<KeyVal>> getPackageColour() async {
    List<KeyVal> listColour = [];
    var response = await api.getPackageColor(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    );

    if (response != null) {
      for (var element in (response as List)) {
        if (element is Map) {
          listColour.add(KeyVal(
            element["colorCd"] ?? "",
            element["colorCd"] ?? "",
            toParse: element["colorName"] ?? "",
          ));
        }
      }
    }
    return listColour;
  }

  Future<List<KeyVal>> getPackageBlock() async {
    List<KeyVal> listBlock = [];
    var response = await api.getPackageBlock(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    );

    if (response != null) {
      for (var element in (response as List)) {
        if (element is Map) {
          listBlock.add(KeyVal(
              element["blockchainName"], element["blockchainName"],
              checked: element["statusBlockchain"]));
        }
      }
    }
    return listBlock;
  }

  Future<List<KeyVal>> getRoleAll() async {
    List<KeyVal> listRoleAll = [];
    var response = await api.getRoleAll(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    );

    if (response != null) {
      for (var element in (response as List)) {
        if (element is Map) {
          listRoleAll.add(KeyVal(element["roleName"], element["roleCd"]));
        }
      }
    }
    return listRoleAll;
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

  Future<PackageData> getPkgData(
    int? packageCd,
  ) async {
    var response = await api.getDataPackage(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      pkgCd: packageCd,
    ) as Map<String, dynamic>;
    PackageData model = PackageData.fromJson(response);
    return model;
  }
}
