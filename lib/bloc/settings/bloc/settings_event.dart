part of 'settings_bloc.dart';

class SettingsEvent {}

class SetInitial extends SettingsEvent {}

class SetResetPassword extends SettingsEvent {}

class InitResetPassword extends SettingsEvent {
  final Password model;
  InitResetPassword(this.model);
}

class SubmitResetPassword extends SettingsEvent {}

class SetChangePassword extends SettingsEvent {}

class InitChangePassword extends SettingsEvent {}

class SubmitChangePassword extends SettingsEvent {
  final Password model;
  SubmitChangePassword(this.model);
}
