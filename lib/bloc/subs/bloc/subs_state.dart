part of 'subs_bloc.dart';

@immutable
abstract class SubsState {}

class SubsInitial extends SubsState {}

class SubsLoading extends SubsState {}

class InitLoadedSubs extends SubsState {}

class OnLogout extends SubsState {}

class SubsError extends SubsState {
  final String msg;
  SubsError(
    this.msg,
  );
}

class SubsEditLoaded extends SubsState {}

class SubsEditSubmitted extends SubsState {
  final String msg;
  SubsEditSubmitted(
    this.msg,
  );
}

class SubsNotifySubmitted extends SubsState {
  final String msg;
  SubsNotifySubmitted(
    this.msg,
  );
}

class SubsCriteriaLoaded extends SubsState {
  final List<PackageList>? listPackage;
  final List<SystemMaster> listNumPeriod;

  SubsCriteriaLoaded(
    this.listPackage,
    this.listNumPeriod,
  );
}

class SubsDataTableLoaded extends SubsState {
  final List<ListSubsTable>? data;
  final TotalSubs total;
  final List<KeyVal> listTypeProduct;
  final Paging? paging;
  final List<PackageList>? dataPackage;


  final List<KeyVal> listSystem;
  SubsDataTableLoaded(
    this.data,
    this.total,
    this.paging,
    this.listTypeProduct,
    this.listSystem, this.dataPackage,
  );
}

class ViewSubs extends SubsState {
  final ListSubsTable? data;
   final List<Countries> listCountry;
  ViewSubs(this.data, this.listCountry);
}

class CreateSubs extends SubsState {
  final ListSubsTable? data;
  CreateSubs(this.data);
}
