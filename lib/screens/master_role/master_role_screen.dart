// ignore_for_file: library_private_types_in_public_api

import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';

import 'package:scc_web/bloc/new_edit_role/bloc/new_edit_role_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/model/new_edit_role.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permittedFuncfeat.dart';
import 'package:scc_web/screens/master_role/delete_dialog.dart';
import 'package:scc_web/screens/master_role/master_role_table.dart';
import 'package:scc_web/screens/master_role/master_role_form.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

class MasterRoleScreen extends StatefulWidget {
  const MasterRoleScreen({Key? key}) : super(key: key);

  @override
  _MasterRoleScreenState createState() => _MasterRoleScreenState();
}

class _MasterRoleScreenState extends State<MasterRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sccBackground,
      drawerEnableOpenDragGesture: false,
      appBar: isMobile
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: MultiBlocProvider(
                providers: [
                  // BlocProvider(
                  //   create: (context) => ProfileBloc()..add(GetProfileData()),
                  // ),
                  BlocProvider(
                    create: (context) => AuthBloc(),
                  ),
                ],
                child: const CustomAppBar(),
              ),
            )
          : null,
      drawer: MultiBlocProvider(
        providers: [
          // BlocProvider(
          //   create: (context) => HomeBloc()..add(GetMenu()),
          // ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
        ],
        child: const PersistDrawer(
          initiallyExpanded: true,
          selectedTile: Constant.ROLE,
        ),
      ),
      body: SafeArea(
        child: MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) => NewEditRoleBloc()
              ..add(InitNewEditRole(
                  paging: Paging(pageNo: 1, pageSize: 5),
                  roleName: "")), //..add(GetTransactionData()),
          ),
          // BlocProvider(
          //   create: (context) => PermittedFFBloc()..add(GetPermitted(Constant.ROLE)),
          // ),
        ], child: const MasterRoleBody()),
      ),
    );
  }
}

class MasterRoleBody extends StatefulWidget {
  const MasterRoleBody({Key? key}) : super(key: key);

  @override
  _MasterRoleBodyState createState() => _MasterRoleBodyState();
}

