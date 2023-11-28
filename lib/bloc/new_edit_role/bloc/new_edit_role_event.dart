part of 'new_edit_role_bloc.dart';

@immutable
abstract class NewEditRoleEvent {}

class ToNewEditRoleForm extends NewEditRoleEvent {
  final String? roleCd;
  ToNewEditRoleForm({this.roleCd});
}

class GetFeatList extends NewEditRoleEvent {
  final String? menuCd;
  GetFeatList({this.menuCd});
}

class ToTempAttrDetail extends NewEditRoleEvent {
  final String? tmplAttrCd;
  ToTempAttrDetail({
    this.tmplAttrCd,
  });
}

class InitNewEditRole extends NewEditRoleEvent {
  final Paging? paging;
  final String? roleName;
  InitNewEditRole({
    this.paging,
    this.roleName,
  });
}

class SubmitPoint extends NewEditRoleEvent {
  final String formMode;
  final Paging? paging;
  final EditRoleForm model;

  SubmitPoint(
    this.model,
    this.formMode, {
    this.paging,
  });
}

class SubmitNewEditRole extends NewEditRoleEvent {
  final String formMode;
  final EditRoleForm model;

  SubmitNewEditRole(
    this.model,
    this.formMode,
  );
}

class DeleteEditRole extends NewEditRoleEvent {
  final String? roleCd;
  DeleteEditRole({
    required this.roleCd,
  });
}

class GetListSystemMaster extends NewEditRoleEvent {
  final Paging? paging;
  final String? systemValue;
  GetListSystemMaster({
    this.paging,
    this.systemValue,
  });
}

class GetListCompanyPoint extends NewEditRoleEvent {
  final Paging? paging;
  final String? companyCd;
  final String? companyName;
  GetListCompanyPoint({
    this.paging,
    this.companyCd,
    this.companyName,
  });
}

class GetPointLoad extends NewEditRoleEvent {
  final Point model;
  GetPointLoad(this.model);
}
