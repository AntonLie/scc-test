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
import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/model/subscribers.dart';

import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'subs_event.dart';
part 'subs_state.dart';

class SubsBloc extends Bloc<SubsEvent, SubsState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;
  SubsBloc() : super(SubsInitial()) {
    on<SubsEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is InitSubs) {
          emit(SubsLoading());

          var listData = await getSubsDataTable(
              event.paging, event.packageTypeCd, event.companyName);
          TotalSubs subs = await getGasFeeData(
              event.paging, event.packageTypeCd, event.companyCd);
          List<KeyVal> listTypeProduct = await typeOfProduct();

          List<KeyVal> listSystem = await getSystemDrop();
          var dataPackage = await getPkgSubs();

          emit(SubsDataTableLoaded(listData, subs, paging, listTypeProduct,
              listSystem, dataPackage));
        } else if (event is ToViewSubs) {
          emit(SubsLoading());
          dynamic model = await getViewSubs(
              event.companyCd, event.packageCd, event.formMode);
          List<Countries> listCountry = await getListCountry();
          emit(ViewSubs(model, listCountry));
        } else if (event is SubmitEditSubs) {
          emit(SubsLoading());
          String msg = await submitForm(event.data, event.formMode,
              event.companyCd, event.pkgCd, event.newpkgCd);
          emit(SubsEditSubmitted(msg));
        } else if (event is SubmitNotify) {
          emit(SubsLoading());
          String msg = await getNotify(event.companyCd, event.pkgCd);
          emit(SubsNotifySubmitted(msg));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            await deleteUser(db);

            emit(OnLogout());
          }
        } else if (e is InvalidSessionExpression) {
          await deleteUser(db);

          emit(OnLogout());
        } else {
          emit(SubsError(e.toString()));
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

  refreshToken(DatabaseHelper db, {SubsEvent? event}) async {
    String? username = _login.username;
    try {
      var result = await api.refreshToken(body: _login.toRefresh())
          as Map<String, dynamic>;
      _login = Login.map(result);
      _login.username = username;
      await db.saveUser(_login);

      if (event != null) add(event);
    } catch (e) {
      throw InvalidSessionExpression('Session is Expired');
    }
  }

  deleteUser(db) async {
    await db.dbClear();
  }

  logout() async {
    await api.logout(
        header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
        body: _login.toLogout());
  }

  Future<List<ListSubsTable>> getSubsDataTable(
    Paging? paging,
    String? packageTypeCd,
    String? companyName,
  ) async {
    List<ListSubsTable> listData = [];
    Map<String, String> param = {
      "packageTypeCd": packageTypeCd ?? "",
      "companyName": companyName ?? "",
    };
    if (paging != null) param.addAll(paging.toSubs());
    var response = await api.getSubrDataTable(
      params: param,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);
    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listData.add(ListSubsTable.fromJson(element));
      }
    }
    return listData;
  }

  Future<List<KeyVal>> typeOfProduct() async {
    List<KeyVal> typeOfProduct = [];
    var response = await api.getPackageType();
    if (response['packageTypes'] != null) {
      for (var element in (response['packageTypes'] as List)) {
        if (element is Map) {
          typeOfProduct.add(KeyVal(
            element["packageTypeName"] ?? "",
            element["packageTypeCd"] ?? "",
          ));
        }
      }
    }

    return typeOfProduct;
  }

  Future<dynamic> getViewSubs(
    final String? companyCd,
    final int? packageCd,
    final String? formMode,
  ) async {
    Map<String, dynamic> response;
    if (formMode == Constant.editMode) {
      response = await api.getSubsView(
        companyCd: companyCd,
        packageCd: packageCd,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
      ) as Map<String, dynamic>;
    } else if (formMode == Constant.addMode) {
      response = await api.getSubsView(
        companyCd: companyCd,
        packageCd: packageCd,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
      ) as Map<String, dynamic>;
    } else {
      response = await api.getSubsView(
        companyCd: companyCd,
        packageCd: packageCd,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
      ) as Map<String, dynamic>;
    }
    if (formMode == Constant.addMode) {
      return ListSubsTable.getCreate(response);
    } else {
      return ListSubsTable.view(response);
    }
  }

  Future<TotalSubs> getGasFeeData(
    Paging? paging,
    String? packageTypeCd,
    String? companyCd,
  ) async {
    Map<String, String> param = {
      "packageName": packageTypeCd ?? "",
      "companyName": companyCd ?? "",
    };
    if (paging != null) param.addAll(paging.toSubs());
    var response = await api.getGasFee(
      params: param,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;

    return TotalSubs.fromJson(response);
  }

  Future<String> submitForm(
    ListSubsTable? model,
    String? formMode,
    final String? companyCd,
    final int? packageCd,
    final int? newpackageCd,
  ) async {
    String message = "";

    if (formMode == Constant.addMode) {
      await api.subsCreate(
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model!.toCreate(),
      ) as Map;
      message =
          "${model.companyName ?? "[company]"} has been successfully added to the master role list.";
    } else {
      await api.subsEdit(
        packageCd: model!.packageCd,
        companyCd: companyCd,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toEdit(),
      ) as Map;
      message =
          "${model.companyName ?? "[Company]"} has been successfully edited.";
    }

    return message;
  }

  Future<String> getNotify(
    final String? companyCd,
    final int? packageCd,
  ) async {
    String message = "";
    var response = await api.subsNotif(
      // updateMethod,
      // updateUrl,
      packageCd: packageCd,
      companyCd: companyCd,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map;
    message = response['message'];

    return message;
  }

  Future<List<KeyVal>> getSystemDrop() async {
    List<KeyVal> listPlantOpt = [];
    var response = await api.getSystemDropdown(params: {
      "pageNo": "1",
      "pageSize": "99999",
      "systemCd": "",
      "systemTypeCd": "PACKAGE_PERIOD",
      "systemValue": "",
      "company": "",
      "traceType": ""
    });

    if (response != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listPlantOpt.add(KeyVal(
              element["systemValue"] + " Month", element["systemValue"]));
        }
      }
    }
    return listPlantOpt;
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

  Future<List<PackageList>> getPkgSubs() async {
    List<PackageList> listData = [];
    Map<String, String> param = {
      "packageName": "",
      "pageNo": "1",
      "pageSize": "99999",
    };
    var response = await api.getSubsDataTable(
      params: param,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;
    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listData.add(PackageList.fromJson(element));
      }
    }
    return listData;
  }
}
