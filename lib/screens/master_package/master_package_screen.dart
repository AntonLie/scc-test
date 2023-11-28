// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/master_package/bloc/master_package_bloc.dart';
import 'package:scc_web/bloc/permitted_feat/bloc/permitted_feat_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';

import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permitted_func_feat.dart';
import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/model/point.dart';
import 'package:scc_web/screens/master_package/package_form.dart';
import 'package:scc_web/screens/master_package/package_table.dart';
import 'package:scc_web/screens/master_package/pkg_dialog_msg.dart';
import 'package:scc_web/screens/master_package/view_dialog_package.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/success_dialog.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/colors.dart';

import '../../helper/constant.dart';

class MasterPackageScreen extends StatefulWidget {
  const MasterPackageScreen({super.key});

  @override
  State<MasterPackageScreen> createState() => _MasterPackageScreenState();
}

class _MasterPackageScreenState extends State<MasterPackageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile
          ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AuthBloc(),
                  ),
                ],
                child: Container(),
              ),
            )
          : null,
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(),
            ),
            BlocProvider(
              create: (context) => HomeBloc(),
            ),
            BlocProvider(
              create: (context) => MasterPackageBloc(),
            ),
            BlocProvider(
              create: (context) => PermittedFeatBloc()
                ..add(
                  GetPermitted(Constant.package),
                ),
            )
          ],
          child: MasterPackageBody(),
        ),
      ),
      backgroundColor: sccBackground,
    );
  }
}

class MasterPackageBody extends StatefulWidget {
  const MasterPackageBody({super.key});

  @override
  State<MasterPackageBody> createState() => _MasterPackageBodyState();
}

class _MasterPackageBodyState extends State<MasterPackageBody> {
  PackageData modelForm = PackageData();
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  bool expandNavBar = true;
  bool showNavBar = true;
  bool shwBtnBack = false;
  Login? login;
  PermittedFunc? permitted;
  FeatureList? premittedAdd;
  FeatureList? premittedView;
  FeatureList? premittedEdit;
  FeatureList? premittedDelete;
  bool isSuperAdmin = false;

  String formMode = "";
  String? searchVal;

  List<ListDataNewPoint> model = [];
  late List<PackageList> dataTbl;
  String? companySelected;
  String packageName = '';

  TextEditingController searchCo = TextEditingController();
  List<Menu> listMenu = [];
  final dashScrContrl = ScrollController();

  authBloc(AuthEvent event) {
    BlocProvider.of<AuthBloc>(context).add(event);
  }

  homeBloc(HomeEvent event) {
    BlocProvider.of<HomeBloc>(context).add(event);
  }

  bloc(MasterPackageEvent event) {
    BlocProvider.of<MasterPackageBloc>(context).add(event);
  }

