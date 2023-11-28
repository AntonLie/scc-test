part of 'approval_bloc.dart';

@immutable
abstract class ApprovalState {}

class ApprovalInitial extends ApprovalState {}

class ApprovalLoading extends ApprovalState {}

class DataApproval extends ApprovalState {
  final List<ListApproval>? model;
  final Paging? paging;
  final List<KeyVal> listSupp;
  final List<SystemMaster> listSysMaster;

  DataApproval(
    this.model,
    this.paging,
    this.listSupp,
    this.listSysMaster,
  );
}

class SuccessApprov extends ApprovalState {
  final String msg;
  SuccessApprov(this.msg);
}

class ApprovalForm extends ApprovalState {
  final GetViewApp? model;
  ApprovalForm(
    this.model,
  );
}

class ApprovalError extends ApprovalState {
  final String msg;
  ApprovalError(this.msg);
}

class OnLogoutApproval extends ApprovalState {}
