part of 'new_edit_role_bloc.dart';

@immutable
abstract class NewEditRoleState {}

class NewEditRoleInitial extends NewEditRoleState {}

class NewEditRoleLoading extends NewEditRoleState {}

class OnLogoutNewEditRole extends NewEditRoleState {}

class DataRoleEditLoaded extends NewEditRoleState {
  final EditRoleForm? model;
  final List<ListMenuDropdown> listMenu;
  DataRoleEditLoaded(
    this.model,
    this.listMenu,
  );
}

class EditRoleError extends NewEditRoleState {
  final String msg;
  EditRoleError(this.msg);
}

class NewEditRoleSubmitted extends NewEditRoleState {
  final String msg;
  NewEditRoleSubmitted(this.msg);
}

class ListRoleLoaded extends NewEditRoleState {
  final List<ListDataNewEditRole> listData;
  final Paging? paging;
  ListRoleLoaded(
    this.listData,
    this.paging,
  );
}

class ListFeatLoaded extends NewEditRoleState {
  final List<ListFeature> listFeat;
  ListFeatLoaded(
    this.listFeat,
  );
}

class TempAttrDetailLoaded extends NewEditRoleState {
  final TempAttrDetail listTempAttrDtl;
  TempAttrDetailLoaded(this.listTempAttrDtl);
}

class EditRoleDeleted extends NewEditRoleState {}
