part of 'master_package_bloc.dart';

@immutable
abstract class MasterPackageEvent {}

class ToPackageForm extends MasterPackageEvent {
  final int? pkgCd;
  ToPackageForm({
    this.pkgCd,
  });
}

class GetPackageData extends MasterPackageEvent {
  final Paging? paging;
  final String? pkgNm;
  GetPackageData({
    this.paging,
    this.pkgNm,
  });
}

class SubmitPackageForm extends MasterPackageEvent {
  final String formMode;
  final PackageData model;

  SubmitPackageForm(
    this.model,
    this.formMode,
  );
}

class DeletePackageData extends MasterPackageEvent {
  final int? pckCd;
  DeletePackageData({
    this.pckCd,
  });
}

class LoadMenu extends MasterPackageEvent {
  final role.RoleUser? model;
  LoadMenu(this.model);
}

class GetMenuFeature extends MasterPackageEvent {
  final String? roleCd;
  // final String method, url;
  GetMenuFeature({
    this.roleCd,
    // required this.method,
    // required this.url,
  });
}
