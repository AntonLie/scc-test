part of 'master_supplier_bloc.dart';


abstract class MasterSupplierEvent {}

class SetInitial extends MasterSupplierEvent {}

class SearchMstSupplier extends MasterSupplierEvent {
  final Paging? paging;
  final Supplier model;
  // final String method, url;
  SearchMstSupplier({
    this.paging,
    required this.model,
    // required this.method, required this.url
  });
}

class ToMstSupplierForm extends MasterSupplierEvent {
  // final String? supplierCd;
  final Supplier? model;
  // final String method, url;
  ToMstSupplierForm({
    this.model,
    // required this.method, required this.url
  });
}

class SubmitMstSupplier extends MasterSupplierEvent {
  final Supplier model;
  SubmitMstSupplier(this.model);
}

class DeleteSupplier extends MasterSupplierEvent {
  final String? supplierCd;
  DeleteSupplier({required this.supplierCd});
}

class EditMstSupplier extends MasterSupplierEvent {
  final Supplier model;
  EditMstSupplier(this.model);
}
