part of 'point_bloc.dart';

@immutable
abstract class PointState {}

class PointInitial extends PointState {}

class PointLoading extends PointState {}

class OnLogoutPoint extends PointState {}

class DataPoint extends PointState {
  final List<ListDataNewPoint>? model;
  final Paging? paging;

  DataPoint(
    this.model,
    this.paging,
  );
}

class PointError extends PointState {
  final String msg;
  PointError(this.msg);
}

class PointView extends PointState {
  final dynamic model;
  PointView(this.model);
}

class PointFormState extends PointState {
  final List<KeyVal> listPointTyp;
  final List<KeyVal> listTyp;
  final List<KeyVal> listProType;
  final List<KeyVal> listNodeBlock;
  final List<KeyVal> listTempAttr;
  final List<KeyVal> listAttr;
  final ViewPointModel? model;
  PointFormState(this.listPointTyp, this.listProType, this.listTyp,
      this.listNodeBlock, this.listTempAttr, this.listAttr, this.model);
}

class PointSubmited extends PointState {
  final String? msg;
  PointSubmited(
    this.msg,
  );
}
class PointDeleted extends PointState {}