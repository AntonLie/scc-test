import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/mst_use_case/bloc/use_case_bloc.dart';
import 'package:scc_web/model/paging.dart';

class UseCaseDetail extends StatefulWidget {
  final String? useCaseCd;

  const UseCaseDetail({super.key, this.useCaseCd});

  @override
  State<UseCaseDetail> createState() => _UseCaseDetailState();
}

class _UseCaseDetailState extends State<UseCaseDetail> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UseCaseBloc()
        ..add(GetUseCaseData(
            paging: Paging(pageNo: 1, pageSize: 99999),
            useCaseCd: "",
            useCaseName: "",
            statusCd: "")),
      child: UseCaseDetailBody(
        useCaseCd: widget.useCaseCd,
      ),
    );
  }
}

class UseCaseDetailBody extends StatefulWidget {
  final String? useCaseCd;

  const UseCaseDetailBody({super.key, this.useCaseCd});

  @override
  State<UseCaseDetailBody> createState() => _UseCaseDetailBodyState();
}

class _UseCaseDetailBodyState extends State<UseCaseDetailBody> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
