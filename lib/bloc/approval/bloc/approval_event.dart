part of 'approval_bloc.dart';

@immutable
abstract class ApprovalEvent {}

class LoadFormApproval extends ApprovalEvent {
  final String? formMode;
  final String? itemCd;
  final String? supplierCd;
  LoadFormApproval({this.supplierCd, this.itemCd, this.formMode});
}

class GetApprovalData extends ApprovalEvent {
  final Paging? paging;
  final ListApproval? model;

  GetApprovalData({this.paging, this.model});
}

class SubmitApproval extends ApprovalEvent {
  final String? approv;
  final GetViewApp? model;
  SubmitApproval(this.approv, {this.model});
}
