part of 'settings_bloc.dart';

class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class ResetPasswordLoading extends SettingsState {}

class SetInitState extends SettingsState {
  final Map<String, String> pageParams;
  SetInitState(this.pageParams);
}

class ResetPassInitState extends SettingsState {
  final String email;
  ResetPassInitState(this.email);
}

class ResetPasswordState extends SettingsState {}

class ResetEmailSent extends SettingsState {
  final String message;
  ResetEmailSent(this.message);
}

class ChangePasswordState extends SettingsState {}

class ChangePasswordLoading extends SettingsState {}

class ChangePassInitState extends SettingsState {}

class ChangePassSubmit extends SettingsState {}

class OnLogoutSettings extends SettingsState {}

class SettingsError extends SettingsState {
  final String error;
  SettingsError(this.error);
}
