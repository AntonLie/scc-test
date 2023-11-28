part of 'mst_usr_role_bloc.dart';

@immutable
abstract class MstUsrRoleState {}

class MstUsrRoleInitial extends MstUsrRoleState {}

class MasterRoleInitial extends MstUsrRoleState {}

class MasterRoleLoading extends MstUsrRoleState {}

class UserRoleSubmitLoading extends MstUsrRoleState {}

class UserRoleSubmitted extends MstUsrRoleState {}

class OnLogoutMasterRole extends MstUsrRoleState {}

class MasterRoleError extends MstUsrRoleState {
  final String msg;
  MasterRoleError(this.msg);
}

class SearchMasterRoleSuccess extends MstUsrRoleState {
  final List<MasterRole> listMasterRole;
  final List<MasterRolee> listUserRole;
  final Paging? paging;
  SearchMasterRoleSuccess(this.listUserRole, this.listMasterRole, this.paging);
}

class LoadDialog extends MstUsrRoleState {
  final MasterRole model;
  LoadDialog(this.model);
}

class LoadMenuList extends MstUsrRoleState {
  final RoleUser? model;
  LoadMenuList(this.model);
}

class LoadShape extends MstUsrRoleState {
  final MasterRoleSubmit? model;
  final List<String> listBrand;
  final List<DataCompany> listCompany;
  final List<DataDivision> listDivision;
  final List<Countries> listCountry;
  final String? validFormDt;
  LoadShape(this.model, this.listCompany, this.listDivision, this.listBrand,
      this.listCountry, this.validFormDt);
}

class MasterRoleSubmitted extends MstUsrRoleState {
  final Paging? paging;
  final String msg;
  final List<MasterRole> listModel;
  // final String partName;
  MasterRoleSubmitted(
    this.msg,
    this.listModel,
    this.paging,
    /*this.partName*/
  );
}

class MasterRoleSubmitLoading extends MstUsrRoleState {}

class DeleteRoleSuccess extends MstUsrRoleState {}
