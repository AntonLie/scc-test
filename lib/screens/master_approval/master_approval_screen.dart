import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/approval/bloc/approval_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/permitted_feat/bloc/permitted_feat_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/approval.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permitted_func_feat.dart';
import 'package:scc_web/screens/master_approval/approv_reject.dart';
import 'package:scc_web/screens/master_approval/master_approval_form.dart';
import 'package:scc_web/screens/master_approval/master_part_table.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
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

class MasterApprovalScreen extends StatefulWidget {
  const MasterApprovalScreen({super.key});

  @override
  State<MasterApprovalScreen> createState() => _MasterApprovalScreenState();
}

class _MasterApprovalScreenState extends State<MasterApprovalScreen> {
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
            create: (context) => ApprovalBloc()
              ..add(GetApprovalData(
                paging: Paging(pageNo: 1, pageSize: 5),
                model: ListApproval(),
              )),
          ),
          BlocProvider(
            create: (context) => PermittedFeatBloc()
              ..add(
                GetPermitted(Constant.approval_Item),
              ),
          )
        ],
        child: const MasterApprovalBody(),
      ),
    );
  }
}

class MasterApprovalBody extends StatefulWidget {
  const MasterApprovalBody({super.key});

  @override
  State<MasterApprovalBody> createState() => _MasterApprovalBodyState();
}

class _MasterApprovalBodyState extends State<MasterApprovalBody> {
  final approvalScroll = ScrollController();
  late TextEditingController searchCo;
  String formMode = "";
  ListApproval modelSearch = ListApproval();
  List<ListApproval> dataApproval = [];
  late KeyVal searchCatSelected = KeyVal("All", "");
  late KeyVal searchStatusSelected = KeyVal("All", "");
  late KeyVal searchSuppSelected = KeyVal("All", "");
  List<KeyVal> searchCat = [];
  Login? login;
  bool expandNavBar = true;
  bool showNavBar = true;
  PermittedFunc? permitted;
  FeatureList? premittedApprove;
  FeatureList? premittedView;
  FeatureList? premittedReject;
  bool isSuperAdmin = false;

  String? searchVal;
  Paging paging = Paging(
    pageNo: 1,
    pageSize: 5,
  );
  final List<KeyVal> listSupp = [];
  final List<KeyVal> listSys = [];
  bloc(ApprovalEvent event) {
    BlocProvider.of<ApprovalBloc>(context).add(event);
  }

  authBloc(AuthEvent event) {
    BlocProvider.of<AuthBloc>(context).add(event);
  }

  homeBloc(HomeEvent event) {
    BlocProvider.of<HomeBloc>(context).add(event);
  }

  @override
  void initState() {
    searchCo = TextEditingController();
    searchCat.add(
      KeyVal("Item Code", Constant.itemCode),
    );
    searchCat.add(
      KeyVal("Item Name", Constant.itemName),
    );

    searchCatSelected = searchCat[0];

    super.initState();
  }

  onSearch(String? value) {
    modelSearch = ListApproval(
      supplierCd: searchSuppSelected.value,
      searchBy: searchCatSelected.value,
      searchValue: searchVal,
      statusCd: searchStatusSelected.value,
    );
    paging.pageNo = 1;
    bloc(GetApprovalData(model: modelSearch, paging: paging));
  }

