part of 'mon_log_bloc.dart';


abstract class MonLogState {}

class MonLogInitial extends MonLogState {}

class LogInitial extends MonLogState {}

class LogLoading extends MonLogState {}

class LogChecking extends MonLogState {}

class LogChecked extends MonLogState {}

class LogLoaded extends MonLogState {
  final List<LogModel> listModel;
  final Paging? paging;
  LogLoaded(this.listModel, this.paging);
}

class LogFailLoaded extends MonLogState {
  final List<LogModel> listModel;
  final Paging? paging;
  LogFailLoaded(this.listModel, this.paging);
}

class LoadFilters extends MonLogState {
  final List<SystemMaster> listStatus;
  final List<SystemMaster> listMessageType;
  LoadFilters(this.listStatus, this.listMessageType);
}

class LogDtlLoad extends MonLogState {
  final List<LogModel> listModel;
  final Paging? paging;
  LogDtlLoad(this.listModel, this.paging);
}

class LogDetailLoaded extends MonLogState {
  final List<LogDetail> listModel;
  final Paging? paging;
  final String? functionCd;
  LogDetailLoaded(this.listModel, this.functionCd, this.paging);
}

class OnLogoutLog extends MonLogState {}

class LogError extends MonLogState {
  final String error;
  LogError(this.error);
}
