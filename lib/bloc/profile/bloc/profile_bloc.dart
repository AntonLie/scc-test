import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/countries.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/model/profile.dart';
import 'package:scc_web/services/restapi.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  RestApi api = RestApi();
  late Login _login;

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      var db = DatabaseHelper();

      try {
        await _query(db);
        if (event is GetProfileData) {
          emit(ProfileLoading());

          Profile profile = await getProfile();
          List<Countries> listCountry = await getListCountry();

          emit(ProfileView(profile, listCountry));
        } else if (event is UpdateProfileEvent) {
          emit(ProfileLoading());
          Profile profile = await getProfile();
          List<Countries> listCountry = await getListCountry();

          emit(ProfileEdit(profile, listCountry));
        } else if (event is SubmitUpdateProfile) {
          emit(SubmitLoading());
          String msg = await updateProfile(event.model);
          Profile profile = await getProfile();
          List<Countries> listCountry = await getListCountry();

          emit(UpdateSuccess(profile, msg, listCountry));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success..");
            emit(OnLogoutProfile());
          }
        } else {
          emit(ProfileError(e.toString()));
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

  refreshToken(DatabaseHelper db, {ProfileEvent? event}) async {
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

  Future<Profile> getProfile() async {
    var response = await api.getProfile(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;
    return Profile.fromJson(response);
  }

  Future<String> updateProfile(Profile model) async {
    var response = await api.updateProfile(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      body: model.toUpdate(),
    ) as Map<String, dynamic>;
    return "${response['status']} : ${response['message']}";
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
}
