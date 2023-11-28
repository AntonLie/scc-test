class AssignMstItem {
  int? no;
  String? itemCd;
  String? itemName;
  String? itemDesc;
  String? useCaseCd;
  String? useCaseName;
  String? statusCd;
  String? lastUpdated;
  String? searchBy;
  String? searchValue;
  String? companyCd;
  String? supplierCd;
  String? supplierName;
  String? uom;
  String? uomType;
  String? useCaseDesc;
  String? attributeSerialNumber;
  String? lastUpdateBy;
  String? startDt;
  String? endDt;
  String? lastUpdatedDate;
  String? fileBase64;
  String? fileName;
  String? pointCd;
  String? productName;
  String? file;
  List<ReviewHistory>? reviewHistory;

  // String? statusCd;

  AssignMstItem(
      {this.no,
      this.itemCd,
      this.itemName,
      this.itemDesc,
      this.useCaseCd,
      this.useCaseName,
      this.statusCd,
      this.lastUpdated,
      this.searchBy,
      this.searchValue,
      this.companyCd,
      this.supplierCd,
      this.supplierName,
      this.uom,
      this.uomType,
      this.useCaseDesc,
      this.attributeSerialNumber,
      this.lastUpdateBy,
      this.startDt,
      this.endDt,
      this.lastUpdatedDate,
      this.reviewHistory,
      this.fileName,
      this.fileBase64,
      this.pointCd,
      this.productName,
      this.file});

  AssignMstItem.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    itemCd = json['itemCd'];
    itemName = json['itemName'];
    itemDesc = json['itemDesc'];
    useCaseCd = json['useCaseCd'];
    useCaseName = json['useCaseName'];
    statusCd = json['statusCd'];
    lastUpdated = json['lastUpdated'];
    companyCd = json['companyCd'];
    supplierCd = json['supplierCd'];
    supplierName = json['supplierName'];
    uom = json['uom'];
    uomType = json['uomType'];
    useCaseCd = json['useCaseCd'];
    useCaseName = json['useCaseName'];
    useCaseDesc = json['useCaseDesc'];
    attributeSerialNumber = json['attributeSerialNumber'];
    statusCd = json['statusCd'];
    lastUpdateBy = json['lastUpdateBy'];
    startDt = json['startDt'];
    endDt = json['endDt'];
    lastUpdatedDate = json['lastUpdatedDate'];
    if (json['reviewHistory'] != null) {
      reviewHistory = <ReviewHistory>[];
      json['reviewHistory'].forEach((v) {
        reviewHistory!.add(ReviewHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['itemCd'] = itemCd;
    data['itemName'] = itemName;
    data['itemDesc'] = itemDesc;
    data['useCaseCd'] = useCaseCd;
    data['useCaseName'] = useCaseName;
    data['statusCd'] = statusCd;
    data['lastUpdated'] = lastUpdated;
    data['searchBy'] = searchBy;
    data['searchValue'] = searchValue;
    data['supplierCd'] = supplierCd;
    data['fileBase64'] = fileBase64;
    data['pointCd'] = pointCd;
    data['productName'] = productName;
    if (reviewHistory != null) {
      data['reviewHistory'] = reviewHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toAdd() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemCd'] = itemCd;
    data['useCaseCd'] = useCaseCd;
    data['supplierCd'] = supplierCd;
    data['fileBase64'] = fileBase64;
    data['fileName'] = fileName;
    data['pointCd'] = pointCd;
    data['productName'] = productName;
    data['file'] = file;
    return data;
  }
}

class ReviewHistory {
  String? status;
  String? dateTime;
  String? reviewer;
  String? reason;

  ReviewHistory({this.status, this.dateTime, this.reviewer, this.reason});

  ReviewHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    dateTime = json['dateTime'];
    reviewer = json['reviewer'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['dateTime'] = dateTime;
    data['reviewer'] = reviewer;
    data['reason'] = reason;
    return data;
  }
}

class MessageUpload {
  String? status;
  String? msg;
  int? totalDataSucces;
  int? totalDataFailed;

  MessageUpload(
      {this.status, this.totalDataSucces, this.totalDataFailed, this.msg});

  MessageUpload.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    totalDataSucces = json['totalDataSucces'];
    totalDataFailed = json['totalDataFailed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['status'] = status;
    data['msg'] = msg;
    data['totalDataSucces'] = totalDataSucces;
    data['totalDataFailed'] = totalDataFailed;
    return data;
  }
}

class TouchPointUpload {
  String? pointCd;
  String? pointName;

  TouchPointUpload({this.pointCd, this.pointName});

  TouchPointUpload.fromJson(Map<String, dynamic> json) {
    pointCd = json['pointCd'];
    pointName = json['pointName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pointCd'] = pointCd;
    data['pointName'] = pointName;
    return data;
  }
}

class ListUseCase {
  String? useCaseCd;
  String? useCaseName;
  ListUseCase({this.useCaseCd});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['useCaseCd'] = useCaseCd;
    return data;
  }
}
