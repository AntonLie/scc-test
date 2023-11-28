part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final List<Menu> listMenu;
  final List<SystemMaster> listSysMaster;

  LoginSuccess(this.listMenu, this.listSysMaster);
}

class LoginError extends LoginState {
  final String msg;
  LoginError(this.msg);
}
