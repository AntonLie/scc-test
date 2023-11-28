class ContactAdmin {
  int? packageCd;
  String? fullName;
  String? companyName;
  String? abbrCompany;
  String? industriesType;
  String? email;
  int? countryId;
  String? phoneNumber;
  String? packageTime;
  String? address;
  String? msgText;
  bool? aggrement;
  bool? consent;

  ContactAdmin(
      {this.packageCd,
      this.fullName,
      this.companyName,
      this.abbrCompany,
      this.industriesType,
      this.email,
      this.countryId,
      this.phoneNumber,
      this.packageTime,
      this.address,
      this.msgText,
      this.aggrement,
      this.consent});

  ContactAdmin.fromJson(Map<String, dynamic> json) {
    packageCd = json['packageCd'];
    fullName = json['fullName'];
    companyName = json['companyName'];
    abbrCompany = json['abbrCompany'];
    industriesType = json['industriesType'];
    email = json['email'];
    countryId = json['countryId'];
    phoneNumber = json['phoneNumber'];
    packageTime = json['packageTime'];
    address = json['address'];
    msgText = json['msgText'];
    aggrement = json['aggrement'];
    consent = json['consent'];
  }

  Map<String, dynamic> toSubmit() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['packageCd'] = packageCd;
    data['fullName'] = fullName;
    data['email'] = email;
    data['countryId'] = countryId;
    data['phoneNumber'] = phoneNumber;
    data['packageTime'] = packageTime;
    data['msgText'] = msgText;
    return data;
  }
}
