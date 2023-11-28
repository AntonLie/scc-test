part of 'auth_bloc.dart';


abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoggedIn extends AuthState {}

class AuthLoggedOut extends AuthState {}

class AuthError extends AuthState {
  final String errMsg;

  AuthError(this.errMsg);
}
