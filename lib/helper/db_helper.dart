import 'dart:convert';

import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/model/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DatabaseHelper {
  Future saveUser(Login login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map loginMap = login.toMap();
    String jsonBody = json.encode(loginMap);

    await prefs.setString('Login', jsonBody);
  }

  Future<Login?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Login? log;
    try {
      String? jsonBody = prefs.getString('Login');
      if (jsonBody != null) {
        final map = json.decode(jsonBody) as Map<String, dynamic>;
        log = Login.map(map);
      }
    } catch (e) {
      throw InvalidSessionExpression('Session is Expired');
    }

    return log;
  }

  Future dbClear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
