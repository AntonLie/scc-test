part of 'mon_log_bloc.dart';


abstract class MonLogEvent {}

class SearchLog extends MonLogEvent {
  final String? processId;
  final String? functionCd;
  final String? systemCd;
  final String? functionName;
  final String? moduleName;
  final String? createdBy;
  final String? statusCd;
  final String? startDtFrom;
  final String? startDtTo;
  final String? startDt;
  final String? endDt;
  final Paging? paging;
  SearchLog({
    this.paging,
    this.processId,
    this.functionName,
    this.moduleName,
    this.statusCd,
    this.createdBy,
    this.functionCd,
    this.systemCd,
    this.startDtFrom,
    this.startDtTo,
    this.startDt,
    this.endDt,
  });
}

class SearchFailLog extends MonLogEvent {
  final String? processId;
  final String? functionName;
  final String? moduleName;
  final String? createdBy;
  final String? startDt;
  final String? endDt;
  final Paging? paging;
  SearchFailLog({
    this.paging,
    this.processId,
    this.functionName,
    this.moduleName,
    this.createdBy,
    this.startDt,
    this.endDt,
  });
}

class SearchDtlLog extends MonLogEvent {
  final String? processId;
  final String? location;
  final String? messageId;
  final String? messageType;
  final String? messageDtl;
  final String? messageDt;
  final Paging? paging;
  SearchDtlLog({
    this.paging,
    this.processId,
    this.messageId,
    this.location,
    this.messageType,
    this.messageDtl,
    this.messageDt,
  });
}

class InitFilters extends MonLogEvent {}

class CheckLog extends MonLogEvent {
  final String processId;
  CheckLog(this.processId);
}

class SearchLogDetail extends MonLogEvent {
  final String? processId;
  final String? functionCd;
  final String? loc;
  final String? msgCd;
  final String? msgText;
  final Paging? paging;
  SearchLogDetail({
    this.processId,
    this.loc,
    this.functionCd,
    this.msgCd,
    this.msgText,
    this.paging,
  });
}
