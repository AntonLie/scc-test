part of 'point_bloc.dart';

@immutable
abstract class PointEvent {}

class GetPointData extends PointEvent {
  final Paging? paging;
  // final String? companyCd;
  final String? pointCd;
  final String? pointName;
  final String? type;
  GetPointData({
    this.paging,
    this.pointCd,
    this.pointName,
    // this.companyCd,
    this.type,
  });
}

class GetViewData extends PointEvent {
  final String? pointCd;
  final String? formMode;
  GetViewData({this.pointCd, this.formMode});
}

class LoadFormPoint extends PointEvent {
  final String? pointCd;
  final String? formMode;
  LoadFormPoint({this.pointCd, this.formMode});
}

class SubmitedPoint extends PointEvent {
  final String? pointCd;
  final ViewPointModel? model;
  final String? formMode;
  SubmitedPoint({this.model, this.pointCd, this.formMode});
}

class DeletePoint extends PointEvent {
  final String? pointCd;
  DeletePoint({
    required this.pointCd,
  });
}
