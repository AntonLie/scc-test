import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/company.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/mon_agent.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'mon_agent_event.dart';
part 'mon_agent_state.dart';

class MonAgentBloc extends Bloc<MonAgentEvent, MonAgentState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;

  MonAgentBloc() : super(MonAgentInitial()) {
    on<MonAgentEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is LoadMenuAgents) {
          emit(AgentsLoading());
          List<Company> listCompany = await searchCompany();
          List<SystemMaster> listStatus =
              await searchSystemMaster("AGENT_MONITORING_STATUS");
          List<Agent> listAgents =
              await getDataAgent(Paging(pageNo: 1, pageSize: 5));
          emit(MenuAgentsLoaded(listCompany, listStatus, listAgents, paging));
        } else if (event is SearchAgentTp) {
          emit(AgentsLoading());
          List<AgentTp> listAgentTp = await searchAgentTp(event.paging,
              event.pointCd, event.pointName, event.clientId, event.status);
          emit(AgentTpLoaded(event.clientId, event.pointCd, event.pointName,
              listAgentTp, paging));
        } else if (event is GetAgentsLists) {
          emit(AgentsLoading());
          List<Agent> listAgents = await getDataAgent(event.paging,
              clientId: event.clientId,
              companyCd: event.companyCd,
              status: event.status);
          emit(AgentsLoaded(listAgents, paging));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutAgents());
          }
        } else {
          emit(AgentsError(e.toString()));
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

  refreshToken(DatabaseHelper db, {MonAgentEvent? event}) async {
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

  Future<List<Company>> searchCompany() async {
    List<Company> listCompany = [];
    var response = await api.searchCompanyAgent(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
    ) as Map<String, dynamic>;
    // print(response);
    // print("ini response\n");
    if (response['listCompanyTenant'] != null &&
        response['listCompanyTenant'] is List) {
      for (var element in (response['listCompanyTenant'] as List)) {
        listCompany.add(Company.map(element));
      }
    }
    return listCompany;
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

  Future<List<Agent>> getDataAgent(Paging? paging,
      {String? companyCd, String? clientId, String? status}) async {
    List<Agent> listResp = [];
    Map<String, String> param = {};
    if (paging != null) param.addAll(paging.toJson());
    param['supplierCd'] = companyCd == null
        ? ""
        : companyCd == "ALL"
            ? ""
            : companyCd;
    param['clientId'] = clientId ?? "";
    param['status'] = status == "All" ? "" : status ?? "";
    var response = await api.getAgentDataTable(
      header: {"Authorization": "${_login.tokenType!} ${_login.accessToken!}"},
      param: param,
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);
    for (var element in (response['listData'] as List)) {
      listResp.add(Agent.map(element));
    }
    return listResp;
  }

  Future<List<AgentTp>> searchAgentTp(Paging? paging, String? pointCd,
      String? pointName, String? clientId, String? status) async {
    List<AgentTp> listItems = [];
    Map<String, String> params = {
      "clientId": clientId ?? "",
      "pointCd": pointCd ?? "",
      "pointName": pointName ?? "",
    };
    params['status'] = status == "All" ? "" : status ?? "";

    if (paging != null) params.addAll(paging.toJson());
    var response = await api.searchAgentTp(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      param: params,
    );
    this.paging = Paging.map(response as Map<String, dynamic>);
    if (response['listData'] != null && response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listItems.add(AgentTp.map(element));
      }
    }
    return listItems;
  }
}
