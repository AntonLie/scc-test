// ignore_for_file: library_private_types_in_public_api

import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/master_menu/bloc/master_menu_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/menu_model.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permittedFuncfeat.dart';
import 'package:scc_web/screens/master_menu/dialog_delete_menu.dart';
import 'package:scc_web/screens/master_menu/dialog_edit_menu.dart';
import 'package:scc_web/screens/master_menu/form_edit_menu.dart';
import 'package:scc_web/screens/master_menu/master_menu_form.dart';
import 'package:scc_web/screens/master_menu/master_menu_table.dart';
import 'package:scc_web/shared_widgets/add_finish_dialog.dart';
import 'package:scc_web/shared_widgets/category_btm_sheet.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

import '../../model/menu.dart';

class MasterMenuScreen extends StatefulWidget {
  const MasterMenuScreen({Key? key}) : super(key: key);

  @override
  _MasterMenuScreenState createState() => _MasterMenuScreenState();
}

class _MasterMenuScreenState extends State<MasterMenuScreen> {
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
                child: const PersistDrawer(
                    initiallyExpanded: true, selectedTile: Constant.menu),
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
              create: (context) => MasterMenuBloc()
                ..add(SearchMasterMenu(
                  model: MenuModel(),
                  paging: Paging(pageNo: 1, pageSize: 5),
                )),
            ),
            // BlocProvider(create: (context) => PermittedFFBloc() //..add(GetPermitted(Constant.ROLE))
            //     ),
          ],
          child: const MasterMenuBody(),
        ),
      ),
    );
  }
}

class MasterMenuBody extends StatefulWidget {
  const MasterMenuBody({Key? key}) : super(key: key);

  @override
  _MasterMenuBodyState createState() => _MasterMenuBodyState();
}

