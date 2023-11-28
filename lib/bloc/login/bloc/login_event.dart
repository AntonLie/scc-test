part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SubmitLogin extends LoginEvent {
  final Login model;
  SubmitLogin(this.model);
}
