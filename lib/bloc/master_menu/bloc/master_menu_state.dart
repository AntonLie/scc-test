part of 'master_menu_bloc.dart';


abstract class MasterMenuState {}

class MasterMenuInitial extends MasterMenuState {}

class MasterMenuLoading extends MasterMenuState {}

class MenuFeatLoaded extends MasterMenuState {
  final MenuModel model;
  final String? error;
  final bool? success;
  MenuFeatLoaded(this.model, {this.error, this.success});
}

class UpdateMenuFeatLoading extends MasterMenuState {}

class MenuFeatUpdated extends MasterMenuState {}

class LoadTable extends MasterMenuState {
  final Paging? paging;
  final List<MenuModel> listModel;
  final List<ParentMenu> listParents;
  final String? msg;
  LoadTable(this.paging, this.listModel, this.listParents, {this.msg});
}

class MasterMenuDeleted extends MasterMenuState {}

class LoadForm extends MasterMenuState {
  final MenuModel? submitModel;
  final List<SystemMaster> listMenuType;
  final List<ParentMenu> listParentMenu;

  LoadForm(
    this.submitModel,
    this.listMenuType,
    this.listParentMenu,
  );
}

class MasterMenuSubmitted extends MasterMenuState {
  final Paging? paging;
  final String msg;
  final List<MenuModel> listModel;
  MasterMenuSubmitted(this.msg, this.listModel, this.paging);
}

class MasterMenuError extends MasterMenuState {
  final String error;
  MasterMenuError(this.error);
}

class OnLogoutMasterMenu extends MasterMenuState {}
