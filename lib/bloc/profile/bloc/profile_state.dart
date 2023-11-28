part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileView extends ProfileState {
  final Profile profile;
  final List<Menu>? listMenu;
  final List<Countries> listCountry;

  ProfileView(this.profile, this.listCountry, {this.listMenu});
}

class ProfileLoading extends ProfileState {}

class SubmitLoading extends ProfileState {}

class ProfileEdit extends ProfileState {
  final Profile profile;
  final List<Countries> listCountry;


  ProfileEdit(this.profile, this.listCountry);
}

class UpdateSuccess extends ProfileState {
  final String message;
  final Profile profile;
  final List<Countries> listCountry;

  UpdateSuccess(this.profile, this.message, this.listCountry);
}

class OnLogoutProfile extends ProfileState {}

class ProfileError extends ProfileState {
  final String error;
  ProfileError(this.error);
}
