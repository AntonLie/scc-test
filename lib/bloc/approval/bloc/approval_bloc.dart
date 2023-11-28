import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/approval.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'approval_event.dart';
part 'approval_state.dart';

class ApprovalBloc extends Bloc<ApprovalEvent, ApprovalState> {
  RestApi api = RestApi();

  Paging? paging;

  late Login _login;
  ApprovalBloc() : super(ApprovalInitial()) {
    on<ApprovalEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is GetApprovalData) {
          emit(ApprovalLoading());
          List<ListApproval> searchPointList =
              await searchApproval(event.paging, event.model);
          List<KeyVal> listSupp = await searchAllMstSupp();
          List<SystemMaster> listSysMaster =
              await searchSystemMaster("USECASE_ITEM_STATUS");
          emit(DataApproval(searchPointList, paging, listSupp, listSysMaster));
        } else if (event is LoadFormApproval) {
          emit(ApprovalLoading());

          GetViewApp model = await viewApproval(event.itemCd, event.supplierCd);
          emit(ApprovalForm(model));
        } else if (event is SubmitApproval) {
          emit(ApprovalLoading());
          String msg = await submitForm(event.model!, event.approv);
          emit(SuccessApprov(msg));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success");
            emit(OnLogoutApproval());
          }
        } else if (e is InvalidInputException) {
          await deleteUser(db);
          // print("Logout success");
          emit(OnLogoutApproval());
        } else {
          emit(ApprovalError(e.toString()));
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

  refreshToken(DatabaseHelper db, {ApprovalEvent? event}) async {
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

  Future<List<ListApproval>> searchApproval(
    Paging? paging,
    ListApproval? model,
    // String method,
    // String url,
  ) async {
    List<ListApproval> listApp = [];
    Map<String, String> params = {
      "supplierCd": model!.supplierCd ?? "",
      "searchBy": model.searchBy ?? "",
      "statusCd": model.statusCd ?? "",
      "searchValue": model.searchValue ?? "",
    };
    if (paging != null) params.addAll(paging.toJson());
    var response = await api.searchApproval(
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
        listApp.add(ListApproval.fromJson(element));
      }
    }
    //// print(response);

    return listApp;
  }

  Future<List<KeyVal>> searchAllMstSupp() async {
    List<KeyVal> listSupplier = [];
    Map<String, String> param = {
      "pageSize": "1000",
      "pageNo": "1",
      "supplierCd": "",
      "clientId": "",
      "supplierTypeCd": "",
      "supplierTypeName": "",
    };

    var response = await api.searchMstSupplier(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: param,
    ) as Map<String, dynamic>;
    if (response['listData'] != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listSupplier
              .add(KeyVal(element["supplierName"], element["supplierCd"]));
        }
      }
    }

    return listSupplier;
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

  Future<GetViewApp> viewApproval(String? itemCd, String? supplierCd) async {
    Map<String, String> params = {
      "itemCd": itemCd ?? "",
      "supplierCd": supplierCd ?? ""
    };
    var response = await api.viewApproval(
      // method,
      // url,
      param: params,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;

    return GetViewApp.fromJson(response);
  }

  Future<String> submitForm(
    GetViewApp model,
    String? approv,
    // String createMethod,
    // String createUrl,
    // String updateMethod,
    // String updateUrl,
  ) async {
    String message = "";

    if (approv == Constant.PNS_APPROVED) {
      await api.submitApproval(
        // createMethod,
        // createUrl,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toSubmit(),
      ) as Map;
      message =
          "${model.useCaseName ?? "[Username]"} has been successfully Approved.";
    } else {
      await api.submitApproval(
          // updateMethod,
          // updateUrl,
          header: {
            "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
          },
          body: model.toSubmit()) as Map;
      message =
          "${model.useCaseName ?? "[UserName]"} has been successfully Rejected.";
    }

    return message;
  }
}
