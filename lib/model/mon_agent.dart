class SortedAgent {
  String? companyCd;
  String? companyName;
  List<Agent>? listAgents;
  SortedAgent({this.companyCd, this.companyName, this.listAgents});
}

class Agent {
  String? companyCd;
  String? companyName;
  String? clientId;
  String? status;
  String? lastConnectDt;
  String? getCurrentDt;
  int? seqNumber;

  Agent(
      {this.companyCd,
      this.companyName,
      this.clientId,
      this.status,
      this.lastConnectDt,
      this.getCurrentDt,
      this.seqNumber});

  Agent.map(Map<String, dynamic> obj) {
    seqNumber = obj['seqNumber'];
    companyCd = obj['companyCd'];
    companyName = obj['companyName'];
    clientId = obj['clientId'];
    status = obj['status'];
    lastConnectDt = obj['lastConnectDt'];
    getCurrentDt = obj['getCurrentDt'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['seqNumber'] = seqNumber;
    data['companyCd'] = companyCd;
    data['companyName'] = companyName;
    data['clientId'] = clientId;
    data['status'] = status;
    data['lastConnectDt'] = lastConnectDt;
    data['getCurrentDt'] = getCurrentDt;
    return data;
  }
}

class AgentTp {
  String? pointCd;
  String? pointName;
  String? clientId;
  int? maxLiveness;
  int? seqNumber;
  String? lastSubmitDate;
  String? status;

  AgentTp(
      {this.pointCd,
      this.seqNumber,
      this.pointName,
      this.clientId,
      this.maxLiveness,
      this.lastSubmitDate,
      this.status});

  AgentTp.map(Map<String, dynamic> json) {
    seqNumber = json['seqNumber'];
    pointCd = json['pointCd'];
    pointName = json['pointName'];
    clientId = json['clientId'];
    maxLiveness = json['maxLiveness'];
    lastSubmitDate = json['lastSubmitDate'];
    status = json['status'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['seqNumber'] = seqNumber;
    data['pointCd'] = pointCd;
    data['pointName'] = pointName;
    data['clientId'] = clientId;
    data['maxLiveness'] = maxLiveness;
    data['lastSubmitDate'] = lastSubmitDate;
    data['status'] = status;
    return data;
  }
}
