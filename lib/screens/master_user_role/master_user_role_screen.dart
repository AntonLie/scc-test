import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/mst_usr_role/bloc/mst_usr_role_bloc.dart';
import 'package:scc_web/bloc/package/bloc/package_bloc.dart';
import 'package:scc_web/bloc/permitted_feat/bloc/permitted_feat_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permitted_func_feat.dart';

import 'package:scc_web/model/user_role.dart';
import 'package:scc_web/screens/master_user_role/list_master_role.dart';
import 'package:scc_web/screens/master_user_role/list_role_mobile.dart';
import 'package:scc_web/screens/master_user_role/delete_role_dialog.dart';
import 'package:scc_web/screens/master_user_role/search_role_bottom_sheet.dart';
import 'package:scc_web/screens/master_user_role/user_role_form.dart';
import 'package:scc_web/screens/master_user_role/view_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/success_dialog.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/padding.dart';

import '../../theme/colors.dart';

class MasterUserRoleScreen extends StatefulWidget {
  const MasterUserRoleScreen({super.key});

  @override
  State<MasterUserRoleScreen> createState() => _MasterUserRoleScreenState();
}

class _MasterUserRoleScreenState extends State<MasterUserRoleScreen> {
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
                child: Container(),
                // child: CustomAppBar(),
              ),
            )
          : null,
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
          selectedTile: Constant.MST_USER_ROLE,
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
              create: (context) => PackageBloc(),
            ),
            BlocProvider(
                create: (context) => MstUsrRoleBloc()
                  ..add(SearchMasterRole(
                      paging: Paging(pageNo: 1, pageSize: 5),
                      model: MasterRole()))),
            BlocProvider(
              create: (context) => PermittedFeatBloc()
                ..add(
                  GetPermitted(Constant.MST_USER_ROLE),
                ),
            )
          ],
          child: const MasterUserRoleBody(),
        ),
      ),
    );
  }
}

class MasterUserRoleBody extends StatefulWidget {
  const MasterUserRoleBody({super.key});

  @override
  State<MasterUserRoleBody> createState() => _MasterUserRoleBodyState();
}

