class SubscribersTable {
  int? pageNo;
  int? pageSize;
  int? totalDataInPage;
  int? totalData;
  int? totalPages;
  List<ListSubsTable>? listData;

  SubscribersTable(
      {this.pageNo,
      this.pageSize,
      this.totalDataInPage,
      this.totalData,
      this.totalPages,
      this.listData});

  SubscribersTable.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalDataInPage = json['totalDataInPage'];
    totalData = json['totalData'];
    totalPages = json['totalPages'];
    if (json['listData'] != null) {
      listData = <ListSubsTable>[];
      json['listData'].forEach((v) {
        listData!.add(ListSubsTable.fromJson(v));
      });
    }
  }
}

class ListSubsTable {
  String? startDt;
  int? no;
  int? packageCd;
  int? newPackageCd;
  String? companyName;
  String? companyCd;
  String? packageName;
  String? packagePrice;
  String? gasFee;
  String? validPeriods;
  String? status;
  bool? actionEdit;
  bool? actionCreate;
  bool? notifButton;
  int? packagePeriod;
  String? industryType;
  String? email;
  int? countryId;
  String? phoneNumber;
  int? packageTime;
  String? msgText;
  bool? aggrement;
  bool? consent;
  String? brand;
  bool? buttonStatus;
  String? fullName;

  ListSubsTable({
    this.no,
    this.startDt,
    this.packageCd,
    this.companyName,
    this.companyCd,
    this.packageName,
    this.packagePrice,
    this.gasFee,
    this.validPeriods,
    this.status,
    this.actionEdit,
    this.actionCreate,
    this.notifButton,
    this.packagePeriod,
    this.industryType,
    this.fullName,
    this.email,
    this.countryId,
    this.phoneNumber,
    this.packageTime,
    this.msgText,
    this.aggrement,
    this.buttonStatus,
    this.consent,
    this.newPackageCd,
  });

  ListSubsTable.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    no = json['no'];
    packageCd = json['packageCd'];
    companyName = json['companyName'];
    companyCd = json['companyCd'];
    packageName = json['packageName'];
    packagePrice = json['packagePrice'];
    gasFee = json['gasFee'];
    validPeriods = json['validPeriods'];
    status = json['status'];
    actionEdit = json['actionEdit'];
    actionCreate = json['actionCreate'];
    notifButton = json['notifButton'];
    packagePeriod = json['packagePeriod'];
  }
  ListSubsTable.view(Map<String, dynamic> json) {
    fullName = json['fullName'] ?? "";
    startDt = json['startDt'];
    packageName = json['packageName'];
    packageCd = json['packageCd'];
    companyCd = json['companyCd'];
    companyName = json['companyName'];
    industryType = json['industryType'];
    email = json['email'] ?? "";
    countryId = json['countryId'];
    phoneNumber = json['phoneNumber'];
    packageTime = json['packageTime'];
    msgText = json['msgText'];
    aggrement = json['aggrement'];
    consent = json['consent'];
  }
  ListSubsTable.getCreate(Map<String, dynamic> json) {
    companyName = json['companyName'];
    companyCd = json['companyCd'];
    brand = json['brand'] ?? "";
    packageCd = json['packageCd'];
    packageName = json['packageName'];
    packageTime = json['packageTime'];
    startDt = json['startDate'];
  }
  Map<String, dynamic> toCreate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand'] = brand;
    data['packageCd'] = packageCd;
    data['newPackageCd'] = newPackageCd;
    data['period'] = packageTime;
    data['startDt'] = startDt;
    data['companyCd'] = companyCd;
    data['companyName'] = companyName;
    return data;
  }

  Map<String, dynamic> toEdit() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyCd'] = companyCd;
    data['packageCd'] = newPackageCd;
    data['numberPeriod'] = packageTime;
    data['startDate'] = startDt;
    data['buttonStatus'] = buttonStatus;
    // data['newPackageCd'] = newPackageCd;

    return data;
  }
}

class TotalSubs {
  int? totalSubs;
  String? totalRev;
  String? totalGasFee;

  TotalSubs({this.totalSubs, this.totalRev, this.totalGasFee});

  TotalSubs.fromJson(Map<String, dynamic> json) {
    totalSubs = json['totalSubs'];
    totalRev = json['totalRev'];
    totalGasFee = json['totalGasFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalSubs'] = totalSubs;
    data['totalRev'] = totalRev;
    data['totalGasFee'] = totalGasFee;
    return data;
  }
}
