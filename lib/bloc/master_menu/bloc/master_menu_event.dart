part of 'master_menu_bloc.dart';


abstract class MasterMenuEvent {}

class SearchMasterMenu extends MasterMenuEvent {
  final Paging? paging;
  final MenuModel model;
  final String? method, url;
  SearchMasterMenu({
    this.paging,
    required this.model,
    this.method,
    this.url,
  });
}

class ToMenuFeatDialog extends MasterMenuEvent {
  final MenuModel? menu;
  ToMenuFeatDialog({this.menu});
}

class UpdateMenuFeatForm extends MasterMenuEvent {
  final MenuModel menu;
  UpdateMenuFeatForm(this.menu);
}

class UpdateMenuFeat extends MasterMenuEvent {
  final MenuModel menu;
  UpdateMenuFeat(this.menu);
}

class ToMasterMenuForm extends MasterMenuEvent {
  final String? menuCd;
  final String method, url;
  ToMasterMenuForm({
    this.menuCd,
    required this.method,
    required this.url,
  });
}

class SubmitMasterMenu extends MasterMenuEvent {
  final String? formMode;
  final Paging? paging;
  final MenuModel model;
  final String createMethod,
      createUrl,
      updateMethod,
      updateUrl,
      searchMethod,
      searchUrl;
  SubmitMasterMenu(
    this.formMode,
    this.model,
    this.paging, {
    required this.createMethod,
    required this.createUrl,
    required this.updateMethod,
    required this.updateUrl,
    required this.searchMethod,
    required this.searchUrl,
  });
}

class DeleteMasterMenu extends MasterMenuEvent {
  final String? menuCd;
  final String method, url;
  DeleteMasterMenu({
    required this.menuCd,
    required this.method,
    required this.url,
  });
}