class _MasterMenuBodyState extends State<MasterMenuBody> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final controller = ScrollController();
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  MenuModel modelSearch = MenuModel(
    // menuCd: '',
    menuName: '',
  );
  TextEditingController searchCo = TextEditingController();
  String searchVal = "";
  String searchHint = "";
  String menuTitle = "Menu";
  String menuName = "";
  String formMode = "";
  Login? login;
  String? parentMenuSelected;
  List<KeyVal> parentMenuOpt = [
    KeyVal('All', ""),
  ];
  KeyVal? searchCatSelected;
  List<KeyVal> searchCat = [];
  List<MenuModel> listModel = [];
  List<Menu> listMenu = [];
  // PermittedFunc? permitted;

  FeatureList? premittedAdd;
  FeatureList? premittedView;
  FeatureList? premittedEdit;
  FeatureList? premittedDelete;
  FunctionList? functionSearch;
  FunctionList? functionCreate;
  FunctionList? functionGet;
  FunctionList? functionUpdate;
  FunctionList? functionDelete;
  bool expandNavBar = true;
  bool showNavBar = true;
  bool isFromForm = false;

  @override
  void initState() {
    searchCat.add(
      KeyVal("Menu Code", Constant.menuCode),
    );
    searchCat.add(
      KeyVal("Menu Name", Constant.menuName),
    );
    searchCatSelected = searchCat[0];

    searchHint = "Search Menu...";
    // searchCatSelected?.value == Constant.menuName ? "Search Menu Name" : "Search Menu Code";
    parentMenuSelected = parentMenuOpt[0].value;
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

    bloc(MasterMenuEvent event) {
      BlocProvider.of<MasterMenuBloc>(context).add(event);
    }

    functionError(String? msg) {
      showTopSnackBar(
          context, UpperSnackBar.error(message: msg ?? "Error occured"));
    }

    showDialogAddFinish(String? val) {
      showDialog(
        context: context,
        builder: (context) {
          return AddFinishDialog(
            val: val,
            onTap: () {
              context.back();
            },
            title:
                'Menu Successfully ${formMode == Constant.addMode ? "Added" : "Edited"}',
          );
        },
      );
    }

    onSearch(String val) {
      paging.pageNo = 1;
      modelSearch = MenuModel(
        menuName: val.trim(),
        parentMenuCd: parentMenuSelected,
      );
      bloc(SearchMasterMenu(
        paging: paging,
        model: modelSearch,
      ));
    }

    showDialogSuccess() {
      showDialog(
        context: context,
        builder: (context) {
          return AddFinishDialog(
            title: 'Success',
            val: "Feature selection for menu is successful",
            onTap: () {
              context.back();
            },
          );
        },
      ).then((value) {
        return onSearch(searchVal);
      });
    }

    onSelect(MenuModel model) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return LovMenu(
            model: model,
            onError: (value) {
              functionError(value);
            },
            onLogout: () {
              authBloc(AuthLogin());
            },
            onSuccess: () {
              showDialogSuccess();
            },
          );
        },
      );
    }

    return Column(
      children: [
        BlocProvider(
          create: (context) => ProfileBloc()..add(GetProfileData()),
          child: CustomAppBar(
            menuTitle: "User Role",
            menuName: "Master User Role",
            childMenu: "Menu",
            formMode: formMode,
            onClickChild: () {
              setState(() {
                formMode = "";
              });
              onSearch(searchVal);
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
        Expanded(
          child: Row(
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
                    selectedTile: Constant.menu,
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
                          // BlocProvider(
                          //   create: (context) => HomeBloc()..add(GetMenu()),
                          // ),
                          BlocProvider(
                            create: (context) => AuthBloc(),
                          ),
                        ],
                        child: Container(),
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
                                functionError(state.error);
                              }
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
                          BlocListener<MasterMenuBloc, MasterMenuState>(
                            listener: (context, state) {
                              if (state is MasterMenuError) {
                                functionError(state.error);
                              }
                              if (state is OnLogoutMasterMenu) {
                                authBloc(AuthLogin());
                              }
                              if (state is LoadTable) {
                                setState(() {
                                  menuName = '';
                                  menuTitle = "Menu";
                                });
                                if (state.paging != null) {
                                  paging = state.paging!;
                                }
                                parentMenuOpt.clear();
                                parentMenuOpt.add(KeyVal('All', ""));
                                for (var element in state.listParents) {
                                  if (element.menuCd != null) {
                                    parentMenuOpt.add(KeyVal(
                                        element.menuName ??
                                            "[UNIDENTIFIED MENU]",
                                        element.menuCd!));
                                  }
                                }
                                // parentMenuSelected = parentMenuOpt[0].value;
                                listModel.clear();
                                listModel.addAll(state.listModel);
                                controller.jumpTo(0);
                              }
                              if (state is MenuFeatLoaded) {
                                if (state.success == true) {
                                  showDialogSuccess();
                                } else if (state.error != null) {
                                  functionError(state.error);
                                }
                                setState(() {
                                  menuName =
                                      "Edit Menu ${state.model.menuName ?? "[UNIDENTIFIED MENU]"}";
                                  menuTitle = menuName;
                                });
                              }
                              if (state is MasterMenuSubmitted) {
                                showTopSnackBar(context,
                                    UpperSnackBar.success(message: state.msg));
                                setState(() {
                                  formMode = "";
                                });

                                if (state.paging != null) {
                                  paging = state.paging!;
                                }
                                listModel.clear();
                                listModel.addAll(state.listModel);
                              }
                            },
                          ),
                        ],
                        child: Column(
                          children: [
                            Expanded(
                              child: Scrollbar(
                                controller: controller,
                                child: SingleChildScrollView(
                                  controller: controller,
                                  padding: sccOutterPadding,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BlocBuilder<MasterMenuBloc,
                                          MasterMenuState>(
                                        builder: (context, state) {
                                          return Visibility(
                                            visible: state is LoadTable,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SelectableText(
                                                    'Search by',
                                                    style: TextStyle(
                                                      fontSize:
                                                          context.scaleFont(14),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                SizedBox(
                                                  height: 48,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      isMobile
                                                          ? InkWell(
                                                              onTap: searchCat
                                                                      .isNotEmpty
                                                                  ? () {
                                                                      showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        builder:
                                                                            (context) {
                                                                          return Container(
                                                                            height:
                                                                                context.deviceHeight() * 0.8,
                                                                            padding: const EdgeInsets.only(
                                                                                top: 12,
                                                                                left: 8,
                                                                                right: 8),
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(25.0),
                                                                                topRight: Radius.circular(25.0),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                BottomSheetOptions(
                                                                              title: 'Search By',
                                                                              options: searchCat,
                                                                              value: searchCatSelected,
                                                                              onChanged: (value) {
                                                                                if (value != null) {
                                                                                  setState(() {
                                                                                    searchCatSelected = value;
                                                                                  });
                                                                                }
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    }
                                                                  : () {},
                                                              child:
                                                                  AspectRatio(
                                                                aspectRatio: 1,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(12),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
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
                                                                      size: 25,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Expanded(
                                                              flex: 1,
                                                              child:
                                                                  PortalFormDropdown(
                                                                parentMenuSelected,
                                                                parentMenuOpt,
                                                                borderRadius: 8,
                                                                borderRadiusBotRight:
                                                                    0,
                                                                borderRadiusTopRight:
                                                                    0,
                                                                enabled:
                                                                    parentMenuOpt
                                                                            .length >
                                                                        1,
                                                                borderColour:
                                                                    sccWhite,
                                                                onChange:
                                                                    (value) {
                                                                  setState(() {
                                                                    parentMenuSelected =
                                                                        value;
                                                                  });
                                                                  onSearch(
                                                                      searchVal);
                                                                },
                                                              ),
                                                            ),
                                                      // SizedBox(
                                                      //   width: 10,
                                                      // ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: PlainSearchField(
                                                          hint: searchHint,
                                                          fillColor:
                                                              sccBackground,
                                                          controller: searchCo,
                                                          borderRadius: 8,
                                                          borderRadiusTopLeft:
                                                              0,
                                                          borderRadiusBotLeft:
                                                              0,
                                                          prefix: searchCo.text
                                                                  .isNotEmpty
                                                              ? IconButton(
                                                                  // splashRadius: 0,
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
                                                                      paging.pageNo =
                                                                          1;
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
                                                          },
                                                          onAction: (value) {
                                                            paging.pageNo = 1;
                                                            // if (functionSearch != null) {
                                                            onSearch(
                                                                value ?? "");
                                                            // }
                                                          },
                                                          onSearch: () {
                                                            paging.pageNo = 1;
                                                            onSearch(searchVal);
                                                          }
                                                          // : null
                                                          ,
                                                        ),
                                                      ),
                                                      const Expanded(
                                                        flex: 3,
                                                        child: SizedBox(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 12.wh),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      BlocBuilder<MasterMenuBloc,
                                          MasterMenuState>(
                                        builder: (context, state) {
                                          if (state is MenuFeatLoaded) {
                                            return Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: isMobile
                                                        ? Colors.transparent
                                                        : sccWhite,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: FormEditMenu(
                                                    model: state.model,
                                                    onClose: () {
                                                      paging.pageNo = 1;
                                                      searchVal = "";
                                                      setState(() {
                                                        formMode = "";
                                                      });
                                                      onSearch(searchVal);
                                                    },
                                                    onSubmit: (value) {
                                                      bloc(UpdateMenuFeatForm(
                                                          value));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (state is LoadForm) {
                                            return Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: isMobile
                                                        ? Colors.transparent
                                                        : sccWhite,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: FormMasterMenu(
                                                    listMenuType:
                                                        state.listMenuType,
                                                    listParentMenu:
                                                        state.listParentMenu,
                                                    model: state.submitModel,
                                                    formMode: formMode,
                                                    createMethod: functionCreate
                                                            ?.method ??
                                                        Constant.post,
                                                    createUrl:
                                                        functionCreate?.url ??
                                                            "",
                                                    updateMethod: functionUpdate
                                                            ?.method ??
                                                        Constant.put,
                                                    updateUrl:
                                                        functionUpdate?.url ??
                                                            "",
                                                    searchMethod: functionSearch
                                                            ?.method ??
                                                        Constant.get,
                                                    searchUrl:
                                                        functionSearch?.url ??
                                                            "",
                                                    paging: paging,
                                                    onSuccesSubmit: (value) {
                                                      searchCo.clear();
                                                      searchVal = '';

                                                      modelSearch = MenuModel(
                                                        menuCd: searchCatSelected
                                                                    ?.value ==
                                                                Constant
                                                                    .menuCode
                                                            ? searchVal
                                                            : null,
                                                        menuName: searchCatSelected
                                                                    ?.value ==
                                                                Constant
                                                                    .menuName
                                                            ? searchVal
                                                            : null,
                                                      );
                                                      showDialogAddFinish(
                                                          value.msg);
                                                      if (value.paging !=
                                                          null) {
                                                        paging = value.paging!;
                                                      }
                                                      if (formMode ==
                                                          Constant.addMode) {
                                                        paging.pageNo = 1;
                                                      }
                                                      bloc(SearchMasterMenu(
                                                        method: functionSearch
                                                                ?.method ??
                                                            Constant.get,
                                                        url: functionSearch
                                                                ?.url ??
                                                            "",
                                                        paging: paging,
                                                        model: modelSearch,
                                                      ));
                                                      listModel.clear();
                                                      listModel.addAll(
                                                          value.listModel);
                                                    },
                                                    onClose: () {
                                                      searchCo.clear();
                                                      searchVal = '';
                                                      modelSearch = MenuModel(
                                                        menuCd: searchCatSelected
                                                                    ?.value ==
                                                                Constant
                                                                    .menuCode
                                                            ? searchVal
                                                            : null,
                                                        menuName: searchCatSelected
                                                                    ?.value ==
                                                                Constant
                                                                    .menuName
                                                            ? searchVal
                                                            : null,
                                                      );
                                                      bloc(SearchMasterMenu(
                                                        method: functionSearch
                                                                ?.method ??
                                                            Constant.get,
                                                        url: functionSearch
                                                                ?.url ??
                                                            "",
                                                        paging: paging,
                                                        model: modelSearch,
                                                      ));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return CommonShimmer(
                                              isLoading:
                                                  state is MasterMenuLoading,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isMobile
                                                      ? Colors.transparent
                                                      : sccWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 2,
                                                      offset:
                                                          const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Visibility(
                                                      visible: !isMobile,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Menu',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: context
                                                                        .scaleFont(
                                                                            18),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: const Color(
                                                                        0xff2B2B2B),
                                                                  ),
                                                                ),
                                                                PagingDropdown(
                                                                  selected:
                                                                      (paging.pageSize ??
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
                                                                      onSearch(
                                                                          searchVal);
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    listModel.isNotEmpty
                                                        ? MasterMenuTable(
                                                            listModel:
                                                                listModel,
                                                            canDelete:
                                                                functionDelete !=
                                                                    null,
                                                            canView:
                                                                functionGet !=
                                                                    null,
                                                            canUpdate:
                                                                functionGet !=
                                                                        null &&
                                                                    functionUpdate !=
                                                                        null,
                                                            onDelete: (value) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return BlocProvider(
                                                                      create: (context) =>
                                                                          MasterMenuBloc(),
                                                                      child:
                                                                          DeleteMstMenuDialog(
                                                                        menuCd:
                                                                            value.menuCd ??
                                                                                "",
                                                                        menuName:
                                                                            value.menuName ??
                                                                                "[Undefined Function Feature]",
                                                                        method: functionDelete?.method ??
                                                                            Constant.delete,
                                                                        url: functionDelete?.url ??
                                                                            "",
                                                                        onError:
                                                                            (value) {
                                                                          functionError(
                                                                              value);
                                                                        },
                                                                        onLogout:
                                                                            () {
                                                                          authBloc(
                                                                              AuthLogin());
                                                                        },
                                                                      ),
                                                                    );
                                                                  }).then((val) {
                                                                if (val !=
                                                                        null &&
                                                                    val is bool &&
                                                                    val) {
                                                                  context
                                                                      .back();

                                                                  if (listModel
                                                                              .length ==
                                                                          1 &&
                                                                      paging.pageNo !=
                                                                          1) {
                                                                    paging.pageNo =
                                                                        paging.pageNo! -
                                                                            1;
                                                                  }
                                                                  bloc(
                                                                      SearchMasterMenu(
                                                                    method: functionSearch
                                                                            ?.method ??
                                                                        Constant
                                                                            .get,
                                                                    url: functionSearch
                                                                            ?.url ??
                                                                        "",
                                                                    paging:
                                                                        paging,
                                                                    model:
                                                                        modelSearch,
                                                                  ));
                                                                }
                                                              });
                                                            },
                                                            onEdit: (value) {
                                                              setState(() {
                                                                formMode =
                                                                    Constant
                                                                        .editMode;
                                                              });
                                                              bloc(
                                                                  ToMasterMenuForm(
                                                                method: functionGet
                                                                        ?.method ??
                                                                    Constant
                                                                        .get,
                                                                url: functionGet
                                                                        ?.url ??
                                                                    "",
                                                                menuCd: value
                                                                    .menuCd,
                                                              ));
                                                            },
                                                            onView: (value) {
                                                              setState(() {
                                                                formMode =
                                                                    Constant
                                                                        .viewMode;
                                                              });
                                                              bloc(
                                                                  ToMasterMenuForm(
                                                                method: functionGet
                                                                        ?.method ??
                                                                    Constant
                                                                        .get,
                                                                url: functionGet
                                                                        ?.url ??
                                                                    "",
                                                                menuCd: value
                                                                    .menuCd,
                                                              ));
                                                            },
                                                            onSelect: (value) {
                                                              if (value
                                                                      .listFeature
                                                                      ?.isNotEmpty ==
                                                                  true) {
                                                                isFromForm =
                                                                    !isFromForm;
                                                                setState(() {
                                                                  formMode =
                                                                      "Detail";
                                                                });
                                                                bloc(ToMenuFeatDialog(
                                                                    menu:
                                                                        value));
                                                              } else {
                                                                onSelect(value);
                                                              }
                                                            },
                                                          )
                                                        : const EmptyData(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 24),
                                      BlocBuilder<MasterMenuBloc,
                                          MasterMenuState>(
                                        builder: (context, state) {
                                          return Visibility(
                                            visible:
                                                paging.totalPages != null &&
                                                    paging.totalPages != null &&
                                                    state is LoadTable,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: SimplePaging(
                                                    pageNo: paging.pageNo!,
                                                    pageToDisplay:
                                                        isMobile ? 3 : 5,
                                                    totalPages:
                                                        paging.totalPages,
                                                    pageSize: paging.pageSize,
                                                    totalData: paging.totalData,
                                                    totalDataInPage:
                                                        paging.totalDataInPage,
                                                    borderRadius: 8,
                                                    // totalRows: paging.pageSize,
                                                    // onChangeTotalData: (value) {
                                                    //   paging.pageNo = 1;
                                                    //   paging.pageSize = value;
                                                    //   bloc(SearchMasterMenu(
                                                    //     // method: functionSearch?.method ?? Constant.get,
                                                    //     // url: functionSearch?.url ?? "",
                                                    //     paging: paging,
                                                    //     model: modelSearch,
                                                    //   ));
                                                    // },
                                                    onClickFirstPage: () {
                                                      paging.pageNo = 1;
                                                      bloc(SearchMasterMenu(
                                                        // method: functionSearch?.method ?? Constant.get,
                                                        // url: functionSearch?.url ?? "",
                                                        paging: paging,
                                                        model: modelSearch,
                                                      ));
                                                    },
                                                    onClickPrevious: () {
                                                      paging.pageNo =
                                                          paging.pageNo! - 1;
                                                      bloc(SearchMasterMenu(
                                                        // method: functionSearch?.method ?? Constant.get,
                                                        // url: functionSearch?.url ?? "",
                                                        paging: paging,
                                                        model: modelSearch,
                                                      ));
                                                    },
                                                    onClick: (value) {
                                                      paging.pageNo = value;
                                                      bloc(SearchMasterMenu(
                                                        // method: functionSearch?.method ?? Constant.get,
                                                        // url: functionSearch?.url ?? "",
                                                        paging: paging,
                                                        model: modelSearch,
                                                      ));
                                                    },
                                                    onClickNext: () {
                                                      paging.pageNo =
                                                          paging.pageNo! + 1;
                                                      bloc(SearchMasterMenu(
                                                        // method: functionSearch?.method ?? Constant.get,
                                                        // url: functionSearch?.url ?? "",
                                                        paging: paging,
                                                        model: modelSearch,
                                                      ));
                                                    },
                                                    onClickLastPage: () {
                                                      paging.pageNo =
                                                          paging.totalPages;
                                                      bloc(SearchMasterMenu(
                                                        // method: functionSearch?.method ?? Constant.get,
                                                        // url: functionSearch?.url ?? "",
                                                        paging: paging,
                                                        model: modelSearch,
                                                      ));
                                                    },
                                                  ),
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
          ),
        ),
      ],
    );
  }
}
