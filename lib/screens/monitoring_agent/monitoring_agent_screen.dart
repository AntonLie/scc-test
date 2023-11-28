import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/mon_agent/bloc/mon_agent_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/company.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/mon_agent.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/screens/monitoring_agent/agent_table.dart';
import 'package:scc_web/screens/monitoring_agent/agent_tp_table.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';

class MonitoringAgentScreen extends StatefulWidget {
  const MonitoringAgentScreen({super.key});

  @override
  State<MonitoringAgentScreen> createState() => _MonitoringAgentScreenState();
}

class _MonitoringAgentScreenState extends State<MonitoringAgentScreen> {
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
        child: const PersistDrawer(
          initiallyExpanded: true,
          selectedTile: Constant.monitoringAgent,
        ),
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
              create: (context) =>
                  MonAgentBloc()..add(LoadMenuAgents(model: Agent())))
          //bloc provider monitoring agent
        ],
        child: const MonitoringAgentBody(),
      )),
    );
  }
}

class MonitoringAgentBody extends StatefulWidget {
  const MonitoringAgentBody({super.key});

  @override
  State<MonitoringAgentBody> createState() => _MonitoringAgentBodyState();
}

class _MonitoringAgentBodyState extends State<MonitoringAgentBody> {
  bool expandNavBar = true;
  bool showNavBar = true;
  KeyVal? companySelected;
  KeyVal? statusSelected;
  String? selectedSearch;
  final controller = ScrollController();
  Login? login;
  String? searchVal;
  AgentTp? detailModel;
  String toSearch = "";
  String formMode = "";

  late TextEditingController searchCo;
  late TextEditingController searchDetailCo;

  List<KeyVal> statusOptions = [];
  List<Company> listCompany = [];
  List<KeyVal> companyOptions = [];
  List<Agent> listAgent = [];
  List<AgentTp> listTP = [];
  List<SortedAgent> searchList = [];
  List<KeyVal> listSearchBy = [];

  Paging paging = Paging(pageNo: 1, pageSize: 5);
  Paging pagingDetails = Paging(pageNo: 1, pageSize: 5);

  Agent modelSearch = Agent(companyCd: "");

