class TransactionDetailModel {
  String? title;
  String? detailCode;
  String? currentStep;
  String? longitude;
  String? latitude;
  TransactionDetailStep? detail;
}

class TransactionDetailStep {
  String? title;
  String? address;
  String? date;
  List<String>? detail;
}
