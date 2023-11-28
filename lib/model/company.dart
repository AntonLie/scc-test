class Company {
  String? createdBy;
  String? createdDt;
  dynamic changedBy;
  dynamic changedDt;
  bool? deletedFlag;

  String? companyCd;
  String? companyName;
  String? companyAddr;
  String? companyContactNo;
  double? mainLongi;
  double? mainLati;
  String? schemaName;
  String? companyDesc;
  String? supplierAbbreviation;

  Company({
    this.createdBy,
    this.createdDt,
    this.changedBy,
    this.changedDt,
    this.deletedFlag,
    this.companyCd,
    this.companyName,
    this.companyAddr,
    this.companyContactNo,
    this.mainLongi,
    this.mainLati,
    this.schemaName,
    this.companyDesc,
    this.supplierAbbreviation,
  });

  Company.map(Map<String, dynamic> obj) {
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    deletedFlag = obj['deletedFlag'];

    companyCd = obj['companyCd'];
    companyName = obj['companyName'];
    companyAddr = obj['companyAddr'];
    companyContactNo = obj['companyContactNo'];
    mainLongi = obj['mainLongi'];
    mainLati = obj['mainLati'];
    schemaName = obj['schemaName'];
    companyDesc = obj['companyDesc'];
    supplierAbbreviation = obj['supplierAbbreviation'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['deletedFlag'] = deletedFlag;

    data['companyCd'] = companyCd;
    data['companyName'] = companyName;
    data['companyAddr'] = companyAddr;
    data['companyContactNo'] = companyContactNo;
    data['mainLongi'] = mainLongi;
    data['mainLati'] = mainLati;
    data['schemaName'] = schemaName;
    data['companyDesc'] = companyDesc;
    return data;
  }

  Map<String, dynamic> editCompany() {
    Map<String, dynamic> data = {};

    data['companyCd'] = companyCd ?? "";
    data['companyName'] = companyName ?? "";
    data['companyAddr'] = companyAddr ?? "";
    data['companyContactNo'] = companyContactNo ?? "";
    data['mainLongi'] = mainLongi ?? "";
    data['mainLati'] = mainLati ?? "";
    data['companyDesc'] = companyDesc ?? "";

    return data;
  }
}
