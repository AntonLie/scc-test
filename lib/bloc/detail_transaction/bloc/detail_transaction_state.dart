part of 'detail_transaction_bloc.dart';

abstract class DetailTransactionState {}

class DetailTransactionInitial extends DetailTransactionState {}

class TransactionLoading extends DetailTransactionState {}

class InitDetailTransactionList extends DetailTransactionState {}

class OnLogoutTransaction extends DetailTransactionState {}

class TransactionError extends DetailTransactionState {
  final String error;
  TransactionError(this.error);
}

class DetailTransactionLoaded extends DetailTransactionState {
  final List<DetailTransactionModel>? data;
  final Paging? paging;

  DetailTransactionLoaded(
    this.data,
    this.paging,
  );
}
