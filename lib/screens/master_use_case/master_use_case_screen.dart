import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/mst_use_case/bloc/use_case_bloc.dart';
import 'package:scc_web/bloc/permitted_feat/bloc/permitted_feat_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permitted_func_feat.dart';
import 'package:scc_web/model/use_case.dart';
import 'package:scc_web/screens/master_use_case/delete_use_case.dart';
import 'package:scc_web/screens/master_use_case/use_case_form.dart';
import 'package:scc_web/screens/master_use_case/use_case_table.dart';
import 'package:scc_web/screens/master_use_case/view_use_case.dart';
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

class MasterUseCaseScreen extends StatefulWidget {
  const MasterUseCaseScreen({super.key});

  @override
  State<MasterUseCaseScreen> createState() => _MasterUseCaseScreenState();
}

class _MasterUseCaseScreenState extends State<MasterUseCaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sccBackground,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UseCaseBloc()
              ..add(GetUseCaseData(
                  paging: Paging(pageNo: 1, pageSize: 5),
                  useCaseCd: "",
                  useCaseName: "",
                  statusCd: "")),
          ),
          BlocProvider(
            create: (context) => PermittedFeatBloc()
              ..add(
                GetPermitted(Constant.useCase),
              ),
          ),
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
        ],
        child: const MasterUseCaseBody(),
      ),
    );
  }
}

class MasterUseCaseBody extends StatefulWidget {
  const MasterUseCaseBody({super.key});

  @override
  State<MasterUseCaseBody> createState() => _MasterUseCaseBodyState();
}

class _MasterUseCaseBodyState extends State<MasterUseCaseBody> {
  String formMode = "";
  bool expandNavBar = true;
  bool showNavBar = true;
  final pointScroll = ScrollController();
  final searchCo = TextEditingController();
  late KeyVal searchCatSelected;
  List<KeyVal> searchCat = [];
  ListUseCaseData modelSearch = ListUseCaseData();
  List<ListUseCaseData> dataUseCase = [];
  Paging paging = Paging(
    pageNo: 1,
    pageSize: 5,
  );
  Login? login;
  String? searchVal;
  PermittedFunc? permitted;
  FeatureList? premittedAdd;
  FeatureList? premittedView;
  FeatureList? premittedEdit;
  FeatureList? premittedDelete;
  FeatureList? premittedPush;
  bool isSuperAdmin = false;
  bloc(UseCaseEvent event) {
    BlocProvider.of<UseCaseBloc>(context).add(event);
  }

  authBloc(AuthEvent event) {
    BlocProvider.of<AuthBloc>(context).add(event);
  }

  homeBloc(HomeEvent event) {
    BlocProvider.of<HomeBloc>(context).add(event);
  }

  @override
  void initState() {
    searchCat.add(
      KeyVal("Business Process Name", Constant.USE_CASE_NAME),
    );
    searchCat.add(
      KeyVal("Business Process Code", Constant.USE_CASE),
    );
    searchCatSelected = searchCat[0];

    super.initState();
  }

  onSearch() {
    searchCo.clear();
    searchVal = '';
    paging.pageNo = 1;
    searchVal = "";
    modelSearch = ListUseCaseData(statusCd: "");
    bloc(GetUseCaseData(
        useCaseName: modelSearch.useCaseName,
        useCaseCd: modelSearch.useCaseCd,
        statusCd: "",
        paging: paging));
  }

