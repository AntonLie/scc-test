
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'system_event.dart';
part 'system_state.dart';

class SystemBloc extends Bloc<SystemEvent, SystemState> {
  RestApi api = RestApi();
  late Login _login;

  SystemBloc() : super(SystemInitial()) {
    var db = DatabaseHelper();

    on<SystemEvent>((event, emit) async {
      try {
        await _query(db);
        if (event is GetOption) {
          emit(SystemLoading());
          List<SystemMaster> listSysMst =
              await searchSystemMaster(event.systemTypeCd ?? "");
          emit(OptionLoaded(listSysMst));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutSystem());
          }
        } else if (e is InvalidSessionExpression) {
          await deleteUser(db);
          // print("Logout success..");
          emit(OnLogoutSystem());
        } else {
          emit(SystemError(e.toString()));
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

  refreshToken(DatabaseHelper db, {SystemEvent? event}) async {
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
}
