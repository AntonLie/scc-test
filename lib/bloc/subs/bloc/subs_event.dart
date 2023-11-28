part of 'subs_bloc.dart';

@immutable
abstract class SubsEvent {}

class InitSubs extends SubsEvent {
  final String? pkgNm;
  final String? companyName;
  final String? packageTypeCd;
  final int? pkgCd;
  final Paging? paging;
  final String? companyCd;
  InitSubs({
    this.pkgNm,
    this.companyName,
    this.packageTypeCd,
    this.paging,
    this.companyCd,
    this.pkgCd,
  });
}

class ToViewSubs extends SubsEvent {
  final String? companyCd;
  final int? packageCd;
  final String? formMode;
  ToViewSubs({this.companyCd, this.packageCd, this.formMode});
}

class ToCreateSubs extends SubsEvent {
  final String? companyCd;
  final int? packageCd;
  final String? formMode;
  ToCreateSubs({this.companyCd, this.packageCd, this.formMode});
}

class SubmitEditSubs extends SubsEvent {
  final String? companyCd;
  final int? pkgCd;
  final int? newpkgCd;
  final ListSubsTable? data;
  final String? formMode;
  SubmitEditSubs({
    this.formMode,
    this.data,
    this.companyCd,
    this.pkgCd,
    this.newpkgCd,
  });
}

class SubmitNotify extends SubsEvent {
  final String? companyCd;
  final int? pkgCd;

  SubmitNotify({
    this.companyCd,
    this.pkgCd,
  });
}
