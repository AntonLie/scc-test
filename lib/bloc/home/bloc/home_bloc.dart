// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  RestApi api = RestApi();
  late Login _login;
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is GetHomeData) {
          emit(HomeLoading());

          emit(LoadHome(_login));
        } else if (event is GetMenu) {
          emit(HomeLoading());
          List<Menu> listMenu = await permittedMenu();
          List<SystemMaster> listSysMaster =
              await searchSystemMaster("admin.SCC");
          emit(MenuLoaded(listMenu, _login, listSysMaster));
        } else if (event is DoRefreshToken) {
          await refreshToken(db);

          emit(LoadHome(_login));
        } else if (event is DoLogout) {
          //? JIKA EVENT ADALAH DO LOGOUT
          emit(HomeLoading()); //? KELUARKAN STATE LOADING
          DateTime now = DateTime.now(); //? MULAI PROSES
          DateTime date = convertStringToDateFormat(
              _login.refreshTokenExpDate!, "dd-MMM-yyyy HH:mm:ss");
          bool isRefreshTokenExpired =
              (date.difference(now).inSeconds).isNegative;
          // !tester
          // int difference = date.difference(now).inSeconds;
          // if (difference > 100) throw UnauthorisedException();
          // print("Prepare for logout..");
          if (!isRefreshTokenExpired) await logout();
          await deleteUser(db);
          // print("Logout success..");
          emit(OnLogoutHome()); //? SETELAH PROSES SELESAI, KELUARKAN STATE BARU
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutHome());
          }
        } else if (e is InvalidSessionExpression) {
          await deleteUser(db);
          // print("Logout success..");
          emit(OnLogoutHome());
        } else {
          emit(HomeError(e.toString()));
        }
      }
    });
  }

  refreshToken(DatabaseHelper db, {HomeEvent? event}) async {
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

  logout() async {
    // print('Logout..');
    await api.logout(
        header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
        body: _login.toLogout());
  }

  Future<List<Menu>> permittedMenu() async {
    List<Menu> listMenu = [];
    var response = await api.permittedMenu(
      headers: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
    );
    if (response['menus'] != null && response['menus'] is List) {
      for (var element in (response['menus'] as List)) {
        listMenu.add(Menu.map(element));
      }
    }
    return listMenu;
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
