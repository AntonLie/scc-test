// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/permitted_feat/bloc/permitted_feat_bloc.dart';
import 'package:scc_web/bloc/point/bloc/point_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permitted_func_feat.dart';
import 'package:scc_web/model/point.dart';
import 'package:scc_web/screens/MasterPoint/delete_mst_point.dart';
import 'package:scc_web/screens/MasterPoint/point_form.dart';

import 'package:scc_web/screens/MasterPoint/point_table.dart';
import 'package:scc_web/screens/MasterPoint/view_dialog.dart';
import 'package:scc_web/screens/MasterPoint/view_json.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/success_dialog.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/colors.dart';

import '../../helper/app_route.gr.dart';

class MasterPointScreen extends StatefulWidget {
  const MasterPointScreen({super.key});

  @override
  State<MasterPointScreen> createState() => _MasterPointScreenState();
}

class _MasterPointScreenState extends State<MasterPointScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sccBackground,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PointBloc()
              ..add(GetPointData(
                  paging: Paging(
                    pageNo: 1,
                    pageSize: 5,
                  ),
                  pointName: "",
                  type: "",
                  pointCd: "")),
          ),
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) => PermittedFeatBloc()
              ..add(
                GetPermitted(Constant.point),
              ),
          )
        ],
        child: const MasterPointBody(),
      ),
    );
  }
}

class MasterPointBody extends StatefulWidget {
  const MasterPointBody({super.key});

  @override
  State<MasterPointBody> createState() => _MasterPointBodyState();
}

class _MasterPointBodyState extends State<MasterPointBody> {
  String formMode = "";
  bool showNavBar = true;
  bool expandNavBar = true;
  String? searchVal;
  GetNewPointData modelSearch = GetNewPointData();
  final pointScroll = ScrollController();
  List<KeyVal> searchCat = [];
  Login? login;
  PermittedFunc? permitted;
  FeatureList? premittedAdd;
  FeatureList? premittedView;
  FeatureList? premittedEdit;
  FeatureList? premittedDelete;
  bool isSuperAdmin = false;

  List<ListDataNewPoint> dataPoint = [];
  final searchCo = TextEditingController();
  late KeyVal searchCatSelected;
  Paging paging = Paging(
    pageNo: 1,
    pageSize: 5,
  );

  @override
  void initState() {
    searchCat.add(
      KeyVal("Point Name", Constant.POINT_NAME),
    );
    searchCat.add(
      KeyVal("Point Type", Constant.TYPE),
    );
    searchCatSelected = searchCat[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc(PointEvent event) {
      BlocProvider.of<PointBloc>(context).add(event);
    }

    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    homeBloc(HomeEvent event) {
      BlocProvider.of<HomeBloc>(context).add(event);
    }

    onSearch() {
      searchCo.clear();
      searchVal = '';
      paging.pageNo = 1;
      searchVal = "";
      modelSearch = GetNewPointData(pointName: "");
      bloc(GetPointData(
          type: modelSearch.partVehicleTypeCd,
          pointName: modelSearch.pointName,
          paging: paging));
    }

    onEdit(ListDataNewPoint val) {
      setState(() {
        formMode = Constant.editMode;
      });
      bloc(LoadFormPoint(pointCd: val.pointCd, formMode: formMode));
    }

    onView(ListDataNewPoint val) {
      showDialog(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (context) => PointBloc()
                ..add(GetViewData(
                    pointCd: val.pointCd, formMode: Constant.viewMode)),
              child: ViewDialogPoint(
                onEdit: () {
                  context.back();
                  onEdit(val);
                },
              ),
            );
          });
    }

