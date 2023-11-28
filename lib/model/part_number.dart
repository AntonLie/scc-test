

import 'package:scc_web/model/system_master.dart';

class PartNumberList {
  int? pageNo;
  int? pageSize;
  int? totalDataInPage;
  int? totalData;
  int? totalPages;
  List<PartNumberListData>? listData;

  PartNumberList({this.pageNo, this.pageSize, this.totalDataInPage, this.totalData, this.totalPages, this.listData});

  PartNumberList.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalDataInPage = json['totalDataInPage'];
    totalData = json['totalData'];
    totalPages = json['totalPages'];
    if (json['listData'] != null) {
      listData = <PartNumberListData>[];
      json['listData'].forEach((v) {
        listData!.add(PartNumberListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNo'] = pageNo;
    data['pageSize'] = pageSize;
    data['totalDataInPage'] = totalDataInPage;
    data['totalData'] = totalData;
    data['totalPages'] = totalPages;
    if (listData != null) {
      data['listData'] = listData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UseCaseEdit {
  String? useCaseCd;
  String? useCaseName;
  String? partNo;
  String? workflowCd;

  Map<String, dynamic> toSubmit() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['useCaseCd'] = useCaseCd;
    data['wfCd'] = workflowCd;
    return data;
  }
}

class PartNumberListData {
  int? no;
  String? supplierName;
  String? partNo;
  String? partName;
  String? useCaseCd;
  String? useCaseName;
  SystemMaster? status;
  String? statusCd;
  String? latestUpdatedDt;
  String? statusVal;

  PartNumberListData({
    this.no,
    this.supplierName,
    this.partNo,
    this.partName,
    this.useCaseCd,
    this.useCaseName,
    this.statusCd,
    this.status,
    this.latestUpdatedDt,
    this.statusVal,
  });

  PartNumberListData.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    supplierName = json['supplierName'];
    partNo = json['partNo'];
    partName = json['partName'];
    useCaseCd = json['useCaseCd'];
    useCaseName = json['useCaseName'];
    status = (json['status'] is Map) ? SystemMaster.map(json['status']) : null;
    statusCd = (json['status'] is String) ? json['status'] : status?.systemCd;
    latestUpdatedDt = json['latestUpdatedDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['supplierName'] = supplierName;
    data['partNo'] = partNo;
    data['partName'] = partName;
    data['useCaseCd'] = useCaseCd;
    data['useCaseName'] = useCaseName;
    data['status'] = statusCd;
    data['latestUpdatedDt'] = latestUpdatedDt;
    return data;
  }
}

class ListTPData {
  String? useCaseCd;
  String? workflowName;
  String? workflowCd;
  List<DtlWfPoint>? dtlWfPoint;

  ListTPData({this.useCaseCd, this.workflowName, this.workflowCd, this.dtlWfPoint});

  ListTPData.fromJson(Map<String, dynamic> json) {
    useCaseCd = json['useCaseCd'];
    workflowName = json['workflowName'];
    workflowCd = json['workflowCd'];
    if (json['dtlWfPoint'] != null) {
      dtlWfPoint = <DtlWfPoint>[];
      json['dtlWfPoint'].forEach((v) {
        dtlWfPoint!.add(DtlWfPoint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['useCaseCd'] = useCaseCd;
    data['workflowName'] = workflowName;
    data['workflowCd'] = workflowCd;
    if (dtlWfPoint != null) {
      data['dtlWfPoint'] = dtlWfPoint!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DtlWfPoint {
  String? pointCd;
  String? pointName;

  DtlWfPoint({this.pointCd, this.pointName});

  DtlWfPoint.fromJson(Map<String, dynamic> json) {
    pointCd = json['pointCd'];
    pointName = json['pointName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pointCd'] = pointCd;
    data['pointName'] = pointName;
    return data;
  }
}
