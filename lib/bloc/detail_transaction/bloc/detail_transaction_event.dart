part of 'detail_transaction_bloc.dart';

abstract class DetailTransactionEvent {}

class GetDetailtransactionData extends DetailTransactionEvent {
  final Paging? paging;
  final DetailTransactionModel model;
  GetDetailtransactionData({this.paging, required this.model});
}
