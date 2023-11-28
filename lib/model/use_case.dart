class ListUseCaseData {
  int? no;
  String? companyCd;
  String? useCaseCd;
  String? useCaseName;
  String? useCaseDesc;
  List<String>? attrSerialNumber;
  bool? checkParent;
  String? endDt;
  String? startDt;
  String? statusCd;
  String? lastUpdateDt;
  String? lastUpdateBy;
  List<ListTouchPoint>? listTouchPoint;

  ListUseCaseData(
      {this.no,
      this.companyCd,
      this.useCaseCd,
      this.useCaseName,
      this.useCaseDesc,
      this.attrSerialNumber,
      this.checkParent,
      this.endDt,
      this.startDt,
      this.statusCd,
      this.lastUpdateDt,
      this.lastUpdateBy,
      this.listTouchPoint});

  ListUseCaseData.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    companyCd = json['companyCd'];
    useCaseCd = json['useCaseCd'];
    useCaseName = json['useCaseName'];
    useCaseDesc = json['useCaseDesc'];
    attrSerialNumber = json['attrSerialNumber'].cast<String>();
    checkParent = json['checkParent'];
    endDt = json['endDt'];
    startDt = json['startDt'];
    statusCd = json['statusCd'];
    lastUpdateDt = json['lastUpdateDt'];
    lastUpdateBy = json['lastUpdateBy'];
    if (json['listTouchPoint'] != null) {
      listTouchPoint = <ListTouchPoint>[];
      json['listTouchPoint'].forEach((v) {
        listTouchPoint!.add(ListTouchPoint.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toSubmit() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['useCaseName'] = useCaseName;
    data['useCaseDesc'] = useCaseDesc;
    data['startDt'] = startDt;
    data['endDt'] = endDt;
    data['attrSerialNumber'] = attrSerialNumber;
    if (listTouchPoint != null) {
      data['listTouchPoint'] = listTouchPoint!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListTouchPoint {
  String? pointCd;
  int? seq;
  String? pointType;

  bool? checkParent;
  bool? pointreceiveFlag;
  bool? blockchainFlag;
  bool? pointSupplierFlag;
  String? pointName;

  ListTouchPoint(
      {this.pointCd,
      this.seq,
      this.pointType,
      this.checkParent,
      this.pointreceiveFlag,
      this.blockchainFlag,
      this.pointSupplierFlag,
      this.pointName});

  ListTouchPoint.fromJson(Map<String, dynamic> json) {
    pointCd = json['pointCd'];
    seq = json['seq'];
    checkParent = json['checkParent'];
    pointreceiveFlag = json['pointreceiveFlag'];
    pointType = json['typePoint'];
    blockchainFlag = json['blockchainFlag'];
    pointSupplierFlag = json['pointSupplierFlag'];
    pointName = json['pointName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pointCd'] = pointCd;
    data['seq'] = seq;
    data['checkParent'] = checkParent ?? false;
    data['pointreceiveFlag'] = pointreceiveFlag ?? false;
    data['blockchainFlag'] = blockchainFlag ?? false;
    data['pointSupplierFlag'] = pointSupplierFlag ?? false;
    data['pointSupplierFlag'] = pointSupplierFlag ?? false;
    return data;
  }
}
