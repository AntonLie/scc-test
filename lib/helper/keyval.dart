class KeyVal {
  final String label;
  final String value;
  String? toParse;
  dynamic payload;
  bool? checked;

  KeyVal(this.label, this.value, {this.checked, this.toParse, this.payload});
}

class KeyDynamicVal {
  final String label;
  final dynamic value;
  String? toParse;
  bool? checked;

  KeyDynamicVal(
    this.label,
    this.value, {
    this.checked,
    this.toParse,
  });
}

class KeyvalCountry {
  int? countryId;
  String? countryName;

  KeyvalCountry(
    element, {
    this.countryId,
    this.countryName,
  });
}
