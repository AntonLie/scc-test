class Supplier {
  int? no;
  String? createdBy;
  String? createdDt;
  String? changedBy;
  String? changedDt;
  String? countryCity;
  int? totalAccount;
  String? supplierName;
  String? supplierCd;
  String? supplierTypeCd;
  String? contactNumber;
  String? supplierAddr;
  String? supplierCountry;
  String? supplierCity;
  String? supplierContactNo;
  String? postalCd;
  String? supplierTypeName;
  String? dialCode;
  int? supplierCountryId;

  Supplier({
    this.no,
    this.createdBy,
    this.createdDt,
    this.changedBy,
    this.changedDt,
    this.countryCity,
    this.totalAccount,
    this.supplierName,
    this.supplierCd,
    this.contactNumber,
    this.supplierTypeCd,
    this.supplierAddr,
    this.supplierCountry,
    this.supplierCity,
    this.supplierContactNo,
    this.postalCd,
    this.supplierCountryId,
    this.supplierTypeName,
    this.dialCode,
  });

  Supplier.map(Map<String, dynamic> obj) {
    no = obj['no'];
    createdBy = obj['createdBy'];
    createdDt = obj['createdDt'];
    changedBy = obj['changedBy'];
    changedDt = obj['changedDt'];
    countryCity = obj['countryCity'];
    totalAccount = obj['totalAccount'];
    supplierName = obj['supplierName'];
    supplierCd = obj['supplierCd'];
    supplierTypeCd = obj['supplierTypeCd'];
    contactNumber = obj['contactNumber'];
    supplierAddr = obj['supplierAddr'];
    supplierCountry = obj['supplierCountry'];
    supplierCity = obj['supplierCity'];
    supplierContactNo = obj['supplierContactNo'];
    postalCd = obj['postalCd'];
    supplierCountryId = obj['supplierCountryId'];
    supplierTypeName = obj['supplierTypeName'];
    dialCode = obj['dialCode'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdBy'] = createdBy;
    data['createdDt'] = createdDt;
    data['changedBy'] = changedBy;
    data['changedDt'] = changedDt;
    data['countryCity'] = countryCity;
    data['totalAccount'] = totalAccount;
    data['supplierName'] = supplierName;
    data['supplierCd'] = supplierCd;
    data['supplierTypeCd'] = supplierTypeCd;
    data['contactNumber'] = contactNumber;
    return data;
  }

  Map<String, dynamic> toAdd() {
    Map<String, dynamic> data = {};
    data['supplierCd'] = supplierCd;
    data['supplierTypeCd'] = supplierTypeCd;
    data['supplierName'] = supplierName;
    data['supplierAddr'] = supplierAddr;
    data['supplierCountry'] = supplierCountry;
    data['supplierCity'] = supplierCity;
    data['supplierContactNo'] = supplierContactNo;
    data['postalCd'] = postalCd;
    data['supplierCountryId'] = supplierCountryId;
    data['dialCode'] = dialCode;
    return data;
  }
}

class ListCountryDropdown {
  int? countryId;
  String? iso;
  String? countryName;
  String? niceName;
  String? iso3;
  String? numCode;
  int? phoneCode;

  ListCountryDropdown(
      {this.countryId,
      this.iso,
      this.countryName,
      this.niceName,
      this.iso3,
      this.numCode,
      this.phoneCode});

  ListCountryDropdown.fromJson(Map<String, dynamic> json) {
    countryId = json['countryId'];
    iso = json['iso'];
    countryName = json['countryName'];
    niceName = json['niceName'];
    iso3 = json['iso3'];
    numCode = json['numCode'];
    phoneCode = json['phoneCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryId'] = countryId;
    data['iso'] = iso;
    data['countryName'] = countryName;
    data['niceName'] = niceName;
    data['iso3'] = iso3;
    data['numCode'] = numCode;
    data['phoneCode'] = phoneCode;
    return data;
  }
}
