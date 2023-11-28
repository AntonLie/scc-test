
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/mon_log.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'mon_log_event.dart';
part 'mon_log_state.dart';

class MonLogBloc extends Bloc<MonLogEvent, MonLogState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;

  MonLogBloc() : super(MonLogInitial()) {
    on<MonLogEvent>((event, emit) async {
      var db = DatabaseHelper();

      try {
        await _query(db);
        if (event is SearchLog) {
          emit(LogLoading());
          List<LogModel> listLog = await searchLog(
            paging: event.paging,
            moduleName: event.moduleName,
            processId: event.processId,
            statusCd: event.statusCd,
            functionName: event.functionName,
            createdBy: event.createdBy,
            startDt: event.startDt,
            endDt: event.endDt,
          );
          emit(LogLoaded(listLog, paging));
        } else if (event is SearchFailLog) {
          emit(LogLoading());
          List<LogModel> listLog = await searchFailLog(
            paging: event.paging,
            moduleName: event.moduleName,
            processId: event.processId,
            functionName: event.functionName,
            createdBy: event.createdBy,
            startDt: event.startDt,
            endDt: event.endDt,
          );
          emit(LogFailLoaded(listLog, paging));
        } else if (event is InitFilters) {
          List<SystemMaster> listStatus =
              await searchSystemMaster("PROCESS_STS");
          List<SystemMaster> listMessageType =
              await searchSystemMaster("MESSAGE_LOG_TYPE");
          emit(LoadFilters(listStatus, listMessageType));
        } else if (event is CheckLog) {
          emit(LogChecking());
          await api.checkLog(
            event.processId,
            header: {
              "Authorization": "${_login.tokenType} ${_login.accessToken}"
            },
          );
          emit(LogChecked());
        } else if (event is SearchDtlLog) {
          emit(LogLoading());

          List<LogModel> listAgentTp = await searchLogDtlProcessId(
              paging: event.paging,
              location: event.location,
              messageId: event.messageId,
              messageDtl: event.messageDtl,
              processId: event.processId,
              messageType: event.messageType);

          emit(LogDtlLoad(listAgentTp, paging));
        } else if (event is SearchLogDetail) {
          emit(LogLoading());
          List<LogDetail> listAgentTp = await searchLogDtl(
              paging: event.paging,
              loc: event.loc,
              msgCd: event.msgCd,
              msgText: event.msgText,
              processId: event.processId);
          emit(LogDetailLoaded(listAgentTp, event.functionCd, paging));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutLog());
          }
        } else {
          emit(LogError(e.toString()));
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

  refreshToken(DatabaseHelper db, {MonLogEvent? event}) async {
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

  Future<List<LogModel>> searchLog({
    Paging? paging,
    String? processId,
    String? functionCd,
    String? systemCd,
    String? functionName,
    String? moduleName,
    String? createdBy,
    String? statusCd,
    String? startDt,
    String? endDt,
  }) async {
    List<LogModel> listResp = [];
    // DateTime now = DateTime.now();
    Map<String, String> param = {
      "processId": processId ?? "",
      "functionCd": functionCd ?? "",
      "systemCd": systemCd ?? "",
      "functionName": functionName ?? "",
      "moduleName": moduleName ?? "",
      "createdBy": createdBy ?? "",
      "status": statusCd ?? "",
      "startDt": startDt ??
          "", // convertDateToStringFormat(DateTime(now.year, now.month, now.day), "yyyy-MM-dd"),
      "endDt": endDt ??
          "", //convertDateToStringFormat(DateTime(now.year, now.month, now.day), "yyyy-MM-dd"),
    };
    if (paging != null) param.addAll(paging.toJson());
    var response = await api.searchAllLog(
      header: {"Authorization": "${_login.tokenType!} ${_login.accessToken!}"},
      param: param,
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      listResp.add(LogModel.fromJson(element));
    }
    return listResp;
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

  Future<List<LogDetail>> searchLogDtl(
      {Paging? paging,
      String? processId,
      String? loc,
      String? msgCd,
      String? msgText}) async {
    List<LogDetail> listItems = [];
    Map<String, String> params = {
      "msgCd": msgCd ?? "",
      "processId": processId ?? "",
      "loc": loc ?? "",
      "msgText": msgText ?? ""
    };
    if (paging != null) {
      params.addAll(paging.toJson());
    } else {
      params['pageNo'] = "1";
      params['pageSize'] = "100000";
    }
    var response = await api.searchLogDtl(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      param: params,
    );
    this.paging = Paging.map(response as Map<String, dynamic>);
    if (response['listData'] != null && response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listItems.add(LogDetail.map(element));
      }
    }
    return listItems;
  }

  Future<List<LogModel>> searchFailLog({
    Paging? paging,
    String? processId,
    String? functionCd,
    String? systemCd,
    String? functionName,
    String? moduleName,
    String? createdBy,
    String? startDt,
    String? endDt,
  }) async {
    List<LogModel> listResp = [];
    DateTime now = DateTime.now();
    Map<String, String> param = {
      "processId": processId ?? "",
      "functionCd": functionCd ?? "",
      "systemCd": systemCd ?? "",
      "functionName": functionName ?? "",
      "moduleName": moduleName ?? "",
      "createdBy": createdBy ?? "",
      "startDt": startDt ??
          convertDateToStringFormat(
              DateTime(now.year, now.month, now.day), "yyyy-MM-dd"),
      "endDt": endDt ??
          convertDateToStringFormat(
              DateTime(now.year, now.month, now.day), "yyyy-MM-dd"),
    };
    if (paging != null) param.addAll(paging.toJson());
    var response = await api.searchFailLog(
      header: {"Authorization": "${_login.tokenType!} ${_login.accessToken!}"},
      param: param,
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      listResp.add(LogModel.fromJson(element));
    }
    return listResp;
  }

  Future<List<LogModel>> searchLogDtlProcessId({
    Paging? paging,
    required String? processId,
    String? messageId,
    String? messageType,
    String? location,
    String? messageDtl,
  }) async {
    List<LogModel> listItems = [];
    Map<String, String> params = {
      "messageId": messageId ?? "",
      "messageType": messageType ?? "",
      "location": location ?? "",
      "messageDetail": messageDtl ?? "",
    };
    if (paging != null) {
      params.addAll(paging.toJson());
    } else {
      params['pageNo'] = "1";
      params['pageSize'] = "100000";
    }
    var response = await api.searchLogDtlProcessId(
      processId ?? "",
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      param: params,
    );
    this.paging = Paging.map(response as Map<String, dynamic>);
    if (response['listData'] != null && response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listItems.add(LogModel.fromJson(element));
      }
    }
    return listItems;
  }
}
