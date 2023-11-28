part of 'profile_bloc.dart';


abstract class ProfileEvent {}

class GetProfileData extends ProfileEvent {
  final bool? loadMenu;
  GetProfileData({this.loadMenu});
}

class UpdateProfileEvent extends ProfileEvent {}

class SubmitUpdateProfile extends ProfileEvent {
  final Profile model;
  SubmitUpdateProfile(this.model);
}

