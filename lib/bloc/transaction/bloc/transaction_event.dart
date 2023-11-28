part of 'transaction_bloc.dart';

abstract class TransactionEvent {}

class GetTransactionData extends TransactionEvent {
  final Paging? paging;
  final TransactionModel model;
  GetTransactionData({this.paging, required this.model});
}
