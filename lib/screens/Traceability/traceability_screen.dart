import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/bloc/traceability/bloc/tracebility_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/traceability_model.dart';
import 'package:scc_web/screens/Traceability/traceability_card.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/scc_calendar.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';

import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';

import '../../helper/app_route.gr.dart';
import 'traceability_trace.dart';

class TraceabilityScreen extends StatefulWidget {
  const TraceabilityScreen({super.key});

  @override
  State<TraceabilityScreen> createState() => _TraceabilityScreenState();
}

class _TraceabilityScreenState extends State<TraceabilityScreen> {
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sccBackground,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
              create: (context) =>
                  TracebilityBloc()..add(DropdownGetKey("ITEM", "", false))),
        ],
        child: TraceabilityBody(
          controller: controller,
          scrollTop: () {
            controller.jumpTo(0);
          },
        ),
      ),
      floatingActionButton: SizedBox(
        height: 40,
        width: 40,
        child: FloatingActionButton(
          onPressed: () {
            controller.jumpTo(0);
          },
          backgroundColor: sccButtonPurple,
          child: HeroIcon(HeroIcons.chevronDoubleUp,
              color: sccWhite, size: context.scaleFont(18)),
        ),
      ),
    );
  }
}

class TraceabilityBody extends StatefulWidget {
  final ScrollController controller;
  final Function() scrollTop;
  const TraceabilityBody(
      {super.key, required this.controller, required this.scrollTop});

  @override
  State<TraceabilityBody> createState() => _TraceabilityBodyState();
}

class _TraceabilityBodyState extends State<TraceabilityBody> {
  authBloc(AuthEvent event) {
    BlocProvider.of<AuthBloc>(context).add(event);
  }

  homeBloc(HomeEvent event) {
    BlocProvider.of<HomeBloc>(context).add(event);
  }

  bloc(TracebilityEvent event) {
    BlocProvider.of<TracebilityBloc>(context).add(event);
  }

  bool expandNavBar = true;
  final controller = ScrollController();
  late TextEditingController searchCo;
  bool showNavBar = true;
  bool isInitial = true;
  String? searchVal;
  TraceSearch submitModel = TraceSearch();

  String? searchCatSelected;
  List<KeyVal> processCat = [];
  List<ListTraceability> listTrace = [];
  ListTraceability? trace;
  String? processSelected;
  Paging paging = Paging(
    pageNo: 1,
    pageSize: 5,
  );
  List<KeyVal> sortBy = [];
  List<KeyVal> blockChain = [];
  late KeyVal sortBySelected;
  List<KeyVal> listKey = [];
  KeyVal? blockChainSelected;
  List<KeyVal> useCase = [];
  String? touchPointSelected;
  List<KeyVal> touchPointList = [];
  late String productSelected = "";
  List<KeyVal> productList = [];
  DateTime? startDtSelected;
  DateTime? endDtSelected;
  bool reset = false;

  late KeyVal? useCaseSelected = KeyVal("All", "");
  String formMode = "";
  String childMenu = "";
  Login? login;
  String? supplierCd;
  bool initial = false;
  bool isConsume = false;

  subsError(String? msg) {
    showTopSnackBar(
        context, UpperSnackBar.error(message: msg ?? "Error occured"));
  }

  @override
  void initState() {
    searchCo = TextEditingController();

    processCat = [
      KeyVal("All", ""),
      KeyVal("In Progress", "1"),
      KeyVal("Success", "2"),
      KeyVal("Success with Warning", "3"),
      KeyVal("Failed", "4"),
    ];
    sortBy = [
      KeyVal("Ascending(A-Z)", "asc"),
      KeyVal("Descending(Z-A)", "desc"),
    ];

    blockChain = [KeyVal("All", ""), KeyVal("Yes", "Yes"), KeyVal("No", "No")];

    processSelected = processCat[0].value;
    sortBySelected = sortBy[0];
    blockChainSelected = blockChain[0];
    touchPointSelected = "ITEM";
    searchCatSelected = "item_id";

    super.initState();
  }

  onSearch(String? value) {
    setState(() {
      initial = true;
    });

    submitModel = TraceSearch(
      productionDateStart: (startDtSelected != null)
          ? convertDateToStringFormat(startDtSelected, "yyyy-MM-dd")
          : "",
      productionDateEnd: (endDtSelected != null)
          ? convertDateToStringFormat(endDtSelected, "yyyy-MM-dd")
          : "",
      searchByValue: searchVal,
      tpType: touchPointSelected,
      businessUeCase: useCaseSelected?.value,
      blockchain: blockChainSelected!.value,
      searchByKey: searchCatSelected,
      sortBy: sortBySelected.value,
      product: productSelected,
    );
    paging.pageNo = 1;
    bloc(LoadTraceabilityTrace(
      paging,
      submitModel,
    ));
  }

