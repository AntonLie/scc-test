import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/detail_transaction/bloc/detail_transaction_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/detail_transaction.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/widgets/dashboard/detail-transcation/detail_item_table.dart';

class DetailTable extends StatefulWidget {
  final String title;
  const DetailTable({super.key, required this.title});

  @override
  State<DetailTable> createState() => _DetailTableState();
}

class _DetailTableState extends State<DetailTable> {
  final controller = ScrollController();
  Login? login;
  List<DetailTransactionModel> list = [];
  DetailTransactionModel modelSearch = DetailTransactionModel(type: "");
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    homeBloc(HomeEvent event) {
      BlocProvider.of<HomeBloc>(context).add(event);
    }

    bloc(DetailTransactionEvent event) {
      BlocProvider.of<DetailTransactionBloc>(context).add(event);
    }

    return MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedOut) {
                context.push(const LoginRoute());
              }
            },
          ),
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeError) {
                TransactionError(state.error);
              }
              if (state is LoadHome) {
                login = state.login;
                if (login == null) homeBloc(DoLogout(login: login));
              }
              if (state is OnLogoutHome) {
                authBloc(AuthLogin());
              }
            },
          ),
          BlocListener<DetailTransactionBloc, DetailTransactionState>(
            listener: (context, state) {
              if (state is TransactionError) {
                showTopSnackBar(
                    context, UpperSnackBar.error(message: state.error));
              }

              if (state is OnLogoutTransaction) {
                authBloc(AuthLogin());
              }

              if (state is DetailTransactionLoaded) {
                list.clear();

                if (state.paging != null) {
                  paging = state.paging!;
                }

                if (state.data != null) {
                  list = state.data!;
                } else {
                  list = [];
                }
              }
            },
          )
        ],
        child: Scrollbar(
          thumbVisibility: true,
          controller: controller,
          child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  BlocBuilder<DetailTransactionBloc, DetailTransactionState>(
                      builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonShimmer(
                          isLoading: state is TransactionLoading,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              list.isNotEmpty
                                  ? DetailItemTable(
                                      list: list,
                                    )
                                  : const EmptyData(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Flexible(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: BlocBuilder<DetailTransactionBloc,
                                  DetailTransactionState>(
                                builder: (context, state) {
                                  return Visibility(
                                    visible: !isMobile &&
                                        paging.totalPages != null &&
                                        paging.totalData != null &&
                                        list.isNotEmpty,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SimplePaging(
                                          pageNo: paging.pageNo!,
                                          pageToDisplay: isMobile ? 3 : 5,
                                          totalPages: paging.totalPages,
                                          pageSize: paging.pageSize,
                                          totalDataInPage:
                                              paging.totalDataInPage,
                                          borderRadius: 10,
                                          totalData: paging.totalData,
                                          withPagingDropdown: true,
                                          selected:
                                              (paging.pageSize ?? 0).toString(),
                                          onSelect: (val) {
                                            if (paging.pageSize != val) {
                                              setState(() {
                                                paging.pageSize = val;
                                              });
                                              paging.pageNo =
                                                  paging.pageNo! - 1;
                                              // onSearch(searchVal);
                                            }
                                          },
                                          onClick: (value) {
                                            paging.pageNo = value;
                                            bloc(GetDetailtransactionData(
                                                model: modelSearch,
                                                paging: paging));
                                          },
                                          onClickFirstPage: () {
                                            paging.pageNo = 1;
                                            bloc(GetDetailtransactionData(
                                                model: modelSearch,
                                                paging: paging));
                                          },
                                          onClickPrevious: () {
                                            paging.pageNo = paging.pageNo! - 1;
                                            bloc(GetDetailtransactionData(
                                                model: modelSearch,
                                                paging: paging));
                                          },
                                          onClickNext: () {
                                            paging.pageNo = paging.pageNo! + 1;
                                            bloc(GetDetailtransactionData(
                                                model: modelSearch,
                                                paging: paging));
                                          },
                                          onClickLastPage: () {
                                            paging.pageNo = paging.totalPages;
                                            bloc(GetDetailtransactionData(
                                                model: modelSearch,
                                                paging: paging));
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                        )
                      ],
                    );
                  })
                ],
              )),
        ));
  }
}