class _MasterRoleBodyState extends State<MasterRoleBody> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isLoading = false;

  late TextEditingController searchCo;
  // late TextEditingController companyCo;

  Paging paging = Paging(pageNo: 1, pageSize: 5);
  Login? login;
  ListDataNewEditRole modelSearch = ListDataNewEditRole();

  List<KeyVal> searchCat = [];
  List<KeyVal> searchCompany = [];
  List<ListDataNewEditRole> searchList = [];
  List<KeyVal> listMenuDrpdwn = [];
  List<Menu> listMenu = [];

  late KeyVal companySelected;
  late KeyVal searchCatSelected;
  String formMode = "";
  String? searchVal;

  // PermittedFunc? permitted;

  FeatureList? premittedAdd;
  FeatureList? premittedView;
  FeatureList? premittedEdit;
  FeatureList? premittedDelete;
  bool isSuperAdmin = false;
  bool expandNavBar = true;
  bool showNavBar = true;
  bool toForm = false;
  // FunctionList? functionSearch;
  // FunctionList? functionCreate;
  // FunctionList? functionGet;
  // FunctionList? functionUpdate;
  // FunctionList? functionDelete;

  @override
  void initState() {
    searchCo = TextEditingController();

    super.initState();
  }

  bloc(NewEditRoleEvent event) {
    BlocProvider.of<NewEditRoleBloc>(context).add(event);
  }

  homeBloc(HomeEvent event) {
    BlocProvider.of<HomeBloc>(context).add(event);
  }

  authBloc(AuthEvent event) {
    BlocProvider.of<AuthBloc>(context).add(event);
  }

  final dashboardScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    // roleBloc(NewEditRoleEvent event) {
    //   BlocProvider.of<NewEditRoleBloc>(context).add(event);
    // }

    editRoleError(String? msg) {
      showTopSnackBar(
          context, UpperSnackBar.error(message: msg ?? "Error occured"));
    }

    onEditAction(ListDataNewEditRole value) {
      setState(() {
        formMode = Constant.editMode;
      });
      bloc(ToNewEditRoleForm(roleCd: value.roleCd));
    }

    onViewAction(ListDataNewEditRole value) {
      setState(() {
        formMode = Constant.viewMode;
      });
      bloc(ToNewEditRoleForm(roleCd: value.roleCd));
    }

    onSearch() {
      setState(() {
        formMode = "";
      });
      searchCo.clear();
      searchVal = '';
      paging.pageNo = 1;
      modelSearch = ListDataNewEditRole(roleName: "");
      bloc(InitNewEditRole(paging: paging, roleName: modelSearch.roleName));
    }

    onDeleteAction(ListDataNewEditRole value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return BlocProvider(
            create: (context) => NewEditRoleBloc(),
            child: NewEditDeleteDialog(
              title: "Success",
              roleCd: value.roleCd ?? "",
              roleName: value.roleName ?? "[undefined role name]",
              onError: (value) {
                editRoleError(value);
                formMode = "";
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
          searchVal = '';
          paging.pageNo = 1;
          modelSearch = ListDataNewEditRole(roleName: "");
          bloc(InitNewEditRole(paging: paging, roleName: modelSearch.roleName));
        }
      });
    }

    return Column(
      children: [
        Visibility(
          visible: !isMobile,
          child: MultiBlocProvider(
            providers: [
              // BlocProvider(
              //   create: (context) => ProfileBloc()
              //     ..add(GetProfileData(
              //       loadMenu: true,
              //     )),
              // ),
              BlocProvider(
                create: (context) => AuthBloc(),
              ),
              BlocProvider(
                create: (context) => HomeBloc(),
              ),
              BlocProvider(
                  create: (context) => ProfileBloc()..add(GetProfileData())),
            ],
            child: CustomAppBar(
              menuTitle: "User Role",
              menuName: "Master User Role",
              childMenu: "Role",
              formMode: formMode,
              onClickChild: () {
                setState(() {
                  formMode = "";
                });
                onSearch();
              },
              onClick: () {
                // onSearch("");
                setState(() {
                  formMode = "";
                });
                context.push(const MasterUserRoleRoute());
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
                    selectedTile: Constant.ROLE,
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
                    BlocListener<HomeBloc, HomeState>(
                      listener: (context, state) {
                        if (state is HomeError) {
                          editRoleError(state.error);
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
                    BlocListener<NewEditRoleBloc, NewEditRoleState>(
                      listener: (context, state) {
                        if (state is EditRoleError) {
                          editRoleError(state.msg);
                          formMode = "";
                          onSearch();
                        }
                        if (state is ListRoleLoaded) {
                          if (state.paging != null) {
                            paging = state.paging!;
                          }
                          searchList.clear();
                          searchList.addAll(state.listData);
                        }

                        if (state is NewEditRoleLoading) {
                          isLoading = true;
                        } else {
                          isLoading = false;
                          // editRoleError(state.msg);
                        }
                        if (state is NewEditRoleSubmitted) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) {
                              return SuccessDialog(
                                title: "Success",
                                msg: state.msg,
                                buttonText: "OK",
                                onTap: () => context.back(),
                              );
                            },
                          ).then((value) {
                            searchCo.clear();
                            searchVal = '';
                            paging.pageNo = 1;
                            searchVal = "";
                            setState(() {
                              formMode = "";
                            });
                            modelSearch = ListDataNewEditRole(roleName: "");
                            onSearch();
                          });
                        }
                        if (state is OnLogoutNewEditRole) {
                          authBloc(AuthLogin());
                        }
                        if (state is DataRoleEditLoaded) {
                          toForm = !toForm;
                          listMenuDrpdwn.clear();
                          for (var e in state.listMenu) {
                            listMenuDrpdwn
                                .add(KeyVal(e.menuName ?? "", e.menuCd ?? ""));
                          }
                        }
                      },
                    ),
                    // BlocListener<PermittedFFBloc, PermittedFFState>(
                    //   listener: (context, state) {
                    //     if (state is PermittedFFSuccess) {
                    //       permitted = state.model;
                    //       // // debugprint(permitted.toString());

                    //       premittedAdd = permitted?.featureList
                    //           ?.firstWhereOrNull((element) =>
                    //               element.featureCd == Constant.F_ADD);
                    //       premittedEdit = permitted?.featureList
                    //           ?.firstWhereOrNull((element) =>
                    //               element.featureCd == Constant.F_EDIT);
                    //       premittedDelete = permitted?.featureList
                    //           ?.firstWhereOrNull((element) =>
                    //               element.featureCd == Constant.F_DELETE);
                    //       isSuperAdmin = permitted?.superAdmin ?? false;
                    //       // !
                    //       // functionSearch = premittedSearch?.functionList?.firstWhereOrNull((element) => element.functionCd == Constant.FUNC_POINT);
                    //       // functionCreate = premittedAdd?.functionList?.firstWhereOrNull((element) => element.functionCd == Constant.FUNC_POINT);
                    //       // functionGet = premittedView?.functionList?.firstWhereOrNull((element) => element.functionCd == Constant.FUNC_POINT);
                    //       // functionUpdate = premittedEdit?.functionList?.firstWhereOrNull((element) => element.functionCd == Constant.FUNC_POINT);
                    //       // functionDelete = premittedDelete?.functionList?.firstWhereOrNull((element) => element.functionCd == Constant.FUNC_POINT);
                    //       // // debugprint((permitted ?? PermittedFuncFeat()).toMap().toString());
                    //       bloc(InitNewEditRole(
                    //           paging: Paging(pageNo: 1, pageSize: 5)));
                    //     }
                    //     if (state is PermittedFFError) {
                    //       showTopSnackBar(context,
                    //           UpperSnackBar.success(message: state.errMsg));
                    //     }
                    //     if (state is OnLogoutPermittedFF) {
                    //       authBloc(AuthLogin());
                    //     }
                    //   },
                    // ),
                  ],
                  child: Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          controller: dashboardScroll,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(
                                top: 16, left: 25, right: 25),
                            controller: dashboardScroll,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BlocBuilder<NewEditRoleBloc, NewEditRoleState>(
                                  builder: (context, state) {
                                    if (state is DataRoleEditLoaded) {
                                      return Column(
                                        children: [
                                          // BackLabel(
                                          //   onTap: () {
                                          //     paging.pageNo = 1;
                                          //     searchVal = "";
                                          //     roleBloc(
                                          //       InitNewEditRole(roleName: searchVal, paging: paging),
                                          //     );
                                          //   },
                                          // ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: isMobile
                                                  ? Colors.transparent
                                                  : sccWhite,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: isMobile
                                                ? EdgeInsets.zero
                                                : const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    // horizontal: 24,
                                                  ),
                                            child: MasterRoleForm(
                                                model: state.model,
                                                listMenuDrpdwnForm:
                                                    listMenuDrpdwn,
                                                formMode: formMode,
                                                onClose: () {
                                                  searchCo.clear();
                                                  searchVal = '';
                                                  setState(() {
                                                    formMode = "";
                                                  });
                                                  modelSearch =
                                                      ListDataNewEditRole(
                                                          roleName: "");
                                                  bloc(InitNewEditRole(
                                                      paging: paging));
                                                },
                                                onSubmit: (value) {
                                                  bloc(SubmitNewEditRole(
                                                    value,
                                                    formMode,
                                                  ));
                                                }),
                                            //Container(), // isi form
                                          ),
                                        ],
                                      );
                                    } //
                                    else {
                                      return Column(
                                        children: [
                                          // BackLabel(
                                          //   onTap: () {
                                          //     context.push(MstRoleRoute());
                                          //   },
                                          // ),
                                          // SizedBox(
                                          //   height: 12,
                                          // ),
                                          // SizedBox(height: 12),
                                          SizedBox(
                                            height: 48,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: context.deviceWidth() *
                                                      0.25,
                                                  child: PlainSearchField(
                                                    controller: searchCo,
                                                    hint: "Search Role Name",
                                                    borderRadius: 12,
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
                                                                    searchCo
                                                                        .text;
                                                                paging.pageNo =
                                                                    1;
                                                                bloc(InitNewEditRole(
                                                                    roleName:
                                                                        searchVal,
                                                                    paging:
                                                                        paging));
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
                                                          ListDataNewEditRole(
                                                        roleName: searchVal,
                                                      );
                                                      paging.pageNo = 1;
                                                      bloc(InitNewEditRole(
                                                          roleName: modelSearch
                                                              .roleName,
                                                          paging: paging));
                                                    },
                                                    onAction: (value) {
                                                      modelSearch =
                                                          ListDataNewEditRole(
                                                        roleName: searchVal,
                                                      );
                                                      paging.pageNo = 1;
                                                      bloc(InitNewEditRole(
                                                          roleName: modelSearch
                                                              .roleName,
                                                          paging: paging));
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: context.deviceWidth() *
                                                      (context.isDesktop()
                                                          ? 0.14
                                                          : 0.38),
                                                  child: ButtonConfirmWithIcon(
                                                    icon: HeroIcon(
                                                      HeroIcons.plus,
                                                      color: sccWhite,
                                                      size:
                                                          context.scaleFont(18),
                                                    ),
                                                    text: "Add New",
                                                    colour: sccNavText2,
                                                    onTap: () {
                                                      setState(() {
                                                        formMode =
                                                            Constant.addMode;
                                                      });
                                                      bloc(ToNewEditRoleForm());
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          CommonShimmer(
                                            isLoading: isLoading,
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
                                                          'Role',
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
                                                              bloc(InitNewEditRole(
                                                                  roleName:
                                                                      modelSearch
                                                                          .roleName,
                                                                  paging:
                                                                      paging));
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  MasterRoleTable(
                                                    canDelete:
                                                        // premittedDelete !=
                                                        //         null ||
                                                        //     isSuperAdmin,
                                                        true,
                                                    canView: true,
                                                    canUpdate:
                                                        // premittedEdit != null ||
                                                        //     isSuperAdmin,
                                                        true,
                                                    listModel: searchList,
                                                    onDelete: (value) =>
                                                        onDeleteAction(value),
                                                    onView: (value) =>
                                                        onViewAction(value),
                                                    onEdit: (value) =>
                                                        onEditAction(value),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                BlocBuilder<NewEditRoleBloc, NewEditRoleState>(
                                  builder: (context, state) {
                                    return Visibility(
                                      visible: !isMobile &&
                                          paging.totalPages != null &&
                                          paging.totalData != null &&
                                          state is ListRoleLoaded,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SimplePaging(
                                            pageNo: paging.pageNo!,
                                            pageToDisplay: isMobile ? 3 : 5,
                                            totalPages: paging.totalPages,
                                            pageSize: paging.pageSize,
                                            totalDataInPage:
                                                paging.totalDataInPage,
                                            totalData: paging.totalData,
                                            onClick: (value) {
                                              paging.pageNo = value;
                                              bloc(
                                                InitNewEditRole(
                                                    roleName: searchVal,
                                                    paging: paging),
                                              );
                                            },
                                            onClickFirstPage: () {
                                              paging.pageNo = 1;
                                              bloc(
                                                InitNewEditRole(
                                                    roleName: searchVal,
                                                    paging: paging),
                                              );
                                            },
                                            onClickPrevious: () {
                                              paging.pageNo =
                                                  paging.pageNo! - 1;
                                              bloc(
                                                InitNewEditRole(
                                                    roleName: searchVal,
                                                    paging: paging),
                                              );
                                            },
                                            onClickNext: () {
                                              paging.pageNo =
                                                  paging.pageNo! + 1;
                                              bloc(
                                                InitNewEditRole(
                                                    roleName: searchVal,
                                                    paging: paging),
                                              );
                                            },
                                            onClickLastPage: () {
                                              paging.pageNo = paging.totalPages;
                                              bloc(
                                                InitNewEditRole(
                                                    roleName: searchVal,
                                                    paging: paging),
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
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
      ],
    );
  }
}
