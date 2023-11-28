part of 'master_supplier_bloc.dart';


abstract class MasterSupplierState {}

class MasterSupplierInitial extends MasterSupplierState {}

class MasterSupplierLoading extends MasterSupplierState {}

class MasterSupplierError extends MasterSupplierState {
  final String msg;
  MasterSupplierError(this.msg);
}

class OnLogoutMasterSupplier extends MasterSupplierState {}

class LoadTable extends MasterSupplierState {
  final List<Supplier> listSupplier;

  final Paging? paging;
  LoadTable(this.listSupplier, this.paging);
}

class LoadForm extends MasterSupplierState {
  final Supplier? submitSupplier;
  final List<Countries> listCountry;
  final List<SystemMaster> listSysMaster;

  LoadForm(this.submitSupplier, this.listCountry, this.listSysMaster);
}

class MasterSuppSubmitted extends MasterSupplierState {
  final Paging? paging;
  final String msg;
  final List<Supplier> listModel;
  MasterSuppSubmitted(this.msg, this.listModel, this.paging);
}

class SuppDeleted extends MasterSupplierState {}

class MstSupplierAdd extends MasterSupplierState {
  final String? msg;
  MstSupplierAdd(this.msg);
}

class MstSupplierEdit extends MasterSupplierState {
  final String? msg;
  MstSupplierEdit(this.msg);
}
