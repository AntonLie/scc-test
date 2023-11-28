part of 'assign_mst_item_bloc.dart';

abstract class AssignMstItemState {}

class AssignMstItemInitial extends AssignMstItemState {}

class MstItemLoading extends AssignMstItemState {}

class InitMstItemList extends AssignMstItemState {}

class OnLogoutMstItem extends AssignMstItemState {}

class LoadUpload extends AssignMstItemState {}

class SuccesUpload extends AssignMstItemState {
  final MessageUpload? messageUpload;
  SuccesUpload(this.messageUpload);
}

class MstItemError extends AssignMstItemState {
  final String error;
  MstItemError(this.error);
}

class MstItemUploadError extends AssignMstItemState {
  final String error;
  MstItemUploadError(this.error);
}

class MstItemLoaded extends AssignMstItemState {
  final List<AssignMstItem>? data;
  final Paging? paging;
  final List<SystemMaster> listSysMaster;
  final List<KeyVal> listPoint;
  final List<ListUseCaseData> listUseCase;

  MstItemLoaded(
    this.data,
    this.paging,
    this.listSysMaster,
    this.listPoint,
    this.listUseCase,
  );
}

class MstItemFormLoaded extends AssignMstItemState {
  final AssignMstItem? model;
  final String? msg;

  MstItemFormLoaded(this.model, {this.msg});
}

class MstItemAdd extends AssignMstItemState {
  final String? msg;
  MstItemAdd(this.msg);
}

class MstItemGetProduct extends AssignMstItemState {
  final String? pointCd;
  MstItemGetProduct(this.pointCd);
}
