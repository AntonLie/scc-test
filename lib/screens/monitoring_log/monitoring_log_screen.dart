import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/download/bloc/download_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/mon_log/bloc/mon_log_bloc.dart';
import 'package:scc_web/bloc/permitted_feat/bloc/permitted_feat_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/mon_log.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/screens/monitoring_log/log_container.dart';
import 'package:scc_web/screens/monitoring_log/log_setail_container.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/scc_calendar.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';

import '../../helper/write_web_file.dart';

class MonitoringLogScreen extends StatefulWidget {
  const MonitoringLogScreen({super.key});

  @override
  State<MonitoringLogScreen> createState() => _MonitoringLogScreenState();
}

class _MonitoringLogScreenState extends State<MonitoringLogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sccBackground,
      drawerEnableOpenDragGesture: false,
      drawer: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc()..add(GetMenu()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
        ],
        child: Container(),
        // child: NavDrawer(Constant.ROLE),
      ),
      body: SafeArea(
          child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) => MonLogBloc(),
          ),
          BlocProvider(
            create: (context) => PermittedFeatBloc()
              ..add(
                GetPermitted(Constant.MON_LOG),
              ),
          ),
          BlocProvider(
            create: (context) => DownloadBloc(),
          ),

          //bloc provider monitoring log
        ],
        child: const MonitoringLogBody(),
      )),
    );
  }
}

class MonitoringLogBody extends StatefulWidget {
  const MonitoringLogBody({super.key});

  @override
  State<MonitoringLogBody> createState() => _MonitoringLogBodyState();
}

class _MonitoringLogBodyState extends State<MonitoringLogBody> {
  final controller = ScrollController();
  bool expandNavBar = true;
  bool showNavBar = true;

  Login? login;
  late TextEditingController searchDtlCo;
  late TextEditingController searchCo;
  String? searchVal;
  String? searchDtlVal;
  String? formMode = "";
  KeyVal? searchCatSelected;
  KeyVal? processSelected;
  KeyVal? messageSelected;
  KeyVal? searchCatDetailSelected;
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  LogModel searchModel = LogModel(processId: "");
  DateTime? startDtSelected;
  DateTime? endDtSelected;
  DateTime now = DateTime.now();
  DateTimeRange? selectedRange;

  List<KeyVal> searchCat = [];
  List<KeyVal> searchCatDetail = [];
  List<KeyVal> processCat = [];
  List<KeyVal> messageType = [];
  List<LogModel> listData = [];
  List<LogModel> listDataDetail = [];
  LogModel modelSearch = LogModel(processId: "");
  LogModel? detailModel;