class _MasterUserRoleBodyState extends State<MasterUserRoleBody> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final dashboardScroll = ScrollController();
  TextEditingController searchCo = TextEditingController();
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  MasterRole model = MasterRole(username: '', email: '');
  bool isLoading = false;
  KeyVal? categorySelected;
  KeyVal roleSelected = KeyVal("All", "");
  KeyVal? brandSelected;
  Login? login;
  List<KeyVal> category = [];
  List<KeyVal> role = [];

  List<MasterRole> searchList = [];
  List<Menu> listMenu = [];
  String searchVal = "";
  String formMode = "";
  List<String> listBrand = [];
  List<DataCompany> listCompany = [];
  List<DataDivision> listDivision = [];
  List<DataDivision> listPhoneCd = [];
  List<KeyVal> selectedItems = [];

  PermittedFunc? permitted;
  FeatureList? premittedAdd;
  FeatureList? premittedView;
  FeatureList? premittedEdit;
  FeatureList? premittedDelete;
  bool isSuperAdmin = false;
  bool expandNavBar = true;
  bool showNavBar = true;
  bool shwBtnBack = false;
  bool buttonSett = false;

  @override
  void initState() {
    category.add(
      KeyVal("Username", Constant.username),
    );
    category.add(
      KeyVal("E-mail", Constant.email),
    );
    categorySelected = category[0];
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

    bloc(MstUsrRoleEvent event) {
      BlocProvider.of<MstUsrRoleBloc>(context).add(event);
    }

    userRoleError(String? msg) {
      showTopSnackBar(
          context, UpperSnackBar.error(message: msg ?? "Error occured"));
    }

    onSearch(String? value) {
      model = MasterRole(
        email: categorySelected?.value == Constant.email
            ? (value ?? "").trim()
            : null,
        username: categorySelected?.value == Constant.username
            ? (value ?? "").trim()
            : null,
        roleCd: roleSelected.value,
      );
      paging.pageNo = 1;
      bloc(SearchMasterRole(
        model: model,
        paging: paging,
        // method: functionSearch?.method ?? Constant.GET,
        // url: functionSearch?.url ?? "",
      ));
    }

    onDelete(MasterRole value) {
      showDialog(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (context) => MstUsrRoleBloc(),
              child: DeleteMasterRoleDialog(
                // email: value.email ?? "",
                validFrom: value.validFromDt ?? "",
                username: value.username ?? "[undefined Role]",
                // method: functionDelete?.method ?? Constant.DELETE,
                // url: functionDelete?.url ?? "",
                onError: (value) {
                  userRoleError(value);
                },
                onLogout: () {
                  authBloc(AuthLogin());
                },
              ),
            );
          }).then((val) {
        if (val != null && val is bool && val) {
          context.back();
          searchVal = '';
          searchCo.clear();
          onSearch(searchVal);
        }
      });
    }

    onEdit(MasterRole value) {
      setState(() {
        formMode = Constant.editMode;
      });

      bloc(ToMasterRoleForm(
          // method: functionGet?.method ?? Constant.GET, url: functionGet?.url ?? "",
          model: value));
    }

    onView(MasterRole value) {
      showDialog(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (context) =>
                  MstUsrRoleBloc()..add(ToMasterRoleForm(model: value)),
              child: ViewDialogUserRole(
                onEdit: () {
                  context.back();
                  onEdit(value);
                },
              ),
            );
          });
    }

    var customAppBar = CustomAppBar(
      menuTitle: "User Role",
      menuName: "Master User Role",
      formMode: formMode,
      onClick: () {
        onSearch("");
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
    );
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
            if (state is HomeError) {
              userRoleError(state.error);
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
        BlocListener<MstUsrRoleBloc, MstUsrRoleState>(
          listener: (context, state) {
            if (state is MasterRoleError) {
              userRoleError(state.msg);
            }
            if (state is MasterRoleLoading) {
              isLoading = true;
            } else {
              isLoading = false;
            }
            if (state is OnLogoutMasterRole) {
              authBloc(AuthLogin());
            }
            if (state is SearchMasterRoleSuccess) {
              role.clear();
              role.add(KeyVal("All", ""));
              for (var element in state.listMasterRole) {
                if (element.roleCd != null) {
                  role.add(KeyVal(element.roleName ?? "UNKNOWN ROLE",
                      element.roleCd ?? ""));
                }
              }

              searchList.clear();
              state.listUserRole.forEach((element) {
                searchList = element.userList!;
                buttonSett = element.buttonSetting!;
              });

              if (state.paging != null) {
                // setState(() {
                paging = state.paging!;
                // });
              }
              dashboardScroll.jumpTo(0);
            }
            if (state is LoadShape) {
              shwBtnBack = !shwBtnBack;
              listBrand.clear();
              listCompany.clear();
              listDivision.clear();
              listCompany.addAll(state.listCompany);
              listDivision.addAll(state.listDivision);
              listBrand.addAll(state.listBrand);
            }
            if (state is MasterRoleSubmitted) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) {
                  return SuccessDialog(
                    title: "Master User Role process successfully",
                    msg: state.msg,
                    buttonText: "OK",
                    onTap: () => context.back(),
                  );
                },
              ).then((value) {
                paging.pageNo = 1;
                searchVal = '';
                setState(() {
                  formMode = "";
                });
                onSearch(searchVal);
              });

              // widget.onSuccess();
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
              child: customAppBar,
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
                      selectedTile: Constant.MST_USER_ROLE,
                    ),
                    // child: PersistDrawer(
                    //   initiallyExpanded: expandNavBar,
                    //   selectedTile: Constant.ROLE,
                    //   onMenuLoaded: (val) {
                    //     listMenu = List.from(val);
                    //   },
                    // ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          controller: dashboardScroll,
                          child: SingleChildScrollView(
                            padding: sccOutterPadding,
                            controller: dashboardScroll,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<MstUsrRoleBloc, MstUsrRoleState>(
                                  builder: (context, state) {
                                    if (state is LoadShape) {
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
                                                : const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    // horizontal: 24,
                                                  ),
                                            child: AdminFormScreen(
                                              formMode: formMode,
                                              // listBrand: listBrand,
                                              listCompany: listCompany,
                                              listDivision: listDivision,
                                              listBrand: state.listBrand,
                                              listCountry: state.listCountry,
                                              model: state.model,
                                              onClose: () {
                                                searchCo.clear();
                                                searchVal = '';
                                                paging.pageNo = 1;
                                                model = MasterRole(
                                                    username: '', email: '');
                                                setState(() {
                                                  formMode = "";
                                                });
                                                onSearch(searchVal);
                                              },
                                              onSubmit: (value) {
                                                value.validFromDt =
                                                    state.validFormDt;
                                                bloc(SubmitMasterRole(value,
                                                    formMode, paging, model));
                                              },
                                              paging: paging,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: context.deviceWidth() *
                                                      0.1,
                                                  child: SelectableText(
                                                    'Role',
                                                    style: TextStyle(
                                                        fontSize: context
                                                            .scaleFont(14),
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: context.deviceWidth() *
                                                      0.1,
                                                  child: SelectableText(
                                                    'Search By',
                                                    style: TextStyle(
                                                        fontSize: context
                                                            .scaleFont(14),
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: !isMobile,
                                            child: const SizedBox(
                                              height: 10,
                                            ),
                                          ),
                                          BlocBuilder<MstUsrRoleBloc,
                                              MstUsrRoleState>(
                                            builder: (context, state) {
                                              return SizedBox(
                                                height: isMobile ? 50 : 48,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Visibility(
                                                      visible: !isMobile,
                                                      child: SizedBox(
                                                        width: context
                                                                .deviceWidth() *
                                                            0.1,
                                                        child:
                                                            PortalFormDropdownKeyVal(
                                                          roleSelected,
                                                          role,
                                                          enabled:
                                                              role.isNotEmpty,
                                                          fillColour:
                                                              Colors.white,
                                                          borderColor: sccWhite,
                                                          // fontWeight: FontWeight.normal,
                                                          borderRadius: 8,
                                                          onChange: (value) {
                                                            setState(() {
                                                              if (role.length >
                                                                  1) {
                                                                roleSelected =
                                                                    value;
                                                              }
                                                            });
                                                            onSearch("");
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: !isMobile,
                                                      child: const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ),
                                                    isMobile
                                                        ? InkWell(
                                                            onTap: () {
                                                              showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                isDismissible:
                                                                    true,
                                                                enableDrag:
                                                                    categorySelected !=
                                                                        null,
                                                                isScrollControlled:
                                                                    true,
                                                                builder:
                                                                    (context) {
                                                                  return SearchRoleBottomSheet(
                                                                    searchByChange: (KeyVal?
                                                                            val) =>
                                                                        categorySelected =
                                                                            val,
                                                                    superAdminChange:
                                                                        (KeyVal?
                                                                            val) {
                                                                      roleSelected =
                                                                          val!;
                                                                      onSearch(
                                                                          searchVal);
                                                                    },
                                                                    searchByList:
                                                                        category,
                                                                    selectedSearchBy:
                                                                        categorySelected,
                                                                    superAdminList:
                                                                        role,
                                                                    superAdminSelected:
                                                                        roleSelected,
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: AspectRatio(
                                                              aspectRatio: 1,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(12),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color:
                                                                      sccWhite,
                                                                ),
                                                                child:
                                                                    const GradientWidget(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter,
                                                                    colors: [
                                                                      sccButtonLightBlue,
                                                                      sccButtonBlue,
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      HeroIcon(
                                                                    HeroIcons
                                                                        .adjustmentsVertical,
                                                                    // size: 25,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            width: context
                                                                    .deviceWidth() *
                                                                0.1,
                                                            child:
                                                                PortalFormDropdownKeyVal(
                                                              categorySelected,
                                                              category,
                                                              enabled: category
                                                                  .isNotEmpty,
                                                              fillColour:
                                                                  Colors.white,
                                                              // fontWeight: FontWeight.normal,
                                                              borderColor:
                                                                  sccWhite,
                                                              borderRadiusBotRight:
                                                                  0,
                                                              borderRadiusTopRight:
                                                                  0,
                                                              onChange:
                                                                  (value) {
                                                                setState(() {
                                                                  categorySelected =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                          ),

                                                    Expanded(
                                                      flex: 3,
                                                      child: PlainSearchField(
                                                        controller: searchCo,
                                                        fillColor:
                                                            sccBackground,
                                                        hint: 'Search here...',
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
                                                        onChanged: (value) {
                                                          setState(() {
                                                            searchVal =
                                                                value ?? "";
                                                          });
                                                          // onSearch(searchVal);
                                                        },
                                                        borderRadius: 8,
                                                        suffixSize: 50,
                                                        onAction: (value) {
                                                          onSearch(value);
                                                        },
                                                        onSearch: () {
                                                          onSearch(searchVal);
                                                        },
                                                      ),
                                                    ),
                                                    const Expanded(
                                                      flex: 2,
                                                      child: SizedBox(),
                                                    ),
                                                    // Visibility(
                                                    //   visible: functionCreate != null,
                                                    //   child:
                                                    Visibility(
                                                      visible: buttonSett,
                                                      child: EditButton(
                                                        width: context
                                                                .deviceWidth() *
                                                            (context.isDesktop()
                                                                ? 0.14
                                                                : 0.38),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Visibility(
                                                      visible:
                                                          premittedAdd != null,
                                                      child:
                                                          ButtonConfirmWithIcon(
                                                        icon: HeroIcon(
                                                          HeroIcons.plus,
                                                          color: sccWhite,
                                                          size: context
                                                              .scaleFont(14),
                                                        ),
                                                        text: "Add New",
                                                        borderRadius: 12,
                                                        width: context
                                                                .deviceWidth() *
                                                            (context.isDesktop()
                                                                ? 0.14
                                                                : 0.38),
                                                        onTap: () {
                                                          setState(() {
                                                            formMode = Constant
                                                                .addMode;
                                                          });
                                                          bloc(
                                                              ToMasterRoleForm());
                                                        },
                                                        colour: sccNavText2,
                                                      ),
                                                    ),

                                                    // ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          CommonShimmer(
                                            isLoading:
                                                state is MasterRoleLoading,
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
                                                        horizontal: 16),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'User Role',
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
                                                              bloc(
                                                                  SearchMasterRole(
                                                                model: model,
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
                                                  isMobile
                                                      ? ListRoleMob(
                                                          model: searchList,
                                                          canDelete:
                                                              premittedDelete !=
                                                                  null,
                                                          canView: true,
                                                          canUpdate:
                                                              premittedEdit !=
                                                                  null,
                                                          onDelete: (MasterRole
                                                                  val) =>
                                                              onDelete(val),
                                                          onEdit: (MasterRole
                                                                  val) =>
                                                              onEdit(val),
                                                          onView: (MasterRole
                                                                  val) =>
                                                              onView(val),
                                                        )
                                                      : ListMasterRole(
                                                          model: searchList,
                                                          canDelete:
                                                              premittedDelete !=
                                                                  null,
                                                          canView: true,
                                                          canUpdate:
                                                              premittedEdit !=
                                                                  null,
                                                          onDelete: (value) =>
                                                              onDelete(value),
                                                          onEdit: (value) =>
                                                              onEdit(value),
                                                          // onEdit(value),
                                                          onView: (value) =>
                                                              onView(value),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          BlocBuilder<MstUsrRoleBloc,
                                              MstUsrRoleState>(
                                            builder: (context, state) {
                                              return Visibility(
                                                visible: paging.totalPages !=
                                                        null &&
                                                    paging.totalPages != null &&
                                                    searchList.isNotEmpty,
                                                child: CommonShimmer(
                                                  isLoading: state
                                                      is MasterRoleLoading,
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
                                                        onClickFirstPage: () {
                                                          paging.pageNo = 1;
                                                          bloc(SearchMasterRole(
                                                            model: model,
                                                            paging: paging,
                                                          ));
                                                        },
                                                        onClickPrevious: () {
                                                          paging.pageNo =
                                                              paging.pageNo! -
                                                                  1;
                                                          bloc(SearchMasterRole(
                                                            model: model,
                                                            paging: paging,
                                                          ));
                                                        },
                                                        onClick: (value) {
                                                          paging.pageNo = value;
                                                          bloc(SearchMasterRole(
                                                            model: model,
                                                            paging: paging,
                                                          ));
                                                        },
                                                        onClickNext: () {
                                                          paging.pageNo =
                                                              paging.pageNo! +
                                                                  1;
                                                          bloc(SearchMasterRole(
                                                            model: model,
                                                            paging: paging,
                                                          ));
                                                        },
                                                        onClickLastPage: () {
                                                          paging.pageNo =
                                                              paging.totalPages;
                                                          bloc(SearchMasterRole(
                                                            model: model,
                                                            paging: paging,
                                                          ));
                                                        },
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
                                  },
                                ),
                                SizedBox(
                                  height: 12.wh,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EditButton extends StatefulWidget {
  final double? width;
  const EditButton({this.width, Key? key}) : super(key: key);

  @override
  State<EditButton> createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? context.deviceWidth(),
      child: LayoutBuilder(
        builder: (ctx, ctn) {
          return PortalTarget(
            visible: isHovered,
            portalFollower: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  isHovered = !isHovered;
                });
              },
            ),
            child: PortalTarget(
              visible: isHovered,
              anchor: const Aligned(
                follower: Alignment.topCenter,
                target: Alignment.bottomCenter,
              ),
              portalFollower: Container(
                padding: const EdgeInsets.all(8),
                width: ctn.maxWidth,
                // height: 100,
                decoration: BoxDecoration(
                  color: sccWhite,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          setState(() {
                            isHovered = false;
                          });
                          context.push(const MasterMenuRoute());
                        },
                        // dense: true,
                        title: Text(
                          "Menu",
                          style: TextStyle(
                            color: sccText1,
                            fontSize: context.scaleFont(14),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            isHovered = false;
                          });
                          context.push(const MasterRoleRoute());
                        },
                        // dense: true,
                        title: Text(
                          "Role",
                          style: TextStyle(
                            color: sccText1,
                            fontSize: context.scaleFont(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isHovered = !isHovered;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: sccNavText2.withOpacity(0.05),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Setting",
                          style: TextStyle(
                            fontSize: context.scaleFont(14),
                            color: sccButtonBlue,
                            fontWeight: FontWeight.bold,
                            // overflow: TextOverflow.fade,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Icon(
                        isHovered ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        color: sccNavText2,
                        size: context.scaleFont(18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
