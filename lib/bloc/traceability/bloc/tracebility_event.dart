part of 'tracebility_bloc.dart';

@immutable
abstract class TracebilityEvent {}

class LoadTraceabilityTrace extends TracebilityEvent {
  final Paging? paging;
  final TraceSearch trace;

  LoadTraceabilityTrace(this.paging, this.trace);
}

class DropdownGetKey extends TracebilityEvent {
  final String? pointType;
  final String? pointProductCd;
  final bool? isConsume;

  DropdownGetKey(
    this.pointType,
    this.pointProductCd,
    this.isConsume,
  );
}

class LoadTraceabilityForm extends TracebilityEvent {
  final Paging? paging;
  final ListTraceability trace;
  final String? itemId;
  LoadTraceabilityForm(this.trace, this.paging, this.itemId);
}

class LoadTraceabilityConsumeForm extends TracebilityEvent {
  final Paging? paging;
  final ListTraceability trace;
  final String? pointCd;
  final String? itemName;

  LoadTraceabilityConsumeForm(
      this.trace, this.paging, this.pointCd, this.itemName);
}

class DataTraceabilityForm extends TracebilityEvent {
  final Paging? paging;
  final String? itemCd;
  final String supplierCd;
  final String? itemId;
  DataTraceabilityForm(this.paging, this.itemId, this.supplierCd, this.itemCd);
}

class LoadTraceabilityDetail extends TracebilityEvent {
  final String? itemId;
  final String? itemCd;
  LoadTraceabilityDetail(this.itemCd, this.itemId);
}

class LoadTraceabilityDetailConsume extends TracebilityEvent {
  final String? itemId;
  final String? itemCd;
  LoadTraceabilityDetailConsume(this.itemCd, this.itemId);
}

class TraceDetailList extends TracebilityEvent {
  final String? itemId;
  final String? itemCd;
  final String? pointCd;
  final String? childItem;
  final String? childItemCd;

  TraceDetailList(
      this.itemCd, this.itemId, this.pointCd, this.childItem, this.childItemCd);
}
