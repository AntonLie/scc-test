part of 'system_bloc.dart';


abstract class SystemState {}

class SystemInitial extends SystemState {}

class SystemLoading extends SystemState {}

class OptionLoaded extends SystemState {
  final List<SystemMaster> listData;
  OptionLoaded(
    this.listData,
  );
}

class OnLogoutSystem extends SystemState {}

class SystemError extends SystemState {
  final String error;
  SystemError(this.error);
}