  @override
  void initState() {
    dataTbl = [];
    companySelected = '';
    bloc(GetPackageData(
      pkgNm: "",
      paging: paging,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    packageFailed(String? msg) {
      showTopSnackBar(
          context, UpperSnackBar.error(message: msg ?? "Error occured"));
    }

    onSearch() {
      paging.pageNo = 1;
      bloc(GetPackageData(
        pkgNm: searchVal ?? "",
        paging: paging,
      ));
    }

    onEditAction(PackageList value) {
      setState(() {
        formMode = Constant.editMode;
      });
      bloc(ToPackageForm(
        pkgCd: int.parse(value.packageCd!),
      ));
    }

    onViewAction(PackageList value) {
      showDialog(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (context) => MasterPackageBloc()
                ..add(
                  ToPackageForm(pkgCd: int.parse(value.packageCd!)),
                ),
              child: ViewDialogPackage(
                  edit: premittedEdit != null,
                  onEdit: () {
                    context.back();
                    onEditAction(value);
                  }),
            );
          });
      // setState(() {
      //   formMode = Constant.viewMode;
      // });
      // bloc(ToPackageForm(
      //   pkgCd: int.parse(value.packageCd!),
      // ));
    }

    onDeleteAction(PackageList value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return BlocProvider(
            create: (context) => MasterPackageBloc(),
            child: DeletePackageListDialog(
              title: "Success",
              pkgCd: int.parse(value.packageCd!),
              pkgNm: value.packageName ?? "",
              onError: (value) {
                packageFailed(value);
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

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedOut) {
              context.push(LoginRoute());
              // locator<NavigatorService>()
              //     .navigateReplaceTo(Constant.MENU_LOGIN);
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              PackageError(state.error);
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
        BlocListener<MasterPackageBloc, MasterPackageState>(
          listener: (context, state) {
            if (state is PackageDataLoaded) {
              // formMode = Constant.tableMode;
              dataTbl.clear();
              if (state.paging != null) {
                paging = state.paging!;
              }
              if (state.data != null) {
                dataTbl = state.data!;
              } else {
                dataTbl = [];
              }
            }
            if (state is PackageFormLoaded) {
              if (state.msg != null) {
                showTopSnackBar(context,
                    UpperSnackBar.error(message: state.msg ?? "Error occured"));
              }
            }

            if (state is PackageDataSubmited) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) {
                  return SuccessDialog(
                    title: "Master Package process successfully",
                    msg: state.msg,
                    buttonText: "OK",
                    onTap: () => context.back(),
                  );
                },
              ).then((value) {
                searchCo.clear();
                paging.pageNo = 1;
                onSearch();
                setState(() {
                  formMode = "";
                });
              });
            }
            if (state is PackageError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.error));
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
              menuTitle: "Package",
              menuName: "Master Package",
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
          Visibility(
            visible: !isMobile,
            child: MultiBlocProvider(providers: [
              BlocProvider(
                create: (context) => AuthBloc(),
              ),
              BlocProvider(
                create: (context) => HomeBloc(),
              ),
            ], child: Container()),
          ),
          Expanded(
            child: Row(
              children: [
                ExpandableWidget(
                  expand: context.isDesktop() &&
                      (!isFullscreen(context) || showNavBar),
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
                      selectedTile: Constant.package,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: Scrollbar(
                              thumbVisibility: true,
                              controller: dashScrContrl,
                              child: SingleChildScrollView(
                                  controller: dashScrContrl,
                                  padding: const EdgeInsets.only(
                                      top: 16, left: 25, right: 25),
                                  child: BlocBuilder<MasterPackageBloc,
                                          MasterPackageState>(
                                      builder: (context, state) {
                                    if (state is PackageFormLoaded) {
                                      return Column(
                                        children: [
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
                                                : EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    // horizontal: 24,
                                                  ),
                                            child: PackageFormBody(
                                              formMode: formMode,
                                              colorOpt: state.listColor,
                                              model: state.model,
                                              listBlock: state.listBlock,
                                              onClose: () {
                                                searchVal = '';
                                                onSearch();
                                                setState(() {
                                                  formMode = "";
                                                });
                                              },
                                              onSubmit: (value) {
                                                bloc(SubmitPackageForm(
                                                    value, formMode));
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Gap(20),
                                            SizedBox(
                                              height: 48,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 280,
                                                        child: PlainSearchField(
                                                          controller: searchCo,
                                                          hint:
                                                              "Search Package Name",
                                                          prefix: searchCo.text
                                                                  .isNotEmpty
                                                              ? IconButton(
                                                                  hoverColor: Colors
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
                                                                      onSearch();
                                                                    });
                                                                  },
                                                                  icon:
                                                                      HeroIcon(
                                                                    HeroIcons
                                                                        .xCircle,
                                                                    color:
                                                                        sccText4,
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
                                                            onSearch();
                                                          },
                                                          onAction: (value) {
                                                            onSearch();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  (premittedAdd != null ||
                                                          isSuperAdmin)
                                                      ? SizedBox(
                                                          width: context
                                                                  .deviceWidth() *
                                                              (context.isDesktop()
                                                                  ? 0.14
                                                                  : 0.38),
                                                          height: 48,
                                                          child:
                                                              ButtonConfirmWithIcon(
                                                            icon: HeroIcon(
                                                              HeroIcons.plus,
                                                              color: sccWhite,
                                                              size: context
                                                                  .scaleFont(
                                                                      14),
                                                            ),
                                                             borderRadius: 12,
                                                            text: "Add New",
                                                            onTap: () {
                                                              setState(() {
                                                                formMode =
                                                                    Constant
                                                                        .addMode;
                                                              });

                                                              bloc(
                                                                  ToPackageForm());
                                                            },
                                                            colour: sccNavText2,
                                                          ),
                                                        )
                                                      : Expanded(
                                                          child: SizedBox(
                                                            width: context
                                                                    .deviceWidth() *
                                                                0.1,
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 24,
                                            ),
                                            BlocBuilder<MasterPackageBloc,
                                                MasterPackageState>(
                                              builder: (context, state) {
                                                return Column(
                                                  children: [
                                                    CommonShimmer(
                                                      isLoading: state
                                                          is PackageLoading,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.2),
                                                              spreadRadius: 1,
                                                              blurRadius: 2,
                                                              offset:
                                                                  Offset(0, 1),
                                                            ),
                                                          ],
                                                          color: isMobile
                                                              ? Colors
                                                                  .transparent
                                                              : sccWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        constraints:
                                                            BoxConstraints(
                                                          // For testing only
                                                          minHeight: context
                                                                  .deviceHeight() *
                                                              0.2,
                                                          minWidth: context
                                                              .deviceWidth(),
                                                        ),
                                                        padding: isMobile
                                                            ? EdgeInsets.zero
                                                            : EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 16,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Packages',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          context
                                                                              .scaleFont(18),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          0xff2B2B2B),
                                                                    ),
                                                                  ),
                                                                  PagingDropdown(
                                                                    selected: (paging.pageSize ??
                                                                            0)
                                                                        .toString(),
                                                                    onSelect:
                                                                        (val) {
                                                                      if (paging
                                                                              .pageSize !=
                                                                          val) {
                                                                        setState(
                                                                            () {
                                                                          paging.pageSize =
                                                                              val;
                                                                        });
                                                                        paging.pageNo =
                                                                            paging.pageNo! -
                                                                                1;
                                                                        onSearch();
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 12,
                                                            ),
                                                            PackageTable(
                                                              canView: true,
                                                              canUpdate:
                                                                  premittedEdit !=
                                                                      null,
                                                              canDelete:
                                                                  premittedDelete !=
                                                                      null,
                                                              listModel:
                                                                  dataTbl,
                                                              onDelete: (value) =>
                                                                  onDeleteAction(
                                                                      value),
                                                              onView: (value) =>
                                                                  onViewAction(
                                                                      value),
                                                              onEdit: (value) =>
                                                                  onEditAction(
                                                                      value),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            BlocBuilder<MasterPackageBloc,
                                                MasterPackageState>(
                                              builder: (context, state) {
                                                return Visibility(
                                                  visible: !isMobile &&
                                                      paging.totalPages !=
                                                          null &&
                                                      paging.totalData !=
                                                          null &&
                                                      state
                                                          is PackageDataLoaded,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SimplePaging(
                                                        pageNo: paging.pageNo!,
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
                                                          paging.pageNo = value;
                                                          bloc(GetPackageData(
                                                            pkgNm:
                                                                searchVal ?? "",
                                                            paging: paging,
                                                          ));
                                                        },
                                                        onClickFirstPage: () {
                                                          paging.pageNo = 1;
                                                          bloc(GetPackageData(
                                                            pkgNm:
                                                                searchVal ?? "",
                                                            paging: paging,
                                                          ));
                                                        },
                                                        onClickPrevious: () {
                                                          paging.pageNo =
                                                              paging.pageNo! -
                                                                  1;
                                                          bloc(GetPackageData(
                                                            pkgNm:
                                                                searchVal ?? "",
                                                            paging: paging,
                                                          ));
                                                        },
                                                        onClickNext: () {
                                                          paging.pageNo =
                                                              paging.pageNo! +
                                                                  1;
                                                          bloc(GetPackageData(
                                                            pkgNm:
                                                                searchVal ?? "",
                                                            paging: paging,
                                                          ));
                                                        },
                                                        onClickLastPage: () {
                                                          paging.pageNo =
                                                              paging.totalPages;
                                                          bloc(GetPackageData(
                                                            pkgNm:
                                                                searchVal ?? "",
                                                            paging: paging,
                                                          ));
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 24,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ]);
                                    }
                                  }))))
                    ],
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
