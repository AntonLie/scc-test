
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/permitted_func_feat.dart';
import 'package:scc_web/services/restapi.dart';

part 'permitted_feat_event.dart';
part 'permitted_feat_state.dart';

class PermittedFeatBloc extends Bloc<PermittedFeatEvent, PermittedFeatState> {
  RestApi api = RestApi();
  late Login _login;

  PermittedFeatBloc() : super(PermittedFeatInitial()) {
    on<PermittedFeatEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
      await _query(db);
      if (event is GetPermitted) {
        emit(PermittedFeatLoading());
        PermittedFunc model = await getPermittdFF(event.menuCd);
        emit(PermittedFeatSuccess(model));
      }
    } catch (e) {
      if (e is UnauthorisedException) {
        try {
          await refreshToken(db, event: event);
        } catch (e) {
          // print(e.toString());
          await deleteUser(db);
          // print("Logout success..");
          emit(OnLogoutPermittedFeat());
        }
      } else {
        emit(PermittedFeatError(e.toString()));
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

  refreshToken(DatabaseHelper db, {PermittedFeatEvent? event}) async {
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

  Future<PermittedFunc> getPermittdFF(String menuCd) async {
    var response =
        await api.getPermittdFeat(header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"}, menuCd: menuCd) as Map<String, dynamic>;
    return PermittedFunc.fromJson(response);
  }

 
}
