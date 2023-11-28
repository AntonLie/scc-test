
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/countries.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/master_supplier.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'master_supplier_event.dart';
part 'master_supplier_state.dart';

class MasterSupplierBloc
    extends Bloc<MasterSupplierEvent, MasterSupplierState> {
  RestApi api = RestApi();
  late Login _login;
  Paging? paging;

  MasterSupplierBloc() : super(MasterSupplierInitial()) {
    on<MasterSupplierEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is SearchMstSupplier) {
          emit(MasterSupplierLoading());
          List<Supplier> listSupplier = await searchAllMstSupp(
            event.model,
            event.paging,
          );

          emit(LoadTable(listSupplier, paging));
        } else if (event is ToMstSupplierForm) {
          emit(MasterSupplierLoading());
          Supplier? submitSupplier;
          if (event.model != null) {
            submitSupplier = await getMstSupplier(
              event.model!,
            );
          }
          // var listCountry = await getListCountry();
          List<Countries> listCountry = await getListCountry();
          List<SystemMaster> listSysMaster =
              await searchSystemMaster("SUPPLIER_TYPE");
          emit(LoadForm(submitSupplier, listCountry, listSysMaster));
        } else if (event is DeleteSupplier) {
          emit(MasterSupplierLoading());
          await api.deleteMstSupplier(
            header: {
              "Authorization": "${_login.tokenType} ${_login.accessToken}"
            },
            supplierCd: event.supplierCd ?? "",
          );
          emit(SuppDeleted());
        } else if (event is SubmitMstSupplier) {
          emit(MasterSupplierLoading());
          try {
            await addMstSupplier(event.model);
            emit(MstSupplierAdd(
                "${event.model.supplierName} has been successfully added in Master Supplier"));
          } catch (e) {
            emit(MasterSupplierError(e.toString()));
          }
        } else if (event is EditMstSupplier) {
          emit(MasterSupplierLoading());
          try {
            await editMstSupplier(event.model);
            emit(MstSupplierEdit(
                "${event.model.supplierName} has been successfully updated in Master Supplier"));
          } catch (e) {
            emit(MasterSupplierError(e.toString()));
          }
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutMasterSupplier());
          }
        } else {
          emit(MasterSupplierError(e.toString()));
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

  refreshToken(DatabaseHelper db, {MasterSupplierEvent? event}) async {
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

  Future<List<Supplier>> searchAllMstSupp(
    Supplier model,
    Paging? paging,
    // String method, String url
  ) async {
    List<Supplier> listSupplier = [];
    Map<String, String> param = {
      "supplierCd": model.supplierCd ?? "",
      "clientId": "",
      "supplierTypeCd": model.supplierTypeCd ?? "",
      "supplierTypeName": model.supplierName ?? "",
    };

    if (paging != null) param.addAll(paging.toJson());
    var response = await api.searchMstSupplier(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: param,
    ) as Map<String, dynamic>;

    this.paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      Supplier listSup = Supplier.map(element);
      listSupplier.add(listSup);
    }
    return listSupplier;
  }

  Future<Supplier> getMasterSupplier(
    String? supplierCd,
    //  String method, String url
  ) async {
    late Supplier model;
    if (supplierCd != null) {
      var response = await api.getSupplier(
        // method,
        // url,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        supplierCd: supplierCd,
      ) as Map<String, dynamic>;

      model = Supplier.map(response);
    } else {
      model = Supplier();
    }
    return model;
  }

  Future<Supplier> getMstSupplier(
    // String supplierCd,
    Supplier model,
  ) async {
    //String method, String url
    var response = await api.getMstSupplier(
      // method,
      // url,
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      supplierCd: model.supplierCd!,
    ) as Map<String, dynamic>;
    return Supplier.map(response);
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

  addMstSupplier(
    Supplier model,
    // String method, String url
  ) async {
    var response = await api.addMstSupplier(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        // "Authorization":
        //     "Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI4ZDdlZmQ5NS04MGMzLTRkNTEtYjExMi04YTY5MDY3NDYwMzMiLCJzdWIiOiJhZG1pbi5BRiIsImF1dGhvcml0aWVzIjp7InJvbGVDZHMiOlsiYWRtaW5fcHJvZHVjdCIsIlJfSW5wdXRSb2xlXzAwMDEiXSwiaXNTdXBlckFkbWluIjpmYWxzZSwidXNlcm5hbWUiOm51bGwsImNvbXBhbnlDZCI6IkFGIiwiY29tcGFueU5hbWUiOiJQVC4gQWd1bmcgRmFkZWwiLCJzdXBwbGllckNkIjoiQUYiLCJzdXBwbGllck5hbWUiOiJQVC4gQWd1bmcgRmFkZWwifSwiaWF0IjoxNjg3NDE5MDg2LCJleHAiOjE2ODc0MjI2ODZ9.KRsz4of5ECBQJH3fmQKN08fEJ-QeSYti8GZkF6UiULo"
      },
      body: model.toAdd(),
    ) as Map<String, dynamic>;

    return response;
  }

  editMstSupplier(
    Supplier model,
    // String method, String url
  ) async {
    var response = await api.updateMstSupplier(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      body: model.toAdd(),
    ) as Map<String, dynamic>;

    return response;
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
}
