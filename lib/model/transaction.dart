class TransactionModel {
  int? no;
  String? itemName;
  String? itemId;
  String? itemCode;
  String? boxId;
  String? currentTouchPoint;
  String? searchBy;
  String? searchValue;
  String? type;

  TransactionModel(
      {this.no,
      this.itemName,
      this.itemId,
      this.itemCode,
      this.boxId,
      this.currentTouchPoint,
      this.searchBy,
      this.searchValue,
      this.type});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    itemName = json['itemName'];
    itemId = json['itemId'];
    itemCode = json['itemCode'];
    boxId = json['boxId'];
    currentTouchPoint = json['currentTouchPoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['itemName'] = itemName;
    data['itemId'] = itemId;
    data['itemCode'] = itemCode;
    data['boxId'] = boxId;
    data['currentTouchPoint'] = currentTouchPoint;
    data['searchBy'] = searchBy;
    data['searchValue'] = searchValue;
    data['type'] = type;

    return data;
  }
}
