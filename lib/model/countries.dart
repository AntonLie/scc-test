class Countries {
  int? countryId;
  String? iso;
  String? countryName;
  String? niceName;
  String? iso3;
  String? numCode;
  int? phoneCode;

  Countries(
      {this.countryId,
      this.iso,
      this.countryName,
      this.niceName,
      this.iso3,
      this.numCode,
      this.phoneCode});

  Countries.fromJson(Map<String, dynamic> json) {
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
