import 'dart:convert';

class Login {
  String? tokenType;
  String? accessToken;
  String? accessTokenExpDate;
  int? accessTokenAge;
  String? refreshToken;
  String? refreshTokenExpDate;
  int? refreshTokenAge;
  String? username;
  String? password;

  Login(
      {this.tokenType,
      this.accessToken,
      this.accessTokenExpDate,
      this.accessTokenAge,
      this.refreshToken,
      this.refreshTokenExpDate,
      this.refreshTokenAge,
      this.username,
      this.password});

  Login.map(Map<String, dynamic> obj) {
    tokenType = obj['tokenType'];
    accessToken = obj['accessToken'];
    accessTokenExpDate = obj['accessTokenExpDate'];
    accessTokenAge = obj['accessTokenAge'];
    refreshToken = obj['refreshToken'];
    refreshTokenExpDate = obj['refreshTokenExpDate'];
    refreshTokenAge = obj['refreshTokenAge'];
    username = obj['username'];
    password = obj['password'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['tokenType'] = tokenType;
    data['accessToken'] = accessToken;
    data['accessTokenExpDate'] = accessTokenExpDate;
    data['accessTokenAge'] = accessTokenAge;
    data['refreshToken'] = refreshToken;
    data['refreshTokenExpDate'] = refreshTokenExpDate;
    data['refreshTokenAge'] = refreshTokenAge;
    data['username'] = username;
    return data;
  }

  Map<String, dynamic> toLogin() {
    Map<String, dynamic> data = {};
    data['username'] = username;
    data['password'] = base64.encode(utf8.encode(password ?? ""));
    return data;
  }

  Map<String, dynamic> toRefresh() {
    Map<String, dynamic> data = {};
    data['refreshToken'] = refreshToken;
    data['username'] = username;
    return data;
  }

  Map<String, dynamic> toLogout() {
    Map<String, dynamic> data = {};
    data['accessToken'] = accessToken;
    data['username'] = username;
    return data;
  }
}