  @override
  void initState() {
    searchCo = TextEditingController();
    searchDetailCo = TextEditingController();

    statusOptions.add(KeyVal("All", ""));
    companyOptions.add(KeyVal("All", ""));
    listSearchBy.add(KeyVal("All", ""));
    listSearchBy.add(KeyVal("Point Name", Constant.POINT_NAME));
    listSearchBy.add(KeyVal("Point Code", Constant.POINT_CD));

    statusSelected = statusOptions[0];
    companySelected = companyOptions[0];
    selectedSearch = listSearchBy[0].value;

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

    bloc(MonAgentEvent event) {
      BlocProvider.of<MonAgentBloc>(context).add(event);
    }

    onRefresh({String? value}) {
      paging.pageNo = 1;
      bloc(GetAgentsLists(
          paging,
          companySelected != null ? companySelected!.value : "",
          value,
          statusSelected?.label));
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
        BlocListener<MonAgentBloc, MonAgentState>(
          listener: (context, state) {
            if (state is AgentsError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.error));
            }
            if (state is AgentTpLoaded) {
              detailModel = AgentTp(
                  clientId: state.clientId,
                  pointCd: state.pointCd,
                  pointName: state.pointName);
              if (state.paging != null) pagingDetails = state.paging!;
              listTP.clear();
              listTP.addAll(state.listAgent);
              setState(() {
                formMode = detailModel!.clientId ?? "";
              });
            }
            if (state is MenuAgentsLoaded) {
              listCompany.clear();
              listAgent.clear();
              // statusOptions.clear();
              for (var element in state.listCompany) {
                if (element.companyCd != null) {
                  companyOptions.add(KeyVal(
                      element.companyName ?? "UNKNOWN COMPANY",
                      element.companyCd ?? ""));
                }
              }
              for (var e in state.listStatus) {
                if (e.systemCd != null) {
                  statusOptions.add(KeyVal(
                      e.systemValue ?? "UNKNOWN STATUS", e.systemCd ?? ""));
                }
              }
              if (state.paging != null) {
                paging = state.paging!;
              }
              if (state.listAgent != null) {
                listAgent = state.listAgent!;
                for (var element in listAgent) {
                  int index = searchList.indexWhere((innerElement) =>
                      element.companyCd == innerElement.companyCd);
                  if (!index.isNegative) {
                    if (searchList[index].listAgents != null) {
                      searchList[index].listAgents!.add(element);
                    } else {
                      searchList[index].listAgents = [element];
                    }
                  } else {
                    searchList.add(
                      SortedAgent(
                          companyCd: element.companyCd ?? "UNDEFINED",
                          companyName:
                              element.companyName ?? "Undefined Company Name",
                          listAgents: [element]),
                    );
                  }
                }
              } else {
                listAgent = [];
              }
            }
            if (state is AgentsLoaded) {
              listAgent.clear();
              searchList.clear();
              if (state.paging != null) paging = state.paging!;
              listAgent.addAll(state.listAgent);
              for (var element in listAgent) {
                int index = searchList.indexWhere((innerElement) =>
                    element.companyCd == innerElement.companyCd);
                if (!index.isNegative) {
                  if (searchList[index].listAgents != null) {
                    searchList[index].listAgents!.add(element);
                  } else {
                    searchList[index].listAgents = [element];
                  }
                } else {
                  searchList.add(
                    SortedAgent(
                        companyCd: element.companyCd ?? "UNDEFINED",
                        companyName:
                            element.companyName ?? "Undefined Company Name",
                        listAgents: [element]),
                  );
                }
              }
            }
          },
        ),
      ],
      child: Column(
        children: [
          BlocProvider(
            create: (context) => ProfileBloc()..add(GetProfileData()),
            child: CustomAppBar(
              menuTitle: "Agent",
              menuName: "Monitoring Agent",
              formMode: formMode,
              onClick: () {
                setState(() {
                  formMode = "";
                  searchCo.clear();
                  searchVal = '';
                  companySelected = companyOptions[0];
                  // statusSelected = statusOptions[0];
                });
                onRefresh();
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
                      selectedTile: Constant.monitoringAgent,
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<MonAgentBloc, MonAgentState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: controller,
                              child: SingleChildScrollView(
                                controller: controller,
                                padding: sccOutterPadding,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        if (state is AgentTpLoaded) {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: !isMobile,
                                                child: SizedBox(
                                                  width: context.deviceWidth() *
                                                      0.1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Status',
                                                        style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(14),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        height: 48,
                                                        child:
                                                            PortalFormDropdownKeyVal(
                                                          statusSelected,
                                                          statusOptions,
                                                          borderColor: Colors
                                                              .transparent,
                                                          onChange: (value) {
                                                            setState(() {
                                                              if (statusOptions
                                                                      .length >
                                                                  1) {
                                                                statusSelected =
                                                                    value;
                                                              }
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
                                                  width: 20,
                                                ),
                                              ),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                flex: 2,
                                                child: Visibility(
                                                  visible: !isMobile,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Filter By',
                                                        style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(14),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        height: 48,
                                                        child:
                                                            PortalFormDropdown(
                                                          selectedSearch,
                                                          listSearchBy,
                                                          // enabled: searchCat.length > 1,
                                                          // borderRadius: 12,
                                                          borderColour: Colors
                                                              .transparent,
                                                          onChange: (value) {
                                                            setState(() {
                                                              if (listSearchBy
                                                                      .length >
                                                                  1) {
                                                                selectedSearch =
                                                                    value;
                                                              }
                                                            });
                                                          },
                                                          borderRadiusTopRight:
                                                              0,
                                                          borderRadiusBotRight:
                                                              0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: SizedBox(
                                                  height: 48,
                                                  child: PlainSearchField(
                                                    controller: searchDetailCo,
                                                    borderRadiusTopLeft: 0,
                                                    borderRadiusBotLeft: 0,
                                                    fillColor: sccFieldColor,
                                                    prefix: searchDetailCo
                                                            .text.isNotEmpty
                                                        ? IconButton(
                                                            // splashRadius: 0,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            splashColor: Colors
                                                                .transparent,
                                                            onPressed: () {
                                                              setState(() {
                                                                searchDetailCo
                                                                    .clear();
                                                                searchVal = '';
                                                              });
                                                              paging.pageNo = 1;
                                                              detailModel
                                                                      ?.pointCd =
                                                                  selectedSearch ==
                                                                          Constant
                                                                              .POINT_CD
                                                                      ? searchVal
                                                                      : null;
                                                              detailModel
                                                                      ?.pointName =
                                                                  selectedSearch ==
                                                                          Constant
                                                                              .POINT_NAME
                                                                      ? searchVal
                                                                      : null;
                                                              bloc(
                                                                SearchAgentTp(
                                                                  status:
                                                                      statusSelected
                                                                          ?.label,
                                                                  clientId:
                                                                      detailModel
                                                                          ?.clientId,
                                                                  pointCd:
                                                                      detailModel
                                                                          ?.pointCd,
                                                                  pointName:
                                                                      detailModel
                                                                          ?.pointName,
                                                                  paging:
                                                                      paging,
                                                                ),
                                                              );
                                                            },
                                                            icon:
                                                                const HeroIcon(
                                                              HeroIcons.xCircle,
                                                              // solid: true,
                                                              color: sccText4,
                                                            ),
                                                          )
                                                        : null,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        searchVal =
                                                            value?.trim();
                                                      });
                                                    },
                                                    onAction: (value) {
                                                      paging.pageNo = 1;
                                                      detailModel?.pointCd =
                                                          selectedSearch ==
                                                                  Constant
                                                                      .POINT_CD
                                                              ? searchVal
                                                              : null;
                                                      detailModel?.pointName =
                                                          selectedSearch ==
                                                                  Constant
                                                                      .POINT_NAME
                                                              ? searchVal
                                                              : null;
                                                      bloc(
                                                        SearchAgentTp(
                                                          status: statusSelected
                                                              ?.label,
                                                          clientId: detailModel
                                                              ?.clientId,
                                                          pointCd: detailModel
                                                              ?.pointCd,
                                                          pointName: detailModel
                                                              ?.pointName,
                                                          paging: paging,
                                                        ),
                                                      );
                                                    },
                                                    onSearch: () {
                                                      paging.pageNo = 1;
                                                      detailModel?.pointCd =
                                                          selectedSearch ==
                                                                  Constant
                                                                      .POINT_CD
                                                              ? searchVal
                                                              : null;
                                                      detailModel?.pointName =
                                                          selectedSearch ==
                                                                  Constant
                                                                      .POINT_NAME
                                                              ? searchVal
                                                              : null;

                                                      bloc(
                                                        SearchAgentTp(
                                                          status: statusSelected
                                                              ?.label,
                                                          clientId: detailModel
                                                              ?.clientId,
                                                          pointCd: detailModel
                                                              ?.pointCd,
                                                          pointName: detailModel
                                                              ?.pointName,
                                                          paging: paging,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const Expanded(
                                                flex: 4,
                                                child: SizedBox(
                                                  width: 10,
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: !isMobile,
                                                child: SizedBox(
                                                  width: context.deviceWidth() *
                                                      0.1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Status',
                                                        style: TextStyle(
                                                            fontSize: context
                                                                .scaleFont(14),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        height: 48,
                                                        child:
                                                            PortalFormDropdownKeyVal(
                                                          statusSelected,
                                                          statusOptions,
                                                          borderColor: Colors
                                                              .transparent,
                                                          onChange: (value) {
                                                            setState(() {
                                                              if (statusOptions
                                                                      .length >
                                                                  1) {
                                                                statusSelected =
                                                                    value;
                                                              }
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
                                                  width: 20,
                                                ),
                                              ),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                flex: 2,
                                                child: Visibility(
                                                  visible: !isMobile,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Company',
                                                        style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(14),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        height: 48,
                                                        child:
                                                            PortalFormDropdownKeyVal(
                                                          companySelected,
                                                          companyOptions,
                                                          borderRadiusTopRight:
                                                              0,
                                                          borderRadiusBotRight:
                                                              0,
                                                          // enabled:
                                                          //     companyOptions
                                                          //             .length >
                                                          //         1,
                                                          borderColor: Colors
                                                              .transparent,
                                                          onChange: (value) {
                                                            if (companyOptions
                                                                    .length >
                                                                1) {
                                                              setState(() {
                                                                companySelected =
                                                                    value;
                                                              });
                                                              onRefresh(
                                                                  value:
                                                                      toSearch);
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: PlainSearchField(
                                                  hint: 'Search Client ID',
                                                  controller: searchCo,
                                                  borderRadiusTopLeft: 0,
                                                  borderRadiusBotLeft: 0,
                                                  fillColor: sccFieldColor,
                                                  prefix: searchCo
                                                          .text.isNotEmpty
                                                      ? IconButton(
                                                          // splashRadius: 0,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          splashColor: Colors
                                                              .transparent,
                                                          onPressed: () {
                                                            setState(() {
                                                              searchCo.clear();
                                                              searchVal = '';
                                                            });
                                                            paging.pageNo = 1;
                                                            searchCo.clear();
                                                            searchVal = '';
                                                            onRefresh(
                                                                value:
                                                                    searchVal);
                                                          },
                                                          icon: const HeroIcon(
                                                            HeroIcons.xCircle,
                                                            // solid: true,
                                                            color: sccText4,
                                                          ),
                                                        )
                                                      : null,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      searchVal =
                                                          value?.trim() ?? "";
                                                    });
                                                  },
                                                  onAction: (value) {
                                                    // searchVal = value?.trim();
                                                    // toSearch = searchVal ?? "";
                                                    onRefresh(value: searchVal);
                                                  },
                                                  onSearch: () {
                                                    // toSearch = searchVal ?? "";
                                                    onRefresh(value: searchVal);
                                                  },
                                                ),
                                              ),
                                              const Expanded(
                                                flex: 4,
                                                child: SizedBox(
                                                  width: 10,
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CommonShimmer(
                                      isLoading: state is AgentsLoading,
                                      child: Container(
                                        padding: isMobile
                                            ? EdgeInsets.zero
                                            : const EdgeInsets.symmetric(
                                                vertical: 8),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                          color: isMobile
                                              ? Colors.transparent
                                              : sccWhite,
                                        ),
                                        child: Builder(
                                          builder: (context) {
                                            if (state is AgentTpLoaded) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${state.clientId ?? "[UNIDENTIFIED CLIENT ID]"} Details',
                                                          style: TextStyle(
                                                            fontSize: context
                                                                .scaleFont(18),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xff2B2B2B),
                                                          ),
                                                        ),
                                                        PagingDropdown(
                                                          selected: (pagingDetails
                                                                      .pageSize ??
                                                                  0)
                                                              .toString(),
                                                          onSelect: (val) {
                                                            if (pagingDetails
                                                                    .pageSize !=
                                                                val) {
                                                              pagingDetails
                                                                  .pageNo = 1;
                                                              pagingDetails
                                                                      .pageSize =
                                                                  val;
                                                              bloc(
                                                                SearchAgentTp(
                                                                  status:
                                                                      statusSelected
                                                                          ?.label,
                                                                  clientId:
                                                                      detailModel
                                                                          ?.clientId,
                                                                  pointCd:
                                                                      detailModel
                                                                          ?.pointCd,
                                                                  pointName:
                                                                      detailModel
                                                                          ?.pointName,
                                                                  paging:
                                                                      pagingDetails,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  AgentTpTable(
                                                    listTP: listTP,
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Agent',
                                                          style: TextStyle(
                                                            fontSize: context
                                                                .scaleFont(18),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xff2B2B2B),
                                                          ),
                                                        ),
                                                        PagingDropdown(
                                                          selected:
                                                              (paging.pageSize ??
                                                                      0)
                                                                  .toString(),
                                                          onSelect: (val) {
                                                            if (paging
                                                                    .pageSize !=
                                                                val) {
                                                              paging.pageNo = 1;
                                                              paging.pageSize =
                                                                  val;
                                                              bloc(
                                                                  GetAgentsLists(
                                                                paging,
                                                                companySelected !=
                                                                        null
                                                                    ? companySelected!
                                                                        .value
                                                                    : "",
                                                                toSearch,
                                                                statusSelected
                                                                    ?.value,
                                                              ));
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  AgentTable(
                                                    listAgent: listAgent,
                                                    onView: (value) {
                                                      // detailModel?.clientId = value.clientId;
                                                      setState(() {
                                                        statusSelected =
                                                            statusOptions.first;
                                                        // formMode =
                                                        //     value.clientId ??
                                                        //         "";
                                                      });
                                                      searchDetailCo.clear();
                                                      bloc(SearchAgentTp(
                                                          status: statusSelected
                                                              ?.label,
                                                          paging: Paging(
                                                              pageNo: 1,
                                                              pageSize: 5),
                                                          clientId:
                                                              value.clientId));
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Builder(builder: (context) {
                                      if (state is AgentTpLoaded) {
                                        return Visibility(
                                          visible: pagingDetails.totalPages !=
                                                  null &&
                                              listTP.isNotEmpty,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: SimplePaging(
                                              pageNo: pagingDetails.pageNo!,
                                              pageToDisplay: isMobile ? 3 : 5,
                                              totalPages:
                                                  pagingDetails.totalPages,
                                              pageSize: pagingDetails.pageSize,
                                              totalDataInPage:
                                                  pagingDetails.totalDataInPage,
                                              totalData:
                                                  pagingDetails.totalData,
                                              onClickFirstPage: () {
                                                pagingDetails.pageNo = 1;
                                                bloc(
                                                  SearchAgentTp(
                                                    status:
                                                        statusSelected?.label,
                                                    clientId:
                                                        detailModel?.clientId,
                                                    pointCd:
                                                        detailModel?.pointCd,
                                                    pointName:
                                                        detailModel?.pointName,
                                                    paging: pagingDetails,
                                                  ),
                                                );
                                              },
                                              onClickPrevious: () {
                                                pagingDetails.pageNo =
                                                    pagingDetails.pageNo! - 1;
                                                bloc(
                                                  SearchAgentTp(
                                                    status:
                                                        statusSelected?.label,
                                                    clientId:
                                                        detailModel?.clientId,
                                                    pointCd:
                                                        detailModel?.pointCd,
                                                    pointName:
                                                        detailModel?.pointName,
                                                    paging: pagingDetails,
                                                  ),
                                                );
                                              },
                                              onClick: (value) {
                                                pagingDetails.pageNo = value;
                                                bloc(
                                                  SearchAgentTp(
                                                    status:
                                                        statusSelected?.label,
                                                    clientId:
                                                        detailModel?.clientId,
                                                    pointCd:
                                                        detailModel?.pointCd,
                                                    pointName:
                                                        detailModel?.pointName,
                                                    paging: pagingDetails,
                                                  ),
                                                );
                                              },
                                              onClickNext: () {
                                                pagingDetails.pageNo =
                                                    pagingDetails.pageNo! + 1;
                                                bloc(
                                                  SearchAgentTp(
                                                    status:
                                                        statusSelected?.label,
                                                    clientId:
                                                        detailModel?.clientId,
                                                    pointCd:
                                                        detailModel?.pointCd,
                                                    pointName:
                                                        detailModel?.pointName,
                                                    paging: pagingDetails,
                                                  ),
                                                );
                                              },
                                              onClickLastPage: () {
                                                pagingDetails.pageNo =
                                                    paging.totalPages;
                                                bloc(
                                                  SearchAgentTp(
                                                    status:
                                                        statusSelected?.label,
                                                    clientId:
                                                        detailModel?.clientId,
                                                    pointCd:
                                                        detailModel?.pointCd,
                                                    pointName:
                                                        detailModel?.pointName,
                                                    paging: pagingDetails,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Visibility(
                                          visible: paging.totalPages != null &&
                                              paging.totalPages! > 1 &&
                                              listAgent.isNotEmpty,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: SimplePaging(
                                              pageNo: paging.pageNo!,
                                              pageToDisplay: isMobile ? 3 : 5,
                                              totalPages: paging.totalPages,
                                              pageSize: paging.pageSize,
                                              totalData: paging.totalData,
                                              totalDataInPage:
                                                  paging.totalDataInPage,
                                              onClickFirstPage: () {
                                                paging.pageNo = 1;
                                                bloc(GetAgentsLists(
                                                    paging,
                                                    companySelected != null
                                                        ? companySelected!.value
                                                        : "",
                                                    toSearch,
                                                    statusSelected?.label));
                                              },
                                              onClickPrevious: () {
                                                paging.pageNo =
                                                    paging.pageNo! - 1;
                                                bloc(GetAgentsLists(
                                                    paging,
                                                    companySelected != null
                                                        ? companySelected!.value
                                                        : "",
                                                    toSearch,
                                                    statusSelected?.label));
                                              },
                                              onClick: (value) {
                                                paging.pageNo = value;
                                                bloc(GetAgentsLists(
                                                    paging,
                                                    companySelected != null
                                                        ? companySelected!.value
                                                        : "",
                                                    toSearch,
                                                    statusSelected?.label));
                                              },
                                              onClickNext: () {
                                                paging.pageNo =
                                                    paging.pageNo! + 1;
                                                bloc(GetAgentsLists(
                                                    paging,
                                                    companySelected != null
                                                        ? companySelected!.value
                                                        : "",
                                                    toSearch,
                                                    statusSelected?.label));
                                              },
                                              onClickLastPage: () {
                                                paging.pageNo =
                                                    paging.totalPages;
                                                bloc(GetAgentsLists(
                                                    paging,
                                                    companySelected != null
                                                        ? companySelected!.value
                                                        : "",
                                                    toSearch,
                                                    statusSelected?.label));
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    }),

                                    //
                                    SizedBox(
                                      height: 12.wh,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