  onReject(ListApproval? model) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider(
            create: (context) => ApprovalBloc(),
            child: ApprovReject(
              model: model!,
              reject: Constant.PNS_REJECTED,
              onLogout: () {},
              onError: (val) {
                ApprovalError(val);
              },
            ),
          );
        }).then((val) {
      if (val == true) {
        searchCo.clear();
        // searchVal = '';
        paging.pageNo = 1;
        // searchVal = "";
        // modelSearch = GetNewPointData(pointName: "");
        onSearch("");
      }
    });
  }

  onApprov(ListApproval? model) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider(
            create: (context) => ApprovalBloc(),
            child: ApprovReject(
              model: model!,
              reject: Constant.PNS_APPROVED,
              onLogout: () {},
              onError: (val) {
                ApprovalError(val);
              },
            ),
          );
        }).then((val) {
      if (val == true) {
        searchCo.clear();
        // searchVal = '';
        paging.pageNo = 1;
        // searchVal = "";
        // modelSearch = GetNewPointData(pointName: "");
        onSearch("");
      }
    });
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
              ApprovalError(state.error);
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
        BlocListener<ApprovalBloc, ApprovalState>(
          listener: (context, state) {
            if (state is DataApproval) {
              dataApproval.clear();
              listSupp.clear();
              listSys.clear();
              setState(() {
                formMode = "";
              });

              if (state.paging != null) {
                paging = state.paging!;
              }
              listSupp.add(KeyVal('All', ""));
              listSys.add(KeyVal("All", ""));

              dataApproval.addAll(state.model!);
              listSupp.addAll(state.listSupp);
              for (var element in state.listSysMaster) {
                listSys.add(KeyVal(element.systemValue!, element.systemCd!));
              }
            }
            if (state is ApprovalError) {
              showTopSnackBar(context, UpperSnackBar.error(message: state.msg));
            }
          },
        ),
        BlocListener<PermittedFeatBloc, PermittedFeatState>(
          listener: (context, state) {
            if (state is PermittedFeatSuccess) {
              permitted = state.model;

              premittedApprove = permitted?.featureList
                  ?.firstWhere((e) => e.featureCd == Constant.F_APPROVE);
              premittedReject = permitted?.featureList
                  ?.firstWhere((e) => e.featureCd == Constant.F_REJECT);
              premittedView = permitted?.featureList
                  ?.firstWhere((e) => e.featureCd == Constant.F_DETAIL);
              isSuperAdmin = (permitted?.superAdmin ?? false);
              onSearch("");
            }
            if (state is PermittedFeatError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.errMsg));
            }
            if (state is OnLogoutPermittedFeat) {
              authBloc(AuthLogin());
            }
          },
        )
      ],
      child: Column(
        children: [
          BlocProvider(
            create: (context) => ProfileBloc()..add(GetProfileData()),
            child: CustomAppBar(
              menuTitle: "Approval Item",
              menuName: "Master Approval Item",
              formMode: formMode,
              onClick: () {
                setState(() {
                  formMode = "";
                });
                onSearch("");
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableWidget(
                  expand: context.isDesktop() && (!isFullscreen(context)),
                  axisDirection: Axis.horizontal,
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
                      selectedTile: Constant.approval_Item,
                    ),
                  ),
                ),
                Expanded(
                    child: Scrollbar(
                        controller: approvalScroll,
                        child: SingleChildScrollView(
                            controller: approvalScroll,
                            padding: const EdgeInsets.only(
                                top: 16, left: 25, right: 25),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  BlocBuilder<ApprovalBloc, ApprovalState>(
                                      builder: (context, state) {
                                    if (state is ApprovalForm) {
                                      return Column(children: [
                                        Row(
                                          children: [
                                            const Text('Last Update on : '),
                                            Text(state.model!.lastUpdatedDate!),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text('Last Update on : '),
                                            Text(state.model!.lastUpdateBy!),
                                          ],
                                        ),
                                        Container(
                                          padding: isMobile
                                              ? EdgeInsets.zero
                                              : const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                  // horizontal: 24,
                                                ),
                                          child: MasterApprovalForm(
                                            model: state.model!,
                                            onApprove: () {
                                              ListApproval model = ListApproval(
                                                  itemCd: state.model!.itemCd,
                                                  itemName:
                                                      state.model!.itemName,
                                                  supplierCd:
                                                      state.model!.supplierCd,
                                                  supplierName: state
                                                      .model!.supplierName);
                                              onApprov(model);
                                            },
                                            onReject: () {
                                              ListApproval model = ListApproval(
                                                  itemCd: state.model!.itemCd,
                                                  itemName:
                                                      state.model!.itemName,
                                                  supplierCd:
                                                      state.model!.supplierCd,
                                                  supplierName: state
                                                      .model!.supplierName);
                                              onReject(model);
                                            },
                                            onClose: () {
                                              onSearch("");
                                            },
                                          ),
                                        ),
                                      ]);
                                    } else {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: context.deviceWidth() *
                                                    0.135,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8, left: 4),
                                                    child: Text(
                                                      'Supplier',
                                                      style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(14),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: context.deviceWidth() *
                                                    0.14,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8, left: 4),
                                                    child: Text(
                                                      'Status',
                                                      style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(14),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8, left: 4),
                                                    child: Text(
                                                      'Search by',
                                                      style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(14),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Expanded(
                                                flex: 3,
                                                child: SizedBox(),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 48,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: context.deviceWidth() *
                                                      0.13,
                                                  child: PortalDropdown(
                                                    selectedItem:
                                                        searchSuppSelected,

                                                    items: listSupp,
                                                    isBold: false,
                                                    // enabled: searchCat.length > 1,
                                                    borderRadius: 12,
                                                    onChange: (value) {
                                                      setState(() {
                                                        searchSuppSelected =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: context.deviceWidth() *
                                                      0.13,
                                                  child: PortalDropdown(
                                                    selectedItem:
                                                        searchStatusSelected,

                                                    items: listSys,
                                                    isBold: false,
                                                    // enabled: searchCat.length > 1,
                                                    borderRadius: 12,
                                                    onChange: (value) {
                                                      setState(() {
                                                        searchStatusSelected =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: PortalDropdown(
                                                    selectedItem:
                                                        searchCatSelected,
                                                    borderRadiusBotRight: 0,
                                                    borderRadiusTopRight: 0,
                                                    items: searchCat,
                                                    isBold: false,
                                                    // enabled: searchCat.length > 1,
                                                    borderRadius: 12,
                                                    onChange: (value) {
                                                      setState(() {
                                                        searchCatSelected =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: PlainSearchField(
                                                      controller: searchCo,
                                                      borderRadiusTopLeft: 0,
                                                      borderRadiusBotLeft: 0,
                                                      hint:
                                                          "Search ${searchCatSelected.label}...",
                                                      borderRadius: 12,
                                                      fillColor: sccBackground,
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
                                                                  searchCo
                                                                      .clear();
                                                                  searchVal =
                                                                      '';
                                                                });
                                                                onSearch("");
                                                              },
                                                              icon:
                                                                  const HeroIcon(
                                                                HeroIcons
                                                                    .xCircle,
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
                                                      onSearch: () {
                                                        onSearch(searchVal);
                                                      },
                                                      onAction: (value) {
                                                        onSearch(value);
                                                      }),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                ButtonConfirm(
                                                  text: 'Reset',
                                                  width: context.deviceWidth() *
                                                      (context.isDesktop()
                                                          ? 0.14
                                                          : 0.38),
                                                  height: 48,
                                                  onTap: () {
                                                    setState(() {
                                                      searchCatSelected =
                                                          searchCat[0];
                                                      searchSuppSelected =
                                                          listSupp[0];
                                                      searchStatusSelected =
                                                          listSys[0];
                                                      searchCo.clear();
                                                      searchVal = "";
                                                    });

                                                    onSearch("");
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          CommonShimmer(
                                            isLoading: state is ApprovalLoading,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: isMobile
                                                    ? Colors.transparent
                                                    : sccWhite,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 2,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding: isMobile
                                                  ? EdgeInsets.zero
                                                  : const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      // horizontal: 24,
                                                    ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Approval Item',
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
                                                              setState(() {
                                                                paging.pageSize =
                                                                    val;
                                                              });
                                                              paging.pageNo =
                                                                  paging.pageNo! -
                                                                      1;
                                                              paging.pageNo = 1;
                                                            }
                                                            onSearch("");
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  ApprovalTable(
                                                    canView:
                                                        premittedView != null,
                                                    canApprove:
                                                        premittedApprove !=
                                                            null,
                                                    canReject:
                                                        premittedReject != null,
                                                    dataApproval: dataApproval,
                                                    onApprove: (val) {
                                                      onApprov(val);
                                                    },
                                                    onReject: (val) {
                                                      onReject(val);
                                                    },
                                                    onView: (val) {
                                                      setState(() {
                                                        formMode =
                                                            Constant.viewMode;
                                                      });
                                                      bloc(LoadFormApproval(
                                                          itemCd: val.itemCd,
                                                          supplierCd:
                                                              val.supplierCd,
                                                          formMode: formMode));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          BlocBuilder<ApprovalBloc,
                                              ApprovalState>(
                                            builder: (context, state) {
                                              return Visibility(
                                                visible: !isMobile &&
                                                    paging.totalPages != null &&
                                                    paging.totalData != null &&
                                                    dataApproval.isNotEmpty,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: SimplePaging(
                                                    pageNo: paging.pageNo!,
                                                    pageToDisplay:
                                                        isMobile ? 3 : 5,
                                                    totalPages:
                                                        paging.totalPages,
                                                    pageSize: paging.pageSize,
                                                    totalDataInPage:
                                                        paging.totalDataInPage,
                                                    totalData: paging.totalData,
                                                    onClick: (value) {
                                                      paging.pageNo = value;
                                                      bloc(GetApprovalData(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                    onClickFirstPage: () {
                                                      paging.pageNo = 1;
                                                      bloc(GetApprovalData(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                    onClickPrevious: () {
                                                      paging.pageNo =
                                                          paging.pageNo! - 1;
                                                      bloc(GetApprovalData(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                    onClickNext: () {
                                                      paging.pageNo =
                                                          paging.pageNo! + 1;
                                                      bloc(GetApprovalData(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                    onClickLastPage: () {
                                                      paging.pageNo =
                                                          paging.totalPages;
                                                      bloc(GetApprovalData(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: 12.wh,
                                          ),
                                        ],
                                      );
                                    }
                                  }),
                                ]))))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
