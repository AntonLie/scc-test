import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/password.dart';
import 'package:scc_web/services/restapi.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  RestApi api = RestApi();
  late Login _login;

  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsEvent>((event, emit) async {
      var db = DatabaseHelper();

      try {
        await _query(db);
        if (event is SubmitChangePassword) {
          emit(ChangePasswordLoading());
          await updatePassword(event.model);
          emit(ChangePassSubmit());
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutSettings());
          }
        } else {
          emit(SettingsError(e.toString()));
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

  refreshToken(DatabaseHelper db, {SettingsEvent? event}) async {
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

  updatePassword(Password model) async {
    var response = await api.updatePassword(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      body: model.updatePass(),
    ) as Map<String, dynamic>;

    return response;
  }
}
