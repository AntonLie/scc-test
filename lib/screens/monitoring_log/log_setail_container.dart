import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/mon_log/bloc/mon_log_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/mon_log.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/screens/monitoring_log/log_detail_table.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/colors.dart';

class LogDtlContainer extends StatefulWidget {
  final String? processId, messageType;
  final LogModel searchModel;

  const LogDtlContainer(
      {super.key, this.processId, this.messageType, required this.searchModel});

  @override
  State<LogDtlContainer> createState() => _LogDtlContainerState();
}

class _LogDtlContainerState extends State<LogDtlContainer> {
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  bool dispatch = false;
  LogModel searchModel = LogModel();
  List<LogModel> listData = [];

  @override
  void initState() {
    searchModel.messageId = widget.searchModel.messageId;
    searchModel.messageType = widget.messageType;
    searchModel.location = widget.searchModel.location;
    searchModel.messageDetail = widget.searchModel.messageDetail;
    dispatch = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  void didUpdateWidget(LogDtlContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.updateable == true) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          // searchModel.processId = widget.processId;
          searchModel.messageId = widget.searchModel.messageId;
          searchModel.messageType = widget.messageType;
          searchModel.location = widget.searchModel.location;
          searchModel.messageDetail = widget.searchModel.messageDetail;
          dispatch = true;
        }));
    // }
  }

  @override
  Widget build(BuildContext context) {
    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    bloc(MonLogEvent event) {
      BlocProvider.of<MonLogBloc>(context).add(event);
    }

    if (dispatch) {
      paging.pageNo = 1;
      bloc(SearchDtlLog(
        paging: paging,
        processId: widget.processId,
        messageId: searchModel.messageId,
        // statusCd: selectedStatus,
        messageType: searchModel.messageType,
        location: searchModel.location,
        messageDtl: searchModel.messageDetail,
      ));
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
        BlocListener<MonLogBloc, MonLogState>(
          listener: (context, state) {
            if (state is LogError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.error));
            }
            if (state is LogDtlLoad) {
              if (state.paging != null) {
                paging = state.paging!;
              }
              listData.clear();
              listData.addAll(state.listModel);
            }
            if (state is OnLogoutLog) {
              authBloc(AuthLogin());
            }
          },
        ),
      ],
      child: BlocBuilder<MonLogBloc, MonLogState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonShimmer(
                isLoading: state is LogLoading,
                child: Container(
                  decoration: BoxDecoration(
                    color: isMobile ? Colors.transparent : sccWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: isMobile
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(
                          vertical: 16,
                          // horizontal: 24,
                        ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (widget.processId ?? "[UNIDENTIFIED PROCESS]")
                                  .trim(),
                              style: TextStyle(
                                fontSize: context.scaleFont(18),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff2B2B2B),
                              ),
                            ),
                            PagingDropdown(
                              selected: (paging.pageSize ?? 0).toString(),
                              onSelect: (val) {
                                if (paging.pageSize != val) {
                                  setState(() {
                                    paging.pageSize = val;
                                    dispatch = true;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      LogDtlTable(
                        listData: listData,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Visibility(
                visible: !isMobile &&
                    paging.totalPages != null &&
                    paging.totalData != null &&
                    listData.isNotEmpty, //&& state is LoadTable,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonShimmer(
                      isLoading: state is LogLoading,
                      child: SimplePaging(
                        pageNo: paging.pageNo!,
                        pageToDisplay: 5,
                        totalPages: paging.totalPages,
                        pageSize: paging.pageSize,
                        totalDataInPage: paging.totalDataInPage,
                        totalData: paging.totalData,
                        onClick: (value) {
                          paging.pageNo = value;
                          bloc(SearchDtlLog(
                            paging: paging,
                            processId: widget.processId,
                            messageId: searchModel.messageId,
                            // statusCd: selectedStatus,
                            messageType: searchModel.messageType,
                            location: searchModel.location,
                            messageDtl: searchModel.messageDetail,
                          ));
                        },
                        onClickFirstPage: () {
                          paging.pageNo = 1;
                          bloc(SearchDtlLog(
                            paging: paging,
                            processId: widget.processId,
                            messageId: searchModel.messageId,
                            // statusCd: selectedStatus,
                            messageType: searchModel.messageType,
                            location: searchModel.location,
                            messageDtl: searchModel.messageDetail,
                          ));
                        },
                        onClickPrevious: () {
                          paging.pageNo = paging.pageNo! - 1;
                          bloc(SearchDtlLog(
                            paging: paging,
                            processId: widget.processId,
                            messageId: searchModel.messageId,
                            // statusCd: selectedStatus,
                            messageType: searchModel.messageType,
                            location: searchModel.location,
                            messageDtl: searchModel.messageDetail,
                          ));
                        },
                        onClickNext: () {
                          paging.pageNo = paging.pageNo! + 1;
                          bloc(SearchDtlLog(
                            paging: paging,
                            processId: widget.processId,
                            messageId: searchModel.messageId,
                            // statusCd: selectedStatus,
                            messageType: searchModel.messageType,
                            location: searchModel.location,
                            messageDtl: searchModel.messageDetail,
                          ));
                        },
                        onClickLastPage: () {
                          paging.pageNo = paging.totalPages;
                          bloc(SearchDtlLog(
                            paging: paging,
                            processId: widget.processId,
                            messageId: searchModel.messageId,
                            // statusCd: selectedStatus,
                            messageType: searchModel.messageType,
                            location: searchModel.location,
                            messageDtl: searchModel.messageDetail,
                          ));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
