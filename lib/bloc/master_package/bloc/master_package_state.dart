part of 'master_package_bloc.dart';

@immutable
abstract class MasterPackageState {}

class MasterPackageInitial extends MasterPackageState {}

class PackageLoading extends MasterPackageState {}


class InitPackageList extends MasterPackageState {}

class OnLogout extends MasterPackageState {}

class PackageError extends MasterPackageState {
  final String error;
  PackageError(this.error);
}

class PackageFormLoaded extends MasterPackageState {
  final PackageData? model;
  final List<KeyVal> listColor;
  final List<KeyVal> listBlock;
  final List<KeyVal> listRoleAll;
  final String? msg;
  PackageFormLoaded(
    this.model,
    this.listColor,
    this.listBlock, this.listRoleAll, {
    this.msg,
  });
}

class PackageDataLoaded extends MasterPackageState {
  final List<PackageList>? data;
  final Paging? paging;
  PackageDataLoaded(
    this.data,
    this.paging,
  );
}

class MasterPackageSubmitLoading extends MasterPackageState{}

class LoadMenuList extends MasterPackageState {
  final role.RoleUser? model;
  LoadMenuList(this.model);
}

class LoadShape extends MasterPackageState {
  final role.MasterRole? model;
  LoadShape(this.model);
}

class PackageDataSubmited extends MasterPackageState {
  final String? msg;
  PackageDataSubmited(
    this.msg,
  );
}

class PackageDataDeleted extends MasterPackageState {}
