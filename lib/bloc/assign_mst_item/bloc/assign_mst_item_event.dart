part of 'assign_mst_item_bloc.dart';


abstract class AssignMstItemEvent {}

class ToMstItemForm extends AssignMstItemEvent {
  final AssignMstItem? model;
  ToMstItemForm({this.model});
}

class GetMstItemData extends AssignMstItemEvent {
  final Paging? paging;
  final AssignMstItem model;
  GetMstItemData({this.paging, required this.model});
}

class SubmitMstItemData extends AssignMstItemEvent {
  final AssignMstItem model;
  SubmitMstItemData(this.model);
}

class ToMstItemAddEdit extends AssignMstItemEvent {
  final AssignMstItem? model;
  ToMstItemAddEdit({this.model});
}

class UploadMstItem extends AssignMstItemEvent {
  final AssignMstItem model;
  final Paging? paging;

  UploadMstItem(this.model, this.paging);
}

class GetProductName extends AssignMstItemEvent {
  final String? pointCd;
  GetProductName(this.pointCd);
}

class UploadBillMaterial extends AssignMstItemEvent {
  final AssignMstItem model;
  final Paging? paging;

  UploadBillMaterial(this.model, this.paging);
}
