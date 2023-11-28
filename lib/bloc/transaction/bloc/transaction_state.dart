part of 'transaction_bloc.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class InitTransactionList extends TransactionState {}

class OnLogoutTransaction extends TransactionState {}

class TransactionError extends TransactionState {
  final String error;
  TransactionError(this.error);
}

class TransactionLoaded extends TransactionState {
  final List<TransactionModel>? data;
  final Paging? paging;

  TransactionLoaded(
    this.data,
    this.paging,
  );
}
