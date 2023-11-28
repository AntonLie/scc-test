part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class PartMovLoading extends HomeState {}

class ToRefreshToken extends HomeState {
  final HomeEvent event;
  ToRefreshToken(this.event);
}

class TokenRefreshed extends HomeState {
  final HomeEvent event;
  TokenRefreshed(this.event);
}

class MenuLoaded extends HomeState {
  final List<Menu> listMenu;
  final Login login;
  final List<SystemMaster> listSysMaster;
  MenuLoaded(this.listMenu, this.login, this.listSysMaster);
}

class LoadHome extends HomeState {
  final Login login;

  LoadHome(this.login);
}

class OnLogoutHome extends HomeState {}

class HomeError extends HomeState {
  final String error;
  HomeError(this.error);
}
