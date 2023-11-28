import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/transaction/bloc/transaction_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/transaction.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/widgets/transaction/transaction_table_row_item.dart';

class TransactionTableItem extends StatefulWidget {
  const TransactionTableItem({super.key});

  @override
  State<TransactionTableItem> createState() => _TransactionTableItemState();
}

class _TransactionTableItemState extends State<TransactionTableItem> {
  final controller = ScrollController();
  Login? login;
  List<TransactionModel> list = [];
  TransactionModel modelSearch = TransactionModel(type: "");
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  @override
  Widget build(BuildContext context) {
    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    homeBloc(HomeEvent event) {
      BlocProvider.of<HomeBloc>(context).add(event);
    }

    bloc(TransactionEvent event) {
      BlocProvider.of<TransactionBloc>(context).add(event);
    }

    onSearch(String? value) {
      modelSearch = TransactionModel(
        searchBy: "",
        searchValue: "",
      );
      paging.pageNo = 1;
      bloc(GetTransactionData(model: modelSearch, paging: paging));
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
          BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state is TransactionError) {
                showTopSnackBar(
                    context, UpperSnackBar.error(message: state.error));
              }

              if (state is OnLogoutTransaction) {
                authBloc(AuthLogin());
              }

              if (state is TransactionLoaded) {
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
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                  return Container(
                      decoration: BoxDecoration(
                        color: isMobile ? Colors.transparent : sccWhite,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonShimmer(
                            isLoading: state is TransactionLoading,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                list.isNotEmpty
                                    ? Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child:
                                            TransactionTableRowItem(list: list),
                                      )
                                    : const EmptyData()
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          BlocBuilder<TransactionBloc, TransactionState>(
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
                                      totalDataInPage: paging.totalDataInPage,
                                      totalData: paging.totalData,
                                      withPagingDropdown: true,
                                      selected:
                                          (paging.pageSize ?? 0).toString(),
                                      onSelect: (val) {
                                        if (paging.pageSize != val) {
                                          setState(() {
                                            paging.pageSize = val;
                                          });
                                          paging.pageNo = paging.pageNo! - 1;
                                          onSearch("");
                                        }
                                      },
                                      onClick: (value) {
                                        paging.pageNo = value;
                                        bloc(GetTransactionData(
                                            model: modelSearch,
                                            paging: paging));
                                      },
                                      onClickFirstPage: () {
                                        paging.pageNo = 1;
                                        bloc(GetTransactionData(
                                            model: modelSearch,
                                            paging: paging));
                                      },
                                      onClickPrevious: () {
                                        paging.pageNo = paging.pageNo! - 1;
                                        bloc(GetTransactionData(
                                            model: modelSearch,
                                            paging: paging));
                                      },
                                      onClickNext: () {
                                        paging.pageNo = paging.pageNo! + 1;
                                        bloc(GetTransactionData(
                                            model: modelSearch,
                                            paging: paging));
                                      },
                                      onClickLastPage: () {
                                        paging.pageNo = paging.totalPages;
                                        bloc(GetTransactionData(
                                            model: modelSearch,
                                            paging: paging));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ));
                })
              ],
            ),
          ),
        ));
  }
}
