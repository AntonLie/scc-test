part of 'permitted_feat_bloc.dart';

abstract class PermittedFeatState {}

class PermittedFeatInitial extends PermittedFeatState {}

class PermittedFeatSuccess extends PermittedFeatState {
  PermittedFunc model;
  PermittedFeatSuccess(this.model);
}

class PermittedFeatLoading extends PermittedFeatState {}

class PermittedFeatError extends PermittedFeatState {
  String errMsg;

  PermittedFeatError(this.errMsg);
}

class OnLogoutPermittedFeat extends PermittedFeatState {}
