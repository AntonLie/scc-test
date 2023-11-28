class Tittle {
  String? title;
  String? teks;

  Tittle({this.title, this.teks});

  Tittle.map(Map obj) {
    title = obj['title'];
    teks = obj['teks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['teks'] = teks;
    return data;
  }
}

class SubsFeatures {
  String? packageName;
  int? packageCd;
  String? packageColor;
  Map<String, Map<String, dynamic>>? rawBody;
  Map<String, dynamic>? body;

  SubsFeatures({
    this.packageName,
    this.packageCd,
    this.body,
    this.rawBody,
  });

  SubsFeatures.map(Map<String, dynamic> obj) {
    packageName = obj['packageName'];
    packageColor = obj['packageColor'];
    packageCd = obj['packageCd'];
    body = obj['body'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['packageName'] = packageName;
    data['packageCd'] = packageCd;
    data['body'] = body;
    return data;
  }
}
