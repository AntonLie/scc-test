class DetailTransactionModel {
  int? no;
  String? itemName;
  String? itemId;
  String? startPoint;
  String? nextPoint;
  String? touchPoint;
  String? status;
  String? searchBy;
  String? searchValue;
  String? type;

  DetailTransactionModel(
      {this.no,
      this.itemName,
      this.itemId,
      this.nextPoint,
      this.startPoint,
      this.status,
      this.touchPoint,
      this.searchBy,
      this.searchValue,
      this.type});

  DetailTransactionModel.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    itemName = json['itemName'];
    itemId = json['itemId'];
    nextPoint = json['nextPoint'];
    startPoint = json['startPoint'];
    status = json['status'];
    touchPoint = json['touchPoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['itemName'] = itemName;
    data['itemId'] = itemId;
    data['nextPoint'] = nextPoint;
    data['startPoint'] = startPoint;
    data['status'] = status;
    data['touchPoint'] = touchPoint;
    data['searchBy'] = searchBy;
    data['searchValue'] = searchValue;
    data['type'] = type;

    return data;
  }
}
