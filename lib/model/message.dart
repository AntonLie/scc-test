import 'package:scc_web/model/company.dart';
import 'package:scc_web/model/system_master.dart';

class LogMessage {
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  bool? deletedFlag;
  String? msgCd;
  Company? company;
  SystemMaster? msgType;
  String? msgText;
  String? msgDesc;
  dynamic msgIcon;

  LogMessage(
      {this.createdBy,
      this.createdDt,
      this.changedBy,
      this.changedDt,
      this.deletedFlag,
      this.msgCd,
      this.company,
      this.msgType,
      this.msgText,
      this.msgIcon,
      this.msgDesc});

  LogMessage.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];
    msgCd = obj['msgCd'];
    msgText = obj['msgText'];
    msgIcon = obj['msgIcon'];
    msgDesc = obj['msgDesc'];
    if (obj['company'] != null) {
      company = Company.map(obj['company']);
    }
    if (obj['msgType'] != null) {
      msgType = SystemMaster.map(obj['msgType']);
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['deletedFlag'] = deletedFlag;
    data['msgCd'] = msgCd;
    data['company'] = company;
    data['msgText'] = msgText;
    data['msgIcon'] = msgIcon;
    data['msgDesc'] = msgDesc;
    if (company != null) data['company'] = company!.toMap();
    if (msgType != null) data['msgType'] = msgType!.toMap();
    return data;
  }
}
