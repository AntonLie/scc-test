part of 'master_product_bloc.dart';

abstract class MasterProductState {}

class MasterProductInitial extends MasterProductState {}

class ProductLoading extends MasterProductState {}

class InitProductList extends MasterProductState {}

class OnLogoutProduct extends MasterProductState {}

class ProductError extends MasterProductState {
  final String error;
  ProductError(this.error);
}

class AddEditProductError extends MasterProductState {
  final String error;
  AddEditProductError(this.error);
}

class ProductDataLoaded extends MasterProductState {
  final List<MasterProductModel>? data;
  final Paging? paging;
  ProductDataLoaded(
    this.data,
    this.paging,
  );
}

class ProductFormLoaded extends MasterProductState {
  final MasterProductModel? model;
  final String? msg;
  final List<SystemMaster> listSysMaster;
  final List<MstAttribute> listAttribute;

  ProductFormLoaded(this.model, this.listSysMaster, this.listAttribute,
      {this.msg});
}

class ProductDataDeleted extends MasterProductState {}

class AddProductSubmit extends MasterProductState {
  final String? msg;
  final Paging? paging;

  AddProductSubmit(this.msg, this.paging);
}

class EditProductSubmit extends MasterProductState {
  final String? msg;
  EditProductSubmit(this.msg);
}
