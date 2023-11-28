part of 'template_attribute_bloc.dart';

@immutable
abstract class TemplateAttributeState {}

class TemplateAttributeInitial extends TemplateAttributeState {}

class TemplateAttributeLoading extends TemplateAttributeState {}

class TemplateAttributeError extends TemplateAttributeState {
  final String msg;
  TemplateAttributeError(this.msg);
}

class OnLogoutTemplateAttribute extends TemplateAttributeState {}

class SearchTempAttr extends TemplateAttributeState {
  final List<TempAttr> listTempAttr;
  final Paging? paging;
  SearchTempAttr(this.listTempAttr, this.paging);
}

class ViewTmplAttrLoaded extends TemplateAttributeState {
  final TempAttr? model;
  final String? errMsg;
  ViewTmplAttrLoaded(this.model, {this.errMsg});
}

class AddTmplAttrSubmit extends TemplateAttributeState {
  final String? msg;
  AddTmplAttrSubmit(this.msg);
}


class ViewTemplateAttrLoadedAll extends TemplateAttributeState {
  final List<TempAttr>? model;
  final Paging? paging;
  ViewTemplateAttrLoadedAll(this.model, this.paging);
}

//di cari nanti
class LoadAttribute extends TemplateAttributeState {
  final List<AttrCodeClass> listAttr;
  final Paging? paging;
  LoadAttribute(this.listAttr, this.paging);
}

class DeleteTmplAttrSubmit extends TemplateAttributeState {
  final String? msg;
  DeleteTmplAttrSubmit(this.msg);
}

class EditTmplAttrSubmit extends TemplateAttributeState {
  final String? msg;
  EditTmplAttrSubmit(this.msg);
}
