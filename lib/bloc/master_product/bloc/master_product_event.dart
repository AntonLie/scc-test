part of 'master_product_bloc.dart';


abstract class MasterProductEvent {}

class ToProductForm extends MasterProductEvent {
  final MasterProductModel? model;
  ToProductForm({this.model});
}

class GetProductData extends MasterProductEvent {
  final Paging? paging;
  final MasterProductModel model;
  GetProductData({this.paging, required this.model});
}

class DeleteProductData extends MasterProductEvent {
  final String? productCd;
  DeleteProductData({
    this.productCd,
  });
}

class AddProductData extends MasterProductEvent {
  final MasterProductModel model;
  final String? formMode;
  final Paging? paging;
  AddProductData(this.model, this.formMode, this.paging);
}

class EditProductData extends MasterProductEvent {
  final MasterProductModel model;

  EditProductData(this.model);
}
