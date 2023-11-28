part of 'use_case_bloc.dart';

@immutable
abstract class UseCaseState {}

class UseCaseInitial extends UseCaseState {}

class UseCaseLoading extends UseCaseState {}

class DataUseCase extends UseCaseState {
  final List<ListUseCaseData>? model;
  final Paging? paging;

  DataUseCase(
    this.model,
    this.paging,
  );
}

class OnLogoutUseCase extends UseCaseState {}

class UseCaseForm extends UseCaseState {
  final ListUseCaseData? model;
  final List<KeyVal> listAttr;
  final List<KeyVal> listPoint;
  final List<KeyVal> listTouch;
  UseCaseForm(this.listAttr, this.listPoint, this.listTouch, this.model);
}

class UseCaseError extends UseCaseState {
  final String msg;
  UseCaseError(this.msg);
}

class UseCaseSubmited extends UseCaseState {
  final String? msg;
  UseCaseSubmited(
    this.msg,
  );
}

class UseCaseDeleted extends UseCaseState {}
