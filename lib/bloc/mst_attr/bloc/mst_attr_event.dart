part of 'mst_attr_bloc.dart';


abstract class MstAttrEvent {}

class SearchMstAttr extends MstAttrEvent {
  final Paging? paging;
  final MstAttribute model;
  SearchMstAttr({this.paging, required this.model});
}

class ToMstAttrForm extends MstAttrEvent {
  // final String? attributeCd;
  final MstAttribute? model;
  ToMstAttrForm({
    this.model,
  });
}

class SubmitMstAttr extends MstAttrEvent {
  final String? formMode;
  final Paging? paging;
  final MstAttribute model;
  SubmitMstAttr(
    this.model,
    this.formMode,
    this.paging,
  );
}

class DeleteAttr extends MstAttrEvent {
  final String? attributeCd;
  DeleteAttr({
    required this.attributeCd,
  });
}
