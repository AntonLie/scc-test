part of 'mst_usr_role_bloc.dart';

@immutable
abstract class MstUsrRoleEvent {}

class SetInitial extends MstUsrRoleEvent {}

class SearchMasterRole extends MstUsrRoleEvent {
  final MasterRole model;
  final Paging? paging;
  // final String method, url;
  SearchMasterRole({
    required this.model,
    this.paging,
    // required this.method,
    // required this.url,
  });
}

class UpdateMenuFeature extends MstUsrRoleEvent {
  // final String? roleCd;
  final MasterRole submitModel;
  // final String method, url;
  UpdateMenuFeature({
    // this.roleCd,
    required this.submitModel,
    // required this.method,
    // required this.url,
  });
}

class GetMenuFeature extends MstUsrRoleEvent {
  final String? roleCd;
  // final String method, url;
  GetMenuFeature({
    this.roleCd,
    // required this.method,
    // required this.url,
  });
}

class ToMasterRoleDialog extends MstUsrRoleEvent {
  final MasterRole? model;
  final String method, url;
  ToMasterRoleDialog({
    this.model,
    required this.method,
    required this.url,
  });
}

class ToMasterRoleForm extends MstUsrRoleEvent {
  final MasterRole? model;
  ToMasterRoleForm({this.model});
}

class SubmitMasterRole extends MstUsrRoleEvent {
  final String? formMode;
  final Paging? paging;
  final MasterRoleSubmit model;
  final MasterRole? modelRole;

  SubmitMasterRole(
    this.model,
    this.formMode,
    this.paging,
    this.modelRole,
  );
}

class DeleteRole extends MstUsrRoleEvent {
  final String username, validFrom;
  // final String method, url;
  DeleteRole({
    required this.username,
    required this.validFrom,
    // required this.method,
    // required this.url,
  });
}
