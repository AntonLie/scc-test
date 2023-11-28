part of 'template_attribute_bloc.dart';

@immutable
abstract class TemplateAttributeEvent {}

class SetInitial extends TemplateAttributeEvent {}

class SearchTemplateAttr extends TemplateAttributeEvent {
  final TempAttr model;
  final Paging? paging;
  // final String method, url;
  SearchTemplateAttr(
    this.model, {
    this.paging,
    // required this.method, required this.url
  });
}

class ViewTemplateAttr extends TemplateAttributeEvent {
  // final String? tmplAttrCd;
  final TempAttr? model;

  ViewTemplateAttr({
    this.model,
    // required this.method, required this.url
  });
}

class ViewAllTemplateAttr extends TemplateAttributeEvent {
  final TempAttr? model;
  final Paging? paging;
  ViewAllTemplateAttr({this.model, this.paging
      // required this.method, required this.url
      });
}

class AddTemplateAttribute extends TemplateAttributeEvent {
  final TempAttr model;
  // final String method, url;
  AddTemplateAttribute(
    this.model,
    //  this.method, this.url
  );
}

class SearchAttributeCd extends TemplateAttributeEvent {
  final String? attrCd;
  final String? attrName;
  final Paging? paging;
  SearchAttributeCd({this.attrCd, this.attrName, this.paging});
}

class DeleteTemplateAttribute extends TemplateAttributeEvent {
  final String? attrCd;
  // final String method, url;
  DeleteTemplateAttribute({
    required this.attrCd,
    //  required this.method, required this.url
  });
}

class EditTemplateAttribute extends TemplateAttributeEvent {
  final TempAttr model;
  // final String method, url;
  EditTemplateAttribute(
    this.model,
    //  this.method, this.url
  );
}
