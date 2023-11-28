part of 'mon_agent_bloc.dart';


abstract class MonAgentState {}

class MonAgentInitial extends MonAgentState {}

class AgentsLoading extends MonAgentState {}

class MenuAgentsLoaded extends MonAgentState {
  final List<Company> listCompany;
  final List<Agent>? listAgent;
  final Paging? paging;
  // final List<SystemMaster> listDuration;
  final List<SystemMaster> listStatus;
  MenuAgentsLoaded(
      this.listCompany, this.listStatus, this.listAgent, this.paging); //, this.listAgent, this.paging, this.listDuration, this.listStatus);
}

class AgentsLoaded extends MonAgentState {
  final List<Agent> listAgent;
  final Paging? paging;
  AgentsLoaded(this.listAgent, this.paging);
}

class AgentTpLoaded extends MonAgentState {
  final List<AgentTp> listAgent;
  final String? clientId;
  final String? pointCd;
  final String? pointName;
  final Paging? paging;
  AgentTpLoaded(
      this.clientId, this.pointCd, this.pointName, this.listAgent, this.paging);
}

class OnLogoutAgents extends MonAgentState {}

class AgentsError extends MonAgentState {
  final String error;
  AgentsError(this.error);
}