  onBack() {
    setState(() {
      formMode = "";
      childMenu = "";
    });
    bloc(LoadTraceabilityTrace(
      Paging(pageNo: 1, pageSize: 10),
      submitModel,
    ));
  }

  onForm() {
    setState(() {
      formMode = "";
      touchPointSelected = "CONSUME";
    });
    bloc(LoadTraceabilityForm(trace!, paging, ""));
  }

  Widget onbackChild(String? childMenu, String? formMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
            visible: childMenu != "",
            child: Tooltip(
              message: "back",
              child: InkWell(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: context.deviceWidth() * 0.065,
                    height: context.deviceHeight() * 0.065,
                    decoration: BoxDecoration(
                        color: sccNavText2.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: context.scaleFont(16),
                          color: sccBlue,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Back",
                          style: TextStyle(
                            color: sccBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: context.scaleFont(16),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    if (formMode != "" && childMenu != "") {
                      onForm();
                    } else {
                      onBack();
                    }
                  }),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedOut) {
              context.push(const LoginRoute());
              // locator<NavigatorService>()
              //     .navigateReplaceTo(Constant.MENU_LOGIN);
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              subsError(state.error);
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
        BlocListener<TracebilityBloc, TracebilityState>(
          listener: (context, state) {
            if (state is TracebilityTracing) {
              listTrace.clear();
              listTrace = state.listTrace;

              if (state.paging != null) {
                paging = state.paging!;
              }
            }
            if (state is ListKey) {
              productList.clear();
              useCase.clear();
              productList.add(KeyVal("All", ""));
              useCase.add(KeyVal("All", ""));
              listKey = state.listKey;
              productList.addAll(state.listProduct);
              useCase.addAll(state.listUseCase);
              touchPointList = state.listTouch;
            }
          },
        ),
      ],
      child: Column(
        children: [
          Visibility(
            visible: !isMobile,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (context) => ProfileBloc()..add(GetProfileData())),
                BlocProvider(
                  create: (context) => AuthBloc(),
                ),
                BlocProvider(
                  create: (context) => HomeBloc(),
                ),
              ],
              child: CustomAppBar(
                menuTitle: "Traceability",
                menuName: "Traceability",
                formMode: formMode,
                childMenu: childMenu,
                onClickChild: () {
                  onForm();
                },
                onClick: () {
                  onBack();
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
          ),
          Expanded(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  selectedTile: Constant.TRACEABILITY,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: widget.controller,
                      child: SingleChildScrollView(
                          controller: widget.controller,
                          padding: sccOutterPadding,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BlocBuilder<TracebilityBloc, TracebilityState>(
                                builder: (context, state) {
                                  if (state is TracebilityForm) {
                                    return Column(children: [
                                      onbackChild(childMenu, formMode),
                                      Container(
                                          decoration: BoxDecoration(
                                            color: isMobile
                                                ? Colors.white
                                                : sccBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: isMobile
                                              ? EdgeInsets.zero
                                              : const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  // horizontal: 24,
                                                ),
                                          child: searchCatSelected !=
                                                      "item_id" &&
                                                  touchPointSelected == "ITEM"
                                              ? BlocProvider(
                                                  create: (context) =>
                                                      TracebilityBloc()
                                                        ..add(
                                                            DataTraceabilityForm(
                                                          Paging(
                                                              pageNo: 1,
                                                              pageSize: 10),
                                                          "",
                                                          supplierCd ?? "",
                                                          state.trace.itemCd,
                                                        )),
                                                  child: TraceabilityTrace(
                                                    trace: state.trace,
                                                    supplierCd: supplierCd!,
                                                    consume: touchPointSelected,
                                                    onChanged: (val) {},
                                                  ),
                                                )
                                              : touchPointSelected == "CONSUME"
                                                  ? BlocProvider(
                                                      create: (context) =>
                                                          TracebilityBloc()
                                                            ..add(
                                                                LoadTraceabilityConsumeForm(
                                                                    state.trace,
                                                                    Paging(
                                                                        pageNo:
                                                                            1,
                                                                        pageSize:
                                                                            10),
                                                                    "",
                                                                    ""))
                                                            ..add(LoadTraceabilityDetail(
                                                                state.trace
                                                                    .itemCd,
                                                                state.trace
                                                                    .itemId)),
                                                      child: TraceabilityTrace(
                                                        trace: state.trace,
                                                        consume:
                                                            touchPointSelected,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            formMode = val;
                                                          });
                                                        },
                                                      ),
                                                    )
                                                  : BlocProvider(
                                                      create: (context) =>
                                                          TracebilityBloc()
                                                            ..add(LoadTraceabilityDetail(
                                                                state.trace
                                                                    .itemCd,
                                                                state.trace
                                                                    .itemId)),
                                                      child: TraceabilityTrace(
                                                        trace: state.trace,
                                                        supplierCd: supplierCd!,
                                                        consume:
                                                            touchPointSelected,
                                                        onChanged: (val) {},
                                                      ),
                                                    ))
                                    ]);
                                  } else {
                                    return BlocBuilder<TracebilityBloc,
                                        TracebilityState>(
                                      builder: (context, state) {
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 80,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child: Row(children: [
                                                SizedBox(
                                                  height: 80,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SelectableText(
                                                        'Period',
                                                        style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(14),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      SizedBox(
                                                        height: 48,
                                                        // width: context.deviceWidth() * 0.15,
                                                        child: SccPeriodPicker(
                                                          reset: reset,
                                                          onFinishedBuild: (){
                                                                 reset = false;
                                                          },
                                                          onRangeDateSelected:
                                                              (val) {
                                                            startDtSelected =
                                                                val?.start;
                                                            endDtSelected =
                                                                val?.end;
                                                          },
                                                          onStartDateChanged:
                                                              (val) {
                                                            startDtSelected =
                                                                val;
                                                            endDtSelected = val;
                                                          },
                                                          onEndDateChanged:
                                                              (val) {
                                                            endDtSelected = val;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    height: 80,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SelectableText(
                                                          'Touch Point Type',
                                                          style: TextStyle(
                                                            fontSize: context
                                                                .scaleFont(14),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        SizedBox(
                                                          width: context
                                                                  .deviceWidth() *
                                                              0.13,
                                                          child:
                                                              PortalFormDropdown(
                                                            touchPointSelected,
                                                            touchPointList,
                                                            // enabled: searchCat.length > 1,
                                                            borderRadius: 12,
                                                            hintText:
                                                                "Chooose Touch Point",
                                                            borderColour:
                                                                sccWhite,
                                                            enabled:
                                                                touchPointList
                                                                        .length >
                                                                    1,
                                                            onChange: (value) {
                                                              setState(() {
                                                                touchPointSelected =
                                                                    value;
                                                                if (touchPointSelected ==
                                                                    "CONSUME") {
                                                                  isConsume =
                                                                      true;
                                                                } else {
                                                                  isConsume =
                                                                      false;
                                                                }
                                                                bloc(DropdownGetKey(
                                                                    value,
                                                                    "",
                                                                    isConsume));
                                                              });
                                                              onSearch(value);
                                                              submitModel
                                                                      .tpType =
                                                                  value;
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    height: 80,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SelectableText(
                                                          'Product',
                                                          style: TextStyle(
                                                            fontSize: context
                                                                .scaleFont(14),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        BlocBuilder<
                                                            TracebilityBloc,
                                                            TracebilityState>(
                                                          builder:
                                                              (context, state) {
                                                            return CommonShimmer(
                                                              isLoading: state
                                                                  is TracebilityLoading,
                                                              child: SizedBox(
                                                                width: context
                                                                        .deviceWidth() *
                                                                    0.13,
                                                                child:
                                                                    PortalFormDropdown(
                                                                  productSelected,
                                                                  productList,
                                                                  // enabled: searchCat.length > 1,
                                                                  borderRadius:
                                                                      12,
                                                                  borderColour:
                                                                      sccWhite,
                                                                  hintText:
                                                                      "Choose Product",
                                                                  enabled:
                                                                      productList
                                                                              .length >
                                                                          1,
                                                                  onChange:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      productSelected =
                                                                          value;
                                                                      bloc(DropdownGetKey(
                                                                          value,
                                                                          productSelected,
                                                                          isConsume));
                                                                    });
                                                                    submitModel
                                                                            .product =
                                                                        value;
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  height: 80,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SelectableText(
                                                        'Search By',
                                                        style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(14),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          BlocBuilder<
                                                              TracebilityBloc,
                                                              TracebilityState>(
                                                            builder: (context,
                                                                state) {
                                                              return CommonShimmer(
                                                                isLoading: state
                                                                    is TracebilityLoading,
                                                                child: SizedBox(
                                                                  width: context
                                                                          .deviceWidth() *
                                                                      0.12,
                                                                  child:
                                                                      PortalFormDropdown(
                                                                    searchCatSelected,
                                                                    listKey,
                                                                    // enabled: listKey.length > 1,
                                                                    borderRadius:
                                                                        12,
                                                                    borderRadiusTopRight:
                                                                        0,
                                                                    borderRadiusBotRight:
                                                                        0,
                                                                    borderColour:
                                                                        sccWhite,
                                                                    enabled:
                                                                        listKey.length >
                                                                            1,
                                                                    onChange:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        searchCatSelected =
                                                                            value;
                                                                      });
                                                                      submitModel
                                                                          .searchByKey;
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            // flex: 2,
                                                            width: context
                                                                    .deviceWidth() *
                                                                0.17,
                                                            child:
                                                                PlainSearchField(
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  searchVal = val
                                                                      ?.trim();
                                                                });
                                                              },
                                                              onSearch: () {
                                                                onSearch(
                                                                    searchVal);
                                                              },
                                                              onAction: (val) {
                                                                onSearch(val);
                                                              },
                                                              hint:
                                                                  'Search here..',
                                                              fillColor:
                                                                  sccFieldColor,
                                                              controller:
                                                                  searchCo,
                                                              borderRadius: 8,
                                                              borderRadiusTopLeft:
                                                                  0,
                                                              borderRadiusBotLeft:
                                                                  0,
                                                              prefix: searchCo
                                                                      .text
                                                                      .isNotEmpty
                                                                  ? IconButton(
                                                                      // splashRadius: 0,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          searchCo
                                                                              .clear();
                                                                          searchVal =
                                                                              '';
                                                                        });
                                                                        onSearch(
                                                                            searchVal);
                                                                      },
                                                                      icon:
                                                                          const HeroIcon(
                                                                        HeroIcons
                                                                            .xCircle,
                                                                        color:
                                                                            sccText4,
                                                                      ),
                                                                    )
                                                                  : null,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                            ),
                                            Container(
                                              height: 80,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Flexible(
                                                    flex: 6,
                                                    child: Row(children: [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SelectableText(
                                                              'Bussines Use Case',
                                                              style: TextStyle(
                                                                fontSize: context
                                                                    .scaleFont(
                                                                        12),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            SizedBox(
                                                              height: 44,
                                                              child:
                                                                  PortalDropdown(
                                                                borderRadius: 8,
                                                                isBold: false,
                                                                hintText:
                                                                    "Choose UseCase",
                                                                selectedItem:
                                                                    useCaseSelected,
                                                                items: useCase,
                                                                enabled: useCase
                                                                        .length >
                                                                    1,
                                                                // borderRadius: 12,
                                                                onChange:
                                                                    (value) {
                                                                  setState(() {
                                                                    useCaseSelected =
                                                                        value;
                                                                  });
                                                                  submitModel
                                                                          .businessUeCase =
                                                                      value
                                                                          .value;
                                                                  if (!isInitial) {
                                                                    widget
                                                                        .scrollTop();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SelectableText(
                                                              'Blockchain',
                                                              style: TextStyle(
                                                                fontSize: context
                                                                    .scaleFont(
                                                                        12),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            SizedBox(
                                                              height: 44,
                                                              child:
                                                                  PortalDropdown(
                                                                borderRadius: 8,
                                                                isBold: false,
                                                                selectedItem:
                                                                    blockChainSelected,
                                                                items:
                                                                    blockChain,

                                                                // enabled: searchCat.length > 1,
                                                                // borderRadius: 12,
                                                                onChange:
                                                                    (value) {
                                                                  setState(() {
                                                                    blockChainSelected =
                                                                        value;
                                                                  });
                                                                  submitModel
                                                                          .blockchain =
                                                                      value
                                                                          .value;
                                                                  if (!isInitial) {
                                                                    widget
                                                                        .scrollTop();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SelectableText(
                                                              'Sort By',
                                                              style: TextStyle(
                                                                fontSize: context
                                                                    .scaleFont(
                                                                        12),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            SizedBox(
                                                              height: 44,
                                                              child:
                                                                  PortalDropdown(
                                                                borderRadius: 8,
                                                                isBold: false,
                                                                selectedItem:
                                                                    sortBySelected,
                                                                items: sortBy,

                                                                // enabled: searchCat.length > 1,
                                                                // borderRadius: 12,
                                                                onChange:
                                                                    (value) {
                                                                  setState(() {
                                                                    sortBySelected =
                                                                        value;
                                                                  });
                                                                  submitModel
                                                                          .sortBy =
                                                                      value
                                                                          .value;
                                                                  if (!isInitial) {
                                                                    widget
                                                                        .scrollTop();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SelectableText(
                                                              '',
                                                              style: TextStyle(
                                                                fontSize: context
                                                                    .scaleFont(
                                                                        12),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            SizedBox(
                                                              height: 44,
                                                              child: ButtonReset(
                                                                  text: "Reset Filter",
                                                                  width: context.deviceWidth() * 0.16,
                                                                  borderRadius: 8,
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      processSelected =
                                                                          processCat[0]
                                                                              .value;
                                                                      sortBySelected =
                                                                          sortBy[
                                                                              0];
                                                                      blockChainSelected =
                                                                          blockChain[
                                                                              0];
                                                                      touchPointSelected =
                                                                          "ITEM";
                                                                      searchCatSelected =
                                                                          "item_id";
                                                                      productSelected =
                                                                          productList[0]
                                                                              .value;
                                                                      blockChainSelected =
                                                                          blockChain[
                                                                              0];
                                                                      useCaseSelected =
                                                                          useCase[
                                                                              0];
                                                                      startDtSelected =
                                                                          null;
                                                                      endDtSelected =
                                                                          null;
                                                                      searchVal =
                                                                          "";
                                                                      searchCo
                                                                          .clear();
                                                                      reset =
                                                                          true;
                                                                    });
                                                                    onSearch(
                                                                        "");
                                                                  }
                                                                  // premittedReset != null || isSuperAdmin

                                                                  // onSearch(searchVal);

                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            Visibility(
                                                visible: initial == false,
                                                child: const SizedBox()),
                                            Visibility(
                                              visible: initial == true,
                                              child: BlocBuilder<
                                                  TracebilityBloc,
                                                  TracebilityState>(
                                                builder: (context, state) {
                                                  return CommonShimmer(
                                                    isLoading: state is TracebilityLoading,
                                                    child: TraceabilityCard(
                                                      trace: true,
                                                      listTrace: listTrace,
                                                      traceTouch: (value) {
                                                        setState(() {
                                                          trace = value;
                                                          if (touchPointSelected ==
                                                              "CONSUME") {
                                                            childMenu =
                                                                "Traceability Consume";
                                                          } else {
                                                            childMenu =
                                                                "Traceability Item";
                                                          }
                                                  
                                                          supplierCd =
                                                              value.supplierCd;
                                                        });
                                                        bloc(LoadTraceabilityForm(
                                                            value, paging, ""));
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            BlocBuilder<TracebilityBloc,
                                                TracebilityState>(
                                              builder: (context, state) {
                                                return CommonShimmer(
                                                  isLoading: state
                                                      is TracebilityLoading,
                                                  child: Visibility(
                                                    visible: !isMobile &&
                                                        paging.totalPages !=
                                                            null &&
                                                        paging.totalData !=
                                                            null &&
                                                        listTrace.isNotEmpty,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SimplePaging(
                                                          pageNo:
                                                              paging.pageNo!,
                                                          pageToDisplay:
                                                              isMobile ? 3 : 5,
                                                          totalPages:
                                                              paging.totalPages,
                                                          pageSize:
                                                              paging.pageSize,
                                                          totalDataInPage: paging
                                                              .totalDataInPage,
                                                          totalData:
                                                              paging.totalData,
                                                          onClick: (value) {
                                                            paging.pageNo =
                                                                value;
                                                            bloc(
                                                                LoadTraceabilityTrace(
                                                              paging,
                                                              submitModel,
                                                            ));
                                                            widget.scrollTop();
                                                          },
                                                          onClickFirstPage: () {
                                                            paging.pageNo = 1;
                                                            bloc(
                                                                LoadTraceabilityTrace(
                                                              paging,
                                                              submitModel,
                                                            ));
                                                            widget.scrollTop();
                                                          },
                                                          onClickPrevious: () {
                                                            paging.pageNo =
                                                                paging.pageNo! -
                                                                    1;
                                                            bloc(
                                                                LoadTraceabilityTrace(
                                                              paging,
                                                              submitModel,
                                                            ));
                                                            widget.scrollTop();
                                                          },
                                                          onClickNext: () {
                                                            paging.pageNo =
                                                                paging.pageNo! +
                                                                    1;
                                                            bloc(
                                                                LoadTraceabilityTrace(
                                                              paging,
                                                              submitModel,
                                                            ));
                                                            widget.scrollTop();
                                                          },
                                                          onClickLastPage: () {
                                                            paging.pageNo =
                                                                paging
                                                                    .totalPages;
                                                            bloc(
                                                                LoadTraceabilityTrace(
                                                              paging,
                                                              submitModel,
                                                            ));
                                                            widget.scrollTop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ])),
        ],
      ),
    );
  }
}