    onDeleteAction(ListDataNewPoint val) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return BlocProvider(
            create: (context) => PointBloc(),
            child: DeletePointDialog(
              title: "Success",
              pointCd: val.pointCd!,
              pointName: val.pointName ?? "",
              onError: (value) {
                PointError(value);
              },
              onLogout: () {
                authBloc(AuthLogin());
              },
            ),
          );
        },
      ).then((val) {
        if (val == true) {
          searchCo.clear();
          // searchVal = '';
          paging.pageNo = 1;
          // searchVal = "";
          // modelSearch = GetNewPointData(pointName: "");
          onSearch();
        }
      });
    }

    onJson(ListDataNewPoint val) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return BlocProvider(
              create: (context) => PointBloc()
                ..add(GetViewData(
                    formMode: Constant.viewNotif, pointCd: val.pointCd)),
              child: const ViewJson());
        },
      );
    }

    pointError(String? msg) {
      showTopSnackBar(
          context, UpperSnackBar.error(message: msg ?? "Error occured"));
    }

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
              PointError(state.error);
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
        BlocListener<PointBloc, PointState>(
          listener: (context, state) {
            if (state is DataPoint) {
              dataPoint.clear();
              setState(() {
                if (state.paging != null) {
                  paging = state.paging!;
                }
                dataPoint.addAll(state.model!);
              });
            }
            if (state is PointSubmited) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) {
                  return SuccessDialog(
                    title: "Master Point process successfully",
                    msg: state.msg,
                    buttonText: "OK",
                    onTap: () => context.back(),
                  );
                },
              ).then((value) {
                paging.pageNo = 1;
                searchVal = '';
                onSearch();
              });
              setState(() {
                formMode = "";
              });
            }
            if (state is PointError) {
              pointError(state.msg);
            }
          },
        ),
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
              permitted = state.model;

              premittedAdd = permitted?.featureList
                  ?.firstWhere((e) => e.featureCd == Constant.F_ADD);
              premittedEdit = permitted?.featureList
                  ?.firstWhere((e) => e.featureCd == Constant.F_EDIT);
              premittedDelete = permitted?.featureList
                  ?.firstWhere((e) => e.featureCd == Constant.F_DELETE);
              isSuperAdmin = (permitted?.superAdmin ?? false);
              onSearch();
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
          Visibility(
            visible: !isMobile,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (context) => ProfileBloc()..add(GetProfileData())),
                BlocProvider(
                  create: (context) => AuthBloc(),
                ),
                // BlocProvider(
                //   create: (context) => HomeBloc(),
                // ),
              ],
              child: CustomAppBar(
                menuTitle: "Point",
                menuName: "Master Point",
                formMode: formMode,
                onClick: () {
                  onSearch();
                  setState(() {
                    formMode = "";
                  });
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
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpandableWidget(
                expand: context.isDesktop() && showNavBar,
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
                    selectedTile: Constant.point,
                  ),
                ),
              ),
              Expanded(
                  child: Scrollbar(
                      controller: pointScroll,
                      child: SingleChildScrollView(
                        controller: pointScroll,
                        padding:
                            const EdgeInsets.only(top: 16, left: 25, right: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BlocBuilder<PointBloc, PointState>(
                                builder: (context, state) {
                              if (state is PointFormState) {
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isMobile
                                            ? Colors.white
                                            : sccBackground,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: isMobile
                                          ? EdgeInsets.zero
                                          : const EdgeInsets.symmetric(
                                              vertical: 16,
                                              // horizontal: 24,
                                            ),
                                      child: PointForm(
                                        listAttr: state.listAttr,
                                        listTemplateAttr: state.listTempAttr,
                                        listPointTyp: state.listPointTyp,
                                        listTyp: state.listTyp,
                                        model: state.model,
                                        listProType: state.listProType,
                                        formMode: formMode,
                                        listNodeBlock: state.listNodeBlock,
                                        onClose: () {
                                          onSearch();
                                          setState(() {
                                            formMode = "";
                                          });
                                        },
                                        onSubmit: (val) {
                                          bloc(SubmitedPoint(
                                              model: val, formMode: formMode));
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8, left: 4),
                                        child: Text(
                                          'Search by ',
                                          style: TextStyle(
                                            fontSize: context.scaleFont(14),
                                            fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 48,
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: PortalDropdown(
                                                selectedItem: searchCatSelected,
                                                borderRadiusBotRight: 0,
                                                borderRadiusTopRight: 0,
                                                items: searchCat,
                                                isBold: false,
                                                // enabled: searchCat.length > 1,
                                                borderRadius: 12,
                                                onChange: (value) {
                                                  setState(() {
                                                    searchCatSelected = value;
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
                                                prefix: searchCo.text.isNotEmpty
                                                    ? IconButton(
                                                        // splashRadius: 0,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        splashColor:
                                                            Colors.transparent,
                                                        onPressed: () {
                                                          setState(() {
                                                            searchCo.clear();
                                                            searchVal = '';
                                                            paging.pageNo = 1;
                                                            onSearch();
                                                          });
                                                        },
                                                        icon: const HeroIcon(
                                                          HeroIcons.xCircle,
                                                          color: sccText4,
                                                        ),
                                                      )
                                                    : null,
                                                onChanged: (value) {
                                                  setState(() {
                                                    searchVal = value?.trim();
                                                  });
                                                },
                                                onSearch: () {
                                                  modelSearch = GetNewPointData(
                                                    type: searchCatSelected
                                                                .value ==
                                                            Constant.TYPE
                                                        ? searchVal
                                                        : null,
                                                    pointName: searchCatSelected
                                                                .value ==
                                                            Constant.POINT_NAME
                                                        ? searchVal
                                                        : null,
                                                  );
                                                  paging.pageNo = 1;
                                                  bloc(GetPointData(
                                                      type: modelSearch.type,
                                                      pointCd: null,
                                                      pointName:
                                                          modelSearch.pointName,
                                                      paging: paging));
                                                },
                                                onAction: (value) {
                                                  modelSearch = GetNewPointData(
                                                    type: searchCatSelected
                                                                .value ==
                                                            Constant.TYPE
                                                        ? searchVal
                                                        : null,
                                                    pointName: searchCatSelected
                                                                .value ==
                                                            Constant.POINT_NAME
                                                        ? searchVal
                                                        : null,
                                                  );
                                                  paging.pageNo = 1;
                                                  bloc(GetPointData(
                                                      type: modelSearch.type,
                                                      pointCd: null,
                                                      pointName:
                                                          modelSearch.pointName,
                                                      paging: paging));
                                                },
                                              ),
                                            ),
                                            const Expanded(
                                              flex: 4,
                                              child: SizedBox(
                                                  // width: 10,
                                                  ),
                                            ),
                                            (premittedAdd != null)
                                                ? ButtonConfirmWithIcon(
                                                    icon: HeroIcon(
                                                      HeroIcons.plus,
                                                      color: sccWhite,
                                                      size:
                                                          context.scaleFont(14),
                                                    ),
                                                    text: "Add New",
                                                    borderRadius: 12,
                                                    width:
                                                        context.deviceWidth() *
                                                            (context.isDesktop()
                                                                ? 0.14
                                                                : 0.38),
                                                    onTap: () {
                                                      setState(() {
                                                        formMode =
                                                            Constant.addMode;
                                                      });
                                                      bloc(LoadFormPoint(
                                                          formMode: formMode));
                                                    },
                                                    colour: sccNavText2,
                                                  )
                                                : const SizedBox()
                                          ]),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    CommonShimmer(
                                      isLoading: state is PointLoading,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isMobile
                                              ? Colors.transparent
                                              : sccWhite,
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Point',
                                                    style: TextStyle(
                                                      fontSize:
                                                          context.scaleFont(18),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xff2B2B2B),
                                                    ),
                                                  ),
                                                  PagingDropdown(
                                                    selected:
                                                        (paging.pageSize ?? 0)
                                                            .toString(),
                                                    onSelect: (val) {
                                                      if (paging.pageSize !=
                                                          val) {
                                                        setState(() {
                                                          paging.pageSize = val;
                                                        });
                                                        paging.pageNo =
                                                            paging.pageNo! - 1;
                                                        paging.pageNo = 1;
                                                      }
                                                      onSearch();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            MasterPointTable(
                                              canView: true,
                                              canDelete:
                                                  premittedDelete != null,
                                              canUpdate: premittedEdit != null,
                                              canJson: true,
                                              listModel: dataPoint,
                                              onJson: (val) {
                                                onJson(val);
                                              },
                                              onDelete: (val) {
                                                onDeleteAction(val);
                                              },
                                              onEdit: (val) {
                                                onEdit(val);
                                              },
                                              onView: (val) {
                                                onView(val);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    BlocBuilder<PointBloc, PointState>(
                                      builder: (context, state) {
                                        return Visibility(
                                          visible: !isMobile &&
                                              paging.totalPages != null &&
                                              paging.totalData != null &&
                                              dataPoint.isNotEmpty,
                                          child: CommonShimmer(
                                            isLoading: state is PointLoading,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SimplePaging(
                                                  pageNo: paging.pageNo!,
                                                  pageToDisplay:
                                                      isMobile ? 3 : 5,
                                                  totalPages: paging.totalPages,
                                                  pageSize: paging.pageSize,
                                                  totalDataInPage:
                                                      paging.totalDataInPage,
                                                  totalData: paging.totalData,
                                                  onClick: (value) {
                                                    paging.pageNo = value;
                                                    bloc(GetPointData(
                                                        type: modelSearch.type,
                                                        pointName: modelSearch
                                                            .pointName,
                                                        paging: paging));
                                                  },
                                                  onClickFirstPage: () {
                                                    paging.pageNo = 1;
                                                    bloc(GetPointData(
                                                        type: modelSearch.type,
                                                        pointName: modelSearch
                                                            .pointName,
                                                        paging: paging));
                                                  },
                                                  onClickPrevious: () {
                                                    paging.pageNo =
                                                        paging.pageNo! - 1;
                                                    bloc(GetPointData(
                                                        type: modelSearch.type,
                                                        pointName: modelSearch
                                                            .pointName,
                                                        paging: paging));
                                                  },
                                                  onClickNext: () {
                                                    paging.pageNo =
                                                        paging.pageNo! + 1;
                                                    bloc(GetPointData(
                                                        type: modelSearch.type,
                                                        pointName: modelSearch
                                                            .pointName,
                                                        paging: paging));
                                                  },
                                                  onClickLastPage: () {
                                                    paging.pageNo =
                                                        paging.totalPages;
                                                    bloc(GetPointData(
                                                        type: modelSearch.type,
                                                        pointName: modelSearch
                                                            .pointName,
                                                        paging: paging));
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }
                            }),
                          ],
                        ),
                      ))),
            ],
          ))
        ],
      ),
    );
  }
}
