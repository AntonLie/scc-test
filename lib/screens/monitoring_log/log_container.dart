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
import 'package:scc_web/screens/monitoring_log/log_table.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/colors.dart';

class LogContainer extends StatefulWidget {
  final LogModel searchModel;
  final Function(LogModel) onTapDetail;
  final String selectedStatus;
  const LogContainer(
      {super.key,
      required this.searchModel,
      required this.onTapDetail,
      required this.selectedStatus});

  @override
  State<LogContainer> createState() => _LogContainerState();
}

class _LogContainerState extends State<LogContainer> {
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  bool dispatch = false;
  String selectedStatus = "";
  LogModel searchModel = LogModel();
  List<LogModel> listData = [];

  @override
  void initState() {
    searchModel.processId = widget.searchModel.processId;
    searchModel.moduleName = widget.searchModel.moduleName;
    searchModel.functionName = widget.searchModel.functionName;
    searchModel.createdBy = widget.searchModel.createdBy;
    searchModel.startDt = widget.searchModel.startDt;
    searchModel.endDt = widget.searchModel.endDt;
    selectedStatus = widget.selectedStatus;
    // isAdmin = widget.isAdmin;
    dispatch = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  void didUpdateWidget(LogContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.updateable == true) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          searchModel.processId = widget.searchModel.processId;
          searchModel.moduleName = widget.searchModel.moduleName;
          searchModel.functionName = widget.searchModel.functionName;
          searchModel.createdBy = widget.searchModel.createdBy;
          searchModel.startDt = widget.searchModel.startDt;
          searchModel.endDt = widget.searchModel.endDt;
          selectedStatus = widget.selectedStatus;
          // isAdmin = widget.isAdmin;
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

    if (
        // isAdmin &&
        dispatch) {
      paging.pageNo = 1;
      bloc(SearchLog(
        paging: paging,
        moduleName: searchModel.moduleName,
        processId: searchModel.processId,
        statusCd: selectedStatus,
        functionName: searchModel.functionName,
        createdBy: searchModel.createdBy,
        startDt: searchModel.startDt,
        endDt: searchModel.endDt,
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
            if (state is LogLoaded) {
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
                              'Log',
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
                      LogTable(
                        listData: listData,
                        onView: (value) {
                          widget.onTapDetail(value);
                        },
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
                          bloc(SearchLog(
                            paging: paging,
                            moduleName: searchModel.moduleName,
                            processId: searchModel.processId,
                            statusCd: selectedStatus,
                            functionName: searchModel.functionName,
                            createdBy: searchModel.createdBy,
                            startDt: searchModel.startDt,
                            endDt: searchModel.endDt,
                          ));
                        },
                        onClickFirstPage: () {
                          paging.pageNo = 1;
                          bloc(SearchLog(
                            paging: paging,
                            moduleName: searchModel.moduleName,
                            processId: searchModel.processId,
                            statusCd: selectedStatus,
                            functionName: searchModel.functionName,
                            createdBy: searchModel.createdBy,
                            startDt: searchModel.startDt,
                            endDt: searchModel.endDt,
                          ));
                        },
                        onClickPrevious: () {
                          paging.pageNo = paging.pageNo! - 1;
                          bloc(SearchLog(
                            paging: paging,
                            moduleName: searchModel.moduleName,
                            processId: searchModel.processId,
                            statusCd: selectedStatus,
                            functionName: searchModel.functionName,
                            createdBy: searchModel.createdBy,
                            startDt: searchModel.startDt,
                            endDt: searchModel.endDt,
                          ));
                        },
                        onClickNext: () {
                          paging.pageNo = paging.pageNo! + 1;
                          bloc(SearchLog(
                            paging: paging,
                            moduleName: searchModel.moduleName,
                            processId: searchModel.processId,
                            statusCd: selectedStatus,
                            functionName: searchModel.functionName,
                            createdBy: searchModel.createdBy,
                            startDt: searchModel.startDt,
                            endDt: searchModel.endDt,
                          ));
                        },
                        onClickLastPage: () {
                          paging.pageNo = paging.totalPages;
                          bloc(SearchLog(
                            paging: paging,
                            moduleName: searchModel.moduleName,
                            processId: searchModel.processId,
                            statusCd: selectedStatus,
                            functionName: searchModel.functionName,
                            createdBy: searchModel.createdBy,
                            startDt: searchModel.startDt,
                            endDt: searchModel.endDt,
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
