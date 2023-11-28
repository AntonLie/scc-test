part of 'tracebility_bloc.dart';

@immutable
abstract class TracebilityState {}

class TracebilityInitial extends TracebilityState {}

class TracebilityLoading extends TracebilityState {}

class TracebilityTracing extends TracebilityState {
  final List<ListTraceability> listTrace;

  final Paging? paging;

  TracebilityTracing(this.listTrace, this.paging);
}

class ListKey extends TracebilityState {
  final List<KeyVal> listKey;
  final List<KeyVal> listProduct;
  final List<KeyVal> listUseCase;
  final List<KeyVal> listTouch;

  ListKey(this.listKey, this.listProduct, this.listUseCase, this.listTouch);
}

class TracebilityForm extends TracebilityState {
  final List<ListId> listItemId;
  final ListTraceability trace;
  TracebilityForm(this.listItemId, this.trace);
}

class TracebilityConsumeForm extends TracebilityState {
  final List<ListTraceability> listTrace;
  final Paging? paging;
  TracebilityConsumeForm(this.listTrace, this.paging);
}

class TracebilityFormItem extends TracebilityState {
  final DetailId idDetail;
  TracebilityFormItem(this.idDetail);
}

class DataTracebilityForm extends TracebilityState {
  final List<ListId> listItemId;
  final Paging? paging;
  DataTracebilityForm(this.listItemId, this.paging);
}

class OnLogoutTracebility extends TracebilityState {}

class TracebilityError extends TracebilityState {
  final String msg;
  TracebilityError(this.msg);
}

class TracebilityDetail extends TracebilityState {
  final DetailId idDetail;
  TracebilityDetail(this.idDetail);
}

class TracebilityDetailConsume extends TracebilityState {
  final DetailId idDetail;
  final ListTraceability trace;
  TracebilityDetailConsume(this.idDetail, this.trace);
}

class TraceDetailListTp extends TracebilityState {
  final List<TpAttribute> detail;
  TraceDetailListTp(this.detail);
}
