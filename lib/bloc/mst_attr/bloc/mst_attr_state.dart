part of 'mst_attr_bloc.dart';


abstract class MstAttrState {}

class MstAttrInitial extends MstAttrState {}

class MstAttrLoading extends MstAttrState {}

class MstAttrSuccess extends MstAttrState {}

class LoadTable extends MstAttrState {
  final Paging? paging;
  final List<MstAttribute> listModel;
  LoadTable(this.paging, this.listModel);
}

class AttrDeleted extends MstAttrState {}

class LoadForm extends MstAttrState {
  final List<SystemMaster> listAttrType;
  final List<SystemMaster> listAttrDataType;
  final MstAttribute? submitModel;
  LoadForm(this.listAttrType, this.listAttrDataType, this.submitModel);
}

class MstAttrSubmitted extends MstAttrState {
  final Paging? paging;
  final String msg;
  final List<MstAttribute> listModel;

  MstAttrSubmitted(this.msg, this.listModel, this.paging);
}

class MstAttrError extends MstAttrState {
  final String error;
  MstAttrError(this.error);
}

class OnLogoutMstAttr extends MstAttrState {}
