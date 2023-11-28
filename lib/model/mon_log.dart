class LogModel {
  int? no;
  String? processId;
  String? moduleName;
  String? functionName;
  String? status;
  String? createdBy;
  String? startDt;
  String? endDt;
  String? messageId;
  String? messageType;
  String? systemValue;
  int? systemSeq;
  String? systemDesc;
  String? location;
  String? messageDetail;
  String? messageDateTime;

  LogModel(
      {this.no,
      this.processId,
      this.moduleName,
      this.functionName,
      this.status,
      this.createdBy,
      this.startDt,
      this.endDt,
      this.messageId,
      this.messageType,
      this.systemValue,
      this.systemSeq,
      this.systemDesc,
      this.location,
      this.messageDetail,
      this.messageDateTime});

  LogModel.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    processId = json['processId'];
    moduleName = json['moduleName'];
    functionName = json['functionName'];
    status = json['status'];
    createdBy = json['createdBy'];
    startDt = json['startDt'];
    endDt = json['endDt'];
    messageId = json['messageId'];
    messageType = json['messageType'];
    systemValue = json['systemValue'];
    systemSeq = json['systemSeq'];
    systemDesc = json['systemDesc'];
    location = json['location'];
    messageDetail = json['messageDetail'];
    messageDateTime = json['messageDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['processId'] = processId;
    data['moduleName'] = moduleName;
    data['functionName'] = functionName;
    data['status'] = status;
    data['createdBy'] = createdBy;
    data['startDt'] = startDt;
    data['endDt'] = endDt;
    data['messageId'] = messageId;
    data['messageType'] = messageType;
    data['systemValue'] = systemValue;
    data['systemSeq'] = systemSeq;
    data['systemDesc'] = systemDesc;
    data['location'] = location;
    data['messageDetail'] = messageDetail;
    data['messageDateTime'] = messageDateTime;
    return data;
  }
}

class LogDetail {
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  bool? deletedFlag;
  int? seqNo;
  String? errDt;
  String? loc;
  String? processBy;
  String? msgText;
  String? createdClientId;
  String? updatedClientId;
  int? processId;
  String? messageCd;
  LogModel? process;
  // LogMessage? message;

  LogDetail(
      {this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.deletedFlag,
      this.seqNo,
      this.errDt,
      this.loc,
      this.processBy,
      this.process,
      // this.message,
      this.processId,
      this.messageCd,
      this.msgText,
      this.createdClientId,
      this.updatedClientId});

  LogDetail.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];
    seqNo = obj['seqNo'];
    errDt = obj['errDt'];
    loc = obj['loc'];
    processBy = obj['processBy'];
    // msgText = obj['msgText'];
    createdClientId = obj['createdClientId'];
    updatedClientId = obj['updatedClientId'];
    // if (obj['processId'] != null) {
    //   process = LogModel.map(obj['processId']);
    //   processId = process!.processId != null ? int.parse(process!.processId.number) : null;
    // }
    // if (obj['messageCd'] != null) {
    //   message = LogMessage.map(obj['messageCd']);
    //   messageCd = message!.msgCd;
    //   msgText = message!.msgText;
    // }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['deletedFlag'] = deletedFlag;
    data['seqNo'] = seqNo;
    data['errDt'] = errDt;
    data['loc'] = loc;
    data['processBy'] = processBy;
    data['msgText'] = msgText;
    data['createdClientId'] = createdClientId;
    data['updatedClientId'] = updatedClientId;
    return data;
  }
}
