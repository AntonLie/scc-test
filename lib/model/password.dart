class Password {
  String? currentPassword;
  String? password;
  String? confirmPassword;

  Password({this.currentPassword, this.password, this.confirmPassword});

  Password.fromJson(Map<String, dynamic> json) {
    currentPassword = json['currentPassword'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['currentPassword'] = currentPassword;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    return data;
  }

  Password.map(Map<String, dynamic> obj) {
    currentPassword = obj['currentPassword'];
    password = obj['password'];
    confirmPassword = obj['confirmPassword'];
  }

  Map<String, dynamic> updatePass() {
    final Map<String, dynamic> data = {};

    data['currentPassword'] = currentPassword;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;

    return data;
  }
}
