part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}


class GetHomeData extends HomeEvent {}

class DoLogout extends HomeEvent {
  final Login? login;

  DoLogout({this.login});
}

class GetMenu extends HomeEvent {}

class DoRefreshToken extends HomeEvent {
  final HomeEvent event;
  DoRefreshToken(this.event);
}
