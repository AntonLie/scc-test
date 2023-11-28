import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/transaction/bloc/transaction_bloc.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/transaction.dart';
import 'package:scc_web/widgets/transaction/transaction_table_item.dart';

class TransactionTable extends StatefulWidget {
  const TransactionTable({super.key});

  @override
  State<TransactionTable> createState() => _TransactionTableState();
}

class _TransactionTableState extends State<TransactionTable> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) => TransactionBloc()
              ..add(
                GetTransactionData(
                  model: TransactionModel(),
                  paging: Paging(pageNo: 1, pageSize: 5),
                ),
              ),
          ),
        ],
        child: Scrollbar(
          thumbVisibility: false,
          controller: scrollController,
          child: const TransactionTableItem(),
        ));
  }
}
