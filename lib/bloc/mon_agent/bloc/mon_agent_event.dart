part of 'mon_agent_bloc.dart';


abstract class MonAgentEvent {}

class LoadMenuAgents extends MonAgentEvent {
  final Paging? paging;
  final Agent model;
  LoadMenuAgents({this.paging, required this.model});
}

class GetAgentsLists extends MonAgentEvent {
  final String? companyCd;
  final String? clientId;
  final String? status;
  final Paging? paging;
  GetAgentsLists(
    this.paging,
    this.companyCd,
    this.clientId,
    this.status,
  );
}

class SearchAgentTp extends MonAgentEvent {
  final String? clientId;
  final String? pointCd;
  final String? pointName;
  final String? status;
  final Paging? paging;
  SearchAgentTp({
    this.clientId,
    this.pointCd,
    this.pointName,
    this.paging,
    this.status,
  });
}
