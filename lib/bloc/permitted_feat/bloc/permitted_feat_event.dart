part of 'permitted_feat_bloc.dart';

abstract class PermittedFeatEvent {}

class GetPermitted extends PermittedFeatEvent {
  String menuCd;
  GetPermitted(this.menuCd);
}
