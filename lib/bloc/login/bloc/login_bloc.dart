// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  RestApi api = RestApi();
  Login _login = Login();
  DatabaseHelper db = DatabaseHelper();
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        if (event is SubmitLogin) {
          emit(LoginLoading());
          await login(event.model);
          try {
            // print("Saving to Shared Preferences");
            await db.saveUser(_login);
          } catch (e) {
            throw "Terjadi Kesalahan : $e";
          }
          // print("Shared Preferences saved successfully");
          List<Menu> listMenu = await permittedMenu();
          listMenu
              .sort((a, b) => (a.menuSeq ?? 0).compareTo(b.menuSeq ?? 1000));
          List<SystemMaster> listSysMaster =
              await searchSystemMaster("admin.SCC");
          emit(LoginSuccess(listMenu, listSysMaster));
        }
      } catch (e) {
        String msg = '';
        if (e.toString().number == '406') {
          msg =
              "We couldn't find account matching to this identifier. Please check your username and password and try again.";
        } else {
          msg = e.toString();
        }
        emit(LoginError(msg));
      }
    });
  }
  dynamic login(Login data) async {
    var result = await api.login(
      body: data.toLogin(),
    ) as Map<String, dynamic>;

    _login = Login.map(result);
    _login.username = data.username;
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