  @override
  void initState() {
    searchCo = TextEditingController();
    searchDtlCo = TextEditingController();

    searchCat.add(
      KeyVal("Process ID", Constant.PROCESS_ID),
    );
    searchCat.add(
      KeyVal("Module", Constant.MODULE),
    );
    searchCat.add(
      KeyVal("Function", Constant.FUNCTION),
    );
    searchCat.add(
      KeyVal("Created By", Constant.CREATED_BY),
    );
    processCat.add(
      KeyVal("All", ""),
    );
    searchCatDetail.add(
      KeyVal("Message ID", Constant.MSG_ID),
    );
    // searchCatDetail.add(
    //   KeyVal("Message Type", Constant.MSG_TYPE),
    // );
    searchCatDetail.add(
      KeyVal("Message Location", Constant.MSG_LOCATION),
    );
    searchCatDetail.add(
      KeyVal("Message Detail", Constant.MSG_DETAIL),
    );

    searchCatSelected = searchCat[0];
    processSelected = processCat[0];

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

    bloc(MonLogEvent event) {
      BlocProvider.of<MonLogBloc>(context).add(event);
    }

    downloadBloc(DownloadEvent event) {
      BlocProvider.of<DownloadBloc>(context).add(event);
    }

    onSearch(String val) {
      setState(() {
        searchModel = LogModel(
          startDt: convertDateToStringFormat(startDtSelected, "yyyy-MM-dd"),
          endDt: convertDateToStringFormat(endDtSelected, "yyyy-MM-dd"),
          processId: searchCatSelected?.value == Constant.PROCESS_ID
              ? val.trim()
              : null,
          moduleName:
              searchCatSelected?.value == Constant.MODULE ? val.trim() : null,
          functionName:
              searchCatSelected?.value == Constant.FUNCTION ? val.trim() : null,
          createdBy: searchCatSelected?.value == Constant.CREATED_BY
              ? val.trim()
              : null,
        );
      });
      // print(searchModel.toString());
    }

    onDtlSearch(String val) {
      setState(() {
        searchModel = LogModel(
          // messageTypeCd: messageTypeSelected?.value,
          messageId: searchCatDetailSelected?.value == Constant.MSG_ID
              ? val.trim()
              : null,
          // messageTypeName: searchCatDetailSelected?.value == Constant.MSG_TYPE ? val.trim() : null,
          location: searchCatDetailSelected?.value == Constant.LOCATION
              ? val.trim()
              : null,
          messageDetail: searchCatDetailSelected?.value == Constant.MSG_DETAIL
              ? val.trim()
              : null,
        );
      });
    }

    return Column(children: [
      BlocProvider(
        create: (context) => ProfileBloc()..add(GetProfileData()),
        child: CustomAppBar(
          menuTitle: "Log",
          menuName: "Monitoring Log",
          formMode: formMode,
          onClick: () {
            setState(() {
              formMode = "";
              searchVal = "";
              detailModel = null;
            });
            onSearch(searchVal ?? "");
          },
          showNavBar: showNavBar,
          initiallyExpanded: expandNavBar,
          onExpand: () {
            setState(() {
              expandNavBar = !expandNavBar;
            });
            // print(expandNavBar);
          },
        ),
      ),
      Expanded(
        child: Row(
          children: [
            ExpandableWidget(
              expand: context.isDesktop(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => HomeBloc()..add(GetMenu()),
                  ),
                  BlocProvider(
                    create: (context) => AuthBloc(),
                  ),
                ],
                child: PersistDrawer(
                  initiallyExpanded: expandNavBar,
                  selectedTile: Constant.monitoringLog,
                ),
              ),
            ),
            Expanded(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthLoggedOut) {
                        context.push(const LoginRoute());
                      }
                    },
                  ),
                  BlocListener<PermittedFeatBloc, PermittedFeatState>(
                    listener: (context, state) {
                      if (state is PermittedFeatSuccess) {
                        bloc(InitFilters());
                      }
                      if (state is PermittedFeatError) {
                        showTopSnackBar(context,
                            UpperSnackBar.error(message: state.errMsg));
                      }
                      if (state is OnLogoutPermittedFeat) {
                        authBloc(AuthLogin());
                      }
                    },
                  ),
                  BlocListener<HomeBloc, HomeState>(
                    listener: (context, state) {
                      // if (state is HomeError) {
                      //   MasterSupplierError(state.error);
                      // }
                      if (state is LoadHome) {
                        login = state.login;
                        if (login == null) {
                          homeBloc(DoLogout(login: login));
                        }
                      }
                      if (state is OnLogoutHome) {
                        authBloc(AuthLogin());
                      }
                    },
                  ),
                  BlocListener<MonLogBloc, MonLogState>(
                    listener: (context, state) {
                      if (state is LogError) {
                        showTopSnackBar(
                            context, UpperSnackBar.error(message: state.error));
                      }
                      if (state is LoadFilters) {
                        processCat.clear();
                        processCat.add(KeyVal("All", ""));
                        messageType.clear();
                        messageType.add(KeyVal("All", ""));
                        for (var element in state.listStatus) {
                          if (element.systemCd != null) {
                            processCat.add(KeyVal(
                                element.systemValue ?? "UNKNOWN STATUS",
                                element.systemCd!));
                          }
                        }
                        for (var element in state.listMessageType) {
                          if (element.systemCd != null) {
                            messageType.add(KeyVal(
                                element.systemDesc ?? "UNKNOWN STATUS",
                                element.systemCd!));
                          }
                        }
                        // messageType = messageSelected[0];
                        // processCat = processSelected[0];
                      }
                      if (state is OnLogoutLog) {
                        authBloc(AuthLogin());
                      }
                    },
                  ),
                  BlocListener<DownloadBloc, DownloadState>(
                    listener: (context, state) {
                      if (state is FileDownloaded) {
                        if (state.fileModel.base64 != null) {
                          writeFileWebExcel(state.fileModel.base64!,
                              state.fileModel.fileName);
                        }
                      }
                      if (state is DownloadError) {
                        showTopSnackBar(
                            context, UpperSnackBar.error(message: state.msg));
                      }
                      if (state is OnLogoutDownload) {
                        authBloc(AuthLogin());
                      }
                    },
                  )
                ],
                child: Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: controller,
                        child: SingleChildScrollView(
                          controller: controller,
                          padding: sccOutterPadding,
                          child: Builder(builder: (context) {
                            if (detailModel != null) {
                              return Column(
                                children: [
                                  BlocBuilder<MonLogBloc, MonLogState>(
                                    builder: (context, state) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Visibility(
                                            visible: !isMobile,
                                            child: SizedBox(
                                              width:
                                                  context.deviceWidth() * 0.1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Message Type',
                                                    style: TextStyle(
                                                      fontSize:
                                                          context.scaleFont(14),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    height: 48,
                                                    child: PortalDropdown(
                                                      selectedItem:
                                                          messageSelected,
                                                      items: messageType,
                                                      isBold: false,
                                                      hintText:
                                                          "Select Message Type",
                                                      enabled:
                                                          messageType.length >
                                                              1,
                                                      // borderRadius: 12,
                                                      onChange: (value) {
                                                        setState(() {
                                                          messageSelected =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: !isMobile,
                                            child: const SizedBox(
                                              width: 12,
                                            ),
                                          ),
                                          Visibility(
                                            visible: !isMobile,
                                            child: SizedBox(
                                              width:
                                                  context.deviceWidth() * 0.14,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Search by',
                                                    style: TextStyle(
                                                        fontSize: context
                                                            .scaleFont(14),
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    height: 48,
                                                    child:
                                                        PortalFormDropdownKeyVal(
                                                      searchCatDetailSelected,
                                                      searchCatDetail,
                                                      borderRadius: 8,
                                                      borderRadiusBotRight: 0,
                                                      borderRadiusTopRight: 0,
                                                      borderColor: sccWhite,
                                                      onChange: (value) {
                                                        setState(() {
                                                          searchCatDetailSelected =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            // flex: 3,
                                            child: StfPlainSearchField(
                                              hint: 'Input Search',
                                              value: searchDtlVal,
                                              suffixSize: 48,
                                              borderRadiusTopLeft: 0,
                                              borderRadiusBotLeft: 0,
                                              fillColor: sccFieldColor,
                                              // controller: searchDtlCo,
                                              onClear: () {
                                                searchDtlCo.clear();
                                                searchDtlVal = '';
                                                onDtlSearch(searchDtlVal ?? "");
                                              },
                                              onChanged: (value) {
                                                searchDtlVal = value;
                                              },
                                              onSearch: () {
                                                onDtlSearch(searchDtlVal ?? "");
                                              },
                                              onAction: (value) {
                                                onDtlSearch(value ?? "");
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Visibility(
                                              visible: !isMobile,
                                              child: const SizedBox(
                                                  // width:
                                                  // context.deviceWidth() * 0.025,
                                                  ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: !isMobile,
                                            child: SizedBox(
                                              height: 48,
                                              child: BlocBuilder<DownloadBloc,
                                                  DownloadState>(
                                                builder: (context, state) {
                                                  return CommonShimmer(
                                                    isLoading: state
                                                        is DownloadLoading,
                                                    child:
                                                        ButtonConfirmWithIcon(
                                                      icon: const HeroIcon(
                                                        HeroIcons.arrowDownTray,
                                                        color: sccWhite,
                                                      ),
                                                      borderRadius: 12,
                                                      text: "Download",
                                                      width: context
                                                              .deviceWidth() *
                                                          (context.isDesktop()
                                                              ? 0.14
                                                              : 0.38),
                                                      onTap: () {
                                                        downloadBloc(
                                                            DownloadLogDetails(
                                                                searchModel,
                                                                detailModel
                                                                    ?.processId));
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  LogDtlContainer(
                                    processId: detailModel?.processId,
                                    messageType: messageSelected?.value,
                                    searchModel: searchModel,
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  BlocBuilder<MonLogBloc, MonLogState>(
                                    builder: (context, state) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Visibility(
                                            visible: !isMobile,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Period',
                                                  style: TextStyle(
                                                    fontSize:
                                                        context.scaleFont(14),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  height: 48,
                                                  child: SccPeriodPicker(
                                                    height: 48,
                                                    // reset: reset,
                                                    onFinishedBuild: () {
                                                      // reset = false;
                                                    },
                                                    onRangeDateSelected: (val) {
                                                      startDtSelected =
                                                          val?.start;
                                                      endDtSelected = val?.end;
                                                    },
                                                    onStartDateChanged: (val) {
                                                      startDtSelected = val;
                                                      endDtSelected = val;
                                                    },
                                                    onEndDateChanged: (val) {
                                                      endDtSelected = val;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: !isMobile,
                                            child: const SizedBox(
                                              width: 12,
                                            ),
                                          ),
                                          Visibility(
                                            visible: !isMobile,
                                            child: SizedBox(
                                              width:
                                                  context.deviceWidth() * 0.1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Process Status',
                                                    style: TextStyle(
                                                      fontSize:
                                                          context.scaleFont(14),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    height: 48,
                                                    child: PortalDropdown(
                                                      selectedItem:
                                                          processSelected,
                                                      items: processCat,
                                                      isBold: false,
                                                      hintText: "Select Status",
                                                      enabled:
                                                          processCat.length > 1,
                                                      // borderRadius: 12,
                                                      onChange: (value) {
                                                        setState(() {
                                                          processSelected =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: !isMobile,
                                            child: const SizedBox(
                                              width: 12,
                                            ),
                                          ),
                                          Visibility(
                                            visible: !isMobile,
                                            child: SizedBox(
                                              width:
                                                  context.deviceWidth() * 0.1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Search by',
                                                    style: TextStyle(
                                                      fontSize:
                                                          context.scaleFont(14),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    height: 48,
                                                    child: PortalDropdown(
                                                      borderRadiusBotRight: 0,
                                                      borderRadiusTopRight: 0,
                                                      selectedItem:
                                                          searchCatSelected,
                                                      items: searchCat,
                                                      isBold: false,
                                                      // enabled: searchCat.length > 1,
                                                      // borderRadius: 12,
                                                      onChange: (value) {
                                                        setState(() {
                                                          searchCatSelected =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: StfPlainSearchField(
                                              value: searchVal,
                                              hint: 'Input Search',
                                              fillColor: sccFieldColor,
                                              // controller: searchCo,
                                              suffixSize: 48,
                                              borderRadiusTopLeft: 0,
                                              borderRadiusBotLeft: 0,
                                              onClear: () {
                                                searchCo.clear();
                                                searchVal = '';
                                                onSearch(searchVal ?? "");
                                              },
                                              onChanged: (value) {
                                                searchVal = value;
                                              },
                                              onSearch: () {
                                                onSearch(searchVal ?? "");
                                              },
                                              onAction: (value) {
                                                onSearch(value ?? "");
                                              },
                                            ),
                                          ),
                                          Visibility(
                                            visible: !isMobile,
                                            child: SizedBox(
                                              width:
                                                  context.deviceWidth() * 0.125,
                                            ),
                                          ),
                                          const Expanded(
                                              flex: 2, child: SizedBox())
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      LogContainer(
                                        selectedStatus:
                                            processSelected?.value ?? "",
                                        searchModel: searchModel,
                                        onTapDetail: (val) {
                                          setState(() {
                                            searchDtlCo.clear();
                                            searchDtlVal = '';
                                            searchCatDetailSelected =
                                                searchCatDetail[0];
                                            if (messageType.isNotEmpty) {
                                              messageSelected = messageType[0];
                                            } else {
                                              messageSelected = null;
                                            }
                                            formMode = val.processId;
                                            detailModel = val;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
