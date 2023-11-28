class MasterProductModel {
  int? no;
  String? productName;
  String? productCd;
  String? description;
  String? touchPoint;
  String? companyCd;
  String? productDesc;

  String? productType;
  List<ProductDetail>? detailOnTraceabilityTop;
  List<ProductDetail>? detailOnTraceabilityButtom;
  List<ProductDetail>? detailOnTraceTop;
  List<ProductDetail>? detailOnTraceButtom;
  List<ProductDetail>? detailOnChildTop;
  List<ProductDetail>? detailOnChildButtom;

  MasterProductModel({
    this.no,
    this.productName,
    this.productCd,
    this.description,
    this.touchPoint,
    this.productDesc,
    this.detailOnTraceabilityTop,
    this.detailOnTraceabilityButtom,
    this.detailOnTraceTop,
    this.detailOnTraceButtom,
    this.detailOnChildTop,
    this.detailOnChildButtom,
  });

  MasterProductModel.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    productName = json['productName'];
    productCd = json['productCd'];
    description = json['description'];
    touchPoint = json['touchPoint'];
    companyCd = json['companyCd'];
    productDesc = json['productDesc'];
    productType = json['productType'];

    if (json['detailOnTraceabilityTop'] != null &&
        json['detailOnTraceabilityTop'] is List) {
      detailOnTraceabilityTop = [];
      for (var v in (json['detailOnTraceabilityTop'] as List)) {
        detailOnTraceabilityTop!.add(ProductDetail.fromJson(v));
      }
    }
    if (json['detailOnTraceabilityButtom'] != null &&
        json['detailOnTraceabilityButtom'] is List) {
      detailOnTraceabilityButtom = [];
      for (var v in (json['detailOnTraceabilityButtom'] as List)) {
        detailOnTraceabilityButtom!.add(ProductDetail.fromJson(v));
      }
    }
    if (json['detailOnTraceTop'] != null && json['detailOnTraceTop'] is List) {
      detailOnTraceTop = [];
      for (var v in (json['detailOnTraceTop'] as List)) {
        detailOnTraceTop!.add(ProductDetail.fromJson(v));
      }
    }
    if (json['detailOnTraceButtom'] != null &&
        json['detailOnTraceButtom'] is List) {
      detailOnTraceButtom = [];
      for (var v in (json['detailOnTraceButtom'] as List)) {
        detailOnTraceButtom!.add(ProductDetail.fromJson(v));
      }
    }
    if (json['detailOnChildTop'] != null && json['detailOnChildTop'] is List) {
      detailOnChildTop = [];
      for (var v in (json['detailOnChildTop'] as List)) {
        detailOnChildTop!.add(ProductDetail.fromJson(v));
      }
    }

    if (json['detailOnChildButtom'] != null &&
        json['detailOnChildButtom'] is List) {
      detailOnChildButtom = [];
      for (var v in (json['detailOnChildButtom'] as List)) {
        detailOnChildButtom!.add(ProductDetail.fromJson(v));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['productName'] = productName;
    data['productCd'] = productCd;
    data['description'] = description;
    data['touchPoint'] = touchPoint;
    return data;
  }

  Map<String, dynamic> toAdd() {
    Map<String, dynamic> data = {};
    data['productName'] = productName;
    data['productDesc'] = productDesc;
    data['productType'] = productType;

    if (detailOnTraceabilityTop != null) {
      data['detailOnTraceabilityTop'] =
          detailOnTraceabilityTop!.map((v) => v.toAdd()).toList();
    }
    if (detailOnTraceabilityButtom != null) {
      data['detailOnTraceabilityButtom'] =
          detailOnTraceabilityButtom!.map((v) => v.toAdd()).toList();
    }
    if (detailOnTraceTop != null) {
      data['detailOnTraceTop'] =
          detailOnTraceTop!.map((v) => v.toAdd()).toList();
    }
    if (detailOnTraceButtom != null) {
      data['detailOnTraceButtom'] =
          detailOnTraceButtom!.map((v) => v.toAdd()).toList();
    }
    if (detailOnChildTop != null) {
      data['detailOnChildTop'] =
          detailOnChildTop!.map((v) => v.toAdd()).toList();
    }
    if (detailOnChildButtom != null) {
      data['detailOnChildButtom'] =
          detailOnChildButtom!.map((v) => v.toAdd()).toList();
    }

    return data;
  }
}

class ProductDetail {
  String? labelName;
  String? attrCd;

  ProductDetail({this.labelName, this.attrCd});

  Map<String, dynamic> toAdd() {
    Map<String, dynamic> data = {};
    data['labelName'] = labelName;
    data['attrCd'] = attrCd;
    return data;
  }

  ProductDetail.fromJson(Map<String, dynamic> json) {
    labelName = json['labelName'];
    attrCd = json['attrCd'];
  }

  void clear() {}
}