  onView(ListUseCaseData val) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider(
            create: (context) => UseCaseBloc()
              ..add(LoadFormUseCase(
                  useCaseCd: val.useCaseCd, formMode: Constant.viewMode)),
            child: ViewDialogUseCase(
              onEdit: () {
                context.back();
                onEdit(val);
              },
            ),
          );
        });
  }

  onDeleteAction(ListUseCaseData val) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return BlocProvider(
          create: (context) => UseCaseBloc(),
          child: DeleteUseCaseDialog(
            title: "Success",
            useCaseCd: val.useCaseCd!,
            useCaseName: val.useCaseName ?? "",
            onError: (value) {
              UseCaseError(value);
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

  onEdit(ListUseCaseData val) {
    setState(() {
      formMode = Constant.editMode;
    });
    bloc(LoadFormUseCase(useCaseCd: val.useCaseCd, formMode: formMode));
  }

  errorUseCase(String? msg) {
    showTopSnackBar(
        context, UpperSnackBar.error(message: msg ?? "Error occured"));
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
              UseCaseError(state.error);
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
        BlocListener<UseCaseBloc, UseCaseState>(
          listener: (context, state) {
            if (state is DataUseCase) {
              dataUseCase.clear();
              if (state.paging != null) {
                paging = state.paging!;
              }
              dataUseCase.addAll(state.model!);
            }
            if (state is UseCaseError) {
              errorUseCase(state.msg);
            }
            if (state is UseCaseSubmited) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) {
                  return SuccessDialog(
                    title: "Process successfully",
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
              premittedPush = permitted?.featureList?.firstWhere(
                  (e) => e.featureCd == Constant.F_PUSH_BLOCKCHAIN);
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
          BlocProvider(
            create: (context) => ProfileBloc()..add(GetProfileData()),
            child: CustomAppBar(
              menuTitle: "Business Process",
              menuName: "Business Process",
              formMode: formMode,
              onClick: () {
                setState(() {
                  formMode = "";
                });
                onSearch();
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
                    selectedTile: Constant.useCase,
                  ),
                ),
              ),
              Expanded(
                  child: Scrollbar(
                      controller: pointScroll,
                      child: SingleChildScrollView(
                          controller: pointScroll,
                          padding: const EdgeInsets.only(
                              top: 16, left: 25, right: 25),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                BlocBuilder<UseCaseBloc, UseCaseState>(
                                    builder: (context, state) {
                                  if (state is UseCaseForm) {
                                    return Column(
                                      children: [
                                        Visibility(
                                          visible: formMode != Constant.addMode,
                                          child: Row(
                                            children: [
                                              const Text('Last Update On :'),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                state.model?.lastUpdateDt ?? "",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text('-'),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text('Last Update By :'),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                state.model?.lastUpdateBy ?? "",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: isMobile
                                                ? Colors.transparent
                                                : sccBackground,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: isMobile
                                              ? EdgeInsets.zero
                                              : const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                  // horizontal: 24,
                                                ),
                                          child: FormUseCase(
                                            canPushBlock: premittedPush != null,
                                            model: state.model,
                                            listAttr: state.listAttr,
                                            listPoint: state.listPoint,
                                            formMode: formMode,
                                            listTouchPoint: state.listTouch,
                                            onClose: () {
                                              onSearch();
                                              setState(() {
                                                formMode = "";
                                              });
                                            },
                                            onSubmit: (val) {
                                              bloc(SubmitUseCase(
                                                  model: val,
                                                  formMode: formMode,
                                                  useCaseCd: val!.useCaseCd));
                                            },
                                          ),
                                        )
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
                                                  fontSize:
                                                      context.scaleFont(14),
                                                  fontWeight: FontWeight.w400),
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
                                                                searchVal = '';
                                                                paging.pageNo =
                                                                    1;
                                                                onSearch();
                                                              });
                                                            },
                                                            icon:
                                                                const HeroIcon(
                                                              HeroIcons.xCircle,
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
                                                      modelSearch =
                                                          ListUseCaseData(
                                                        useCaseName:
                                                            searchCatSelected
                                                                        .value ==
                                                                    Constant
                                                                        .USE_CASE_NAME
                                                                ? searchVal
                                                                : null,
                                                        useCaseCd:
                                                            searchCatSelected
                                                                        .value ==
                                                                    Constant
                                                                        .USE_CASE
                                                                ? searchVal
                                                                : null,
                                                      );
                                                      paging.pageNo = 1;
                                                      bloc(GetUseCaseData(
                                                          useCaseName:
                                                              modelSearch
                                                                  .useCaseName,
                                                          useCaseCd: modelSearch
                                                              .useCaseCd,
                                                          statusCd: null,
                                                          paging: paging));
                                                    },
                                                    onAction: (value) {
                                                      modelSearch =
                                                          ListUseCaseData(
                                                        useCaseName:
                                                            searchCatSelected
                                                                        .value ==
                                                                    Constant
                                                                        .USE_CASE_NAME
                                                                ? searchVal
                                                                : null,
                                                        useCaseCd:
                                                            searchCatSelected
                                                                        .value ==
                                                                    Constant
                                                                        .USE_CASE
                                                                ? searchVal
                                                                : null,
                                                      );
                                                      paging.pageNo = 1;
                                                      bloc(GetUseCaseData(
                                                          useCaseName:
                                                              modelSearch
                                                                  .useCaseName,
                                                          useCaseCd: modelSearch
                                                              .useCaseCd,
                                                          statusCd: null,
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
                                                Visibility(
                                                  visible: premittedAdd != null,
                                                  child: ButtonConfirmWithIcon(
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
                                                      bloc(LoadFormUseCase(
                                                          formMode: formMode));
                                                    },
                                                    colour: sccNavText2,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        CommonShimmer(
                                          isLoading: state is UseCaseLoading,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isMobile
                                                  ? Colors.transparent
                                                  : sccWhite,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
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
                                                        'Business Process',
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
                                                          if (paging.pageSize !=
                                                              val) {
                                                            setState(() {
                                                              paging.pageSize =
                                                                  val;
                                                            });
                                                            paging.pageNo =
                                                                paging.pageNo! -
                                                                    1;
                                                            paging.pageNo = 1;
                                                            bloc(GetUseCaseData(
                                                              useCaseName:
                                                                  modelSearch
                                                                      .useCaseName,
                                                              useCaseCd:
                                                                  modelSearch
                                                                      .useCaseCd,
                                                              statusCd: "",
                                                              paging: paging,
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
                                                MasterUseCaseTable(
                                                  listModel: dataUseCase,
                                                  onDelete: (val) {
                                                    onDeleteAction(val);
                                                  },
                                                  onEdit: (val) {
                                                    onEdit(val);
                                                  },
                                                  onView: (val) {
                                                    onView(val);
                                                  },
                                                  canDelete:
                                                      premittedDelete != null,
                                                  canView: true,
                                                  canUpdate:
                                                      premittedEdit != null,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Visibility(
                                          visible: !isMobile &&
                                              paging.totalPages != null &&
                                              paging.totalData != null &&
                                              dataUseCase.isNotEmpty,
                                          child: CommonShimmer(
                                            isLoading: state is UseCaseLoading,
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
                                                    bloc(GetUseCaseData(
                                                      useCaseName: modelSearch
                                                          .useCaseName,
                                                      useCaseCd:
                                                          modelSearch.useCaseCd,
                                                      statusCd: "",
                                                      paging: paging,
                                                    ));
                                                  },
                                                  onClickFirstPage: () {
                                                    paging.pageNo = 1;
                                                    bloc(GetUseCaseData(
                                                      useCaseName: modelSearch
                                                          .useCaseName,
                                                      useCaseCd:
                                                          modelSearch.useCaseCd,
                                                      statusCd: "",
                                                      paging: paging,
                                                    ));
                                                  },
                                                  onClickPrevious: () {
                                                    paging.pageNo =
                                                        paging.pageNo! - 1;
                                                    bloc(GetUseCaseData(
                                                      useCaseName: modelSearch
                                                          .useCaseName,
                                                      useCaseCd:
                                                          modelSearch.useCaseCd,
                                                      statusCd: "",
                                                      paging: paging,
                                                    ));
                                                  },
                                                  onClickNext: () {
                                                    paging.pageNo =
                                                        paging.pageNo! + 1;
                                                    bloc(GetUseCaseData(
                                                      useCaseName: modelSearch
                                                          .useCaseName,
                                                      useCaseCd:
                                                          modelSearch.useCaseCd,
                                                      statusCd: "",
                                                      paging: paging,
                                                    ));
                                                  },
                                                  onClickLastPage: () {
                                                    paging.pageNo =
                                                        paging.totalPages;
                                                    bloc(GetUseCaseData(
                                                      useCaseName: modelSearch
                                                          .useCaseName,
                                                      useCaseCd:
                                                          modelSearch.useCaseCd,
                                                      statusCd: "",
                                                      paging: paging,
                                                    ));
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                })
                              ]))))
            ],
          )),
        ],
      ),
    );
  }
}
