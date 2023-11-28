class Pricing {
  int? packageCd;
  String? packageName;
  String? packageDesc;
  double? priceMonthly;
  double? priceYearly;
  bool? isCurrentPlant;
  String? packageColor;
  List<String>? packageFeatures;

  Pricing(
      {this.packageName,
      this.priceMonthly,
      this.packageDesc,
      this.priceYearly,
      this.isCurrentPlant,
      this.packageFeatures});

  Pricing.map(Map obj) {
    packageName = obj['packageName'];
    packageCd = obj['packageCd'];
    packageDesc = obj['packageDesc'];
    priceMonthly = obj['priceMonthly'];
    priceYearly = obj['priceYearly'];
    isCurrentPlant = obj['isCurrentPlant'];
    packageColor = obj['packageColor'];
    var pFlist = obj['packageFeatures'];
    if (pFlist is List) {
      packageFeatures = [];
      for (var element in pFlist) {
        if (element is String) {
          packageFeatures!.add(element);
        }
      }
    }
  }
}

class SystemSubmit {
  int? pageNo;
  int? pageSize;
  String? systemCd;
  String? systemTypeCd;
  String? systemValue;
  String? company;
  String? traceType;

  SystemSubmit(
      {this.pageNo,
      this.pageSize,
      this.systemCd,
      this.systemTypeCd,
      this.systemValue,
      this.company,
      this.traceType});

  Map<String, dynamic> toSystem() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNo'] = pageNo;
    data['pageSize'] = pageSize;
    data['systemCd'] = systemCd;
    data['systemTypeCd'] = systemTypeCd;
    data['systemValue'] = systemValue;
    data['company'] = company;
    data['traceType'] = traceType;
    return data;
  }
}
