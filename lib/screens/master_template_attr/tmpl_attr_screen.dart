import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/mst_template_attribute/bloc/template_attribute_bloc.dart';
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
import 'package:scc_web/model/temp_attr.dart';
import 'package:scc_web/screens/master_template_attr/lov_temp_attr_delete.dart';
import 'package:scc_web/screens/master_template_attr/tmpl_attr_form.dart';
import 'package:scc_web/screens/master_template_attr/tmpl_attr_table.dart';
import 'package:scc_web/screens/master_template_attr/view_temp_attr_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
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
import 'package:scc_web/shared_widgets/success_dialog.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';

class TemplateAttributeScreen extends StatefulWidget {
  const TemplateAttributeScreen({super.key});

  @override
  State<TemplateAttributeScreen> createState() =>
      _TemplateAttributeScreenState();
}

class _TemplateAttributeScreenState extends State<TemplateAttributeScreen> {
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
              create: (context) => TemplateAttributeBloc()
                ..add(SearchTemplateAttr(
                    TempAttr(
                      tempAttrCd: "",
                    ),
                    paging: Paging(pageNo: 1, pageSize: 5))),
            ),
            BlocProvider(
              create: (context) => PermittedFeatBloc()
                ..add(
                  GetPermitted(Constant.tempAttribute),
                ),
            )
          ],
          child: const TemplateAttributeBody(),
        ),
      ),
    );
  }
}

class TemplateAttributeBody extends StatefulWidget {
  const TemplateAttributeBody({super.key});

  @override
  State<TemplateAttributeBody> createState() => _TemplateAttributeBodyState();
}

class _TemplateAttributeBodyState extends State<TemplateAttributeBody> {
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  TempAttr modelSearch = TempAttr(
    tempAttrCd: "",
  );

  Login? login;

  final dashboardScroll = ScrollController();
  final horController = ScrollController();

  List<TempAttr> searchList = [];
  List<Menu> listMenu = [];

  String? templAttrCd;
  String? templAttrName;
  String formMode = "";

  String? categorySelected;
  List<KeyVal> category = [];

  String? searchVal;
  TempAttr model = TempAttr();

  late TextEditingController searchCo;

  PermittedFunc? permitted;
  FeatureList? premittedAdd;
  FeatureList? premittedView;
  FeatureList? premittedEdit;
  FeatureList? premittedDelete;
  bool isSuperAdmin = false;
  bool expandNavBar = true;
  bool showNavBar = true;
  bool shwBtnBack = false;

  @override
  void initState() {
    searchCo = TextEditingController();

    // formMode = Constant.addMode;

    category.add(
      KeyVal("Template Attribute Name", Constant.tempAttrName),
    );

    category.add(
      KeyVal("Template Attribute Code", Constant.tempAttrCode),
    );

    categorySelected = category[0].value;

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

    tmplAttrError(String? msg) {
      showTopSnackBar(
          context, UpperSnackBar.error(message: msg ?? "Error occured"));
    }

    bloc(TemplateAttributeEvent event) {
      BlocProvider.of<TemplateAttributeBloc>(context).add(event);
    }

    onEdit(TempAttr value) {
      setState(() {
        formMode = Constant.editMode;
      });
      bloc(ViewTemplateAttr(model: TempAttr(tempAttrCd: value.tempAttrCd)));
    }

    onView(TempAttr value, bool canUpdate) {
      showDialog(
          context: context,
          builder: (context) {
            return BlocProvider(
                create: (context) => TemplateAttributeBloc()
                  ..add(ViewTemplateAttr(model: value)),
                child: ViewDialogTempAttr(
                  onEdit: () {
                    context.back();
                    onEdit(value);
                  },
                  canUpdate: canUpdate,
                ));
          });
    }

    return Column(
      children: [
        BlocProvider(
          create: (context) => ProfileBloc()..add(GetProfileData()),
          child: CustomAppBar(
            menuTitle: "Template Attribute",
            menuName: "Master Template Attribute",
            formMode: formMode,
            onClick: () {
              bloc(SearchTemplateAttr(
                model,
                paging: paging,
              ));
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
                    selectedTile: Constant.tempAttribute,
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
                                // locator<NavigatorService>()
                                //     .navigateReplaceTo(Constant.MENU_LOGIN);
                              }
                            },
                          ),
                          BlocListener<HomeBloc, HomeState>(
                            listener: (context, state) {
                              if (state is HomeError) {
                                tmplAttrError(state.error);
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
                          BlocListener<TemplateAttributeBloc,
                              TemplateAttributeState>(
                            listener: (context, state) {
                              if (state is TemplateAttributeError) {
                                tmplAttrError(state.msg);
                                setState(() {
                                  formMode = "";
                                });
                              }
                              // if (state is TemplateAttributeLoading) {
                              //   isLoading = true;
                              // } else {
                              //   isLoading = false;
                              // }
                              if (state is OnLogoutTemplateAttribute) {
                                authBloc(AuthLogin());
                              }
                              if (state is SearchTempAttr) {
                                searchList.clear();
                                searchList.addAll(state.listTempAttr);
                                if (state.paging != null) {
                                  paging = state.paging!;
                                }
                                dashboardScroll.jumpTo(0);
                              }
                              if (state is ViewTmplAttrLoaded) {
                                setState(() {
                                  // shwBtnBack = !shwBtnBack;
                                });
                                if (state.errMsg != null) {
                                  tmplAttrError(state.errMsg);
                                }
                              }
                              if (state is AddTmplAttrSubmit) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) {
                                    return SuccessDialog(
                                      title: "Template Successfully Added",
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
                                  modelSearch = TempAttr(attrCode: "");
                                  setState(() {
                                    formMode = "";
                                  });
                                  bloc(SearchTemplateAttr(
                                    modelSearch,
                                    paging: paging,
                                    // method: functionSearch?.method ?? Constant.GET,
                                    // url: functionSearch?.url ?? "",
                                  ));
                                });
                              }
                              if (state is EditTmplAttrSubmit) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) {
                                    return SuccessDialog(
                                      title: "Template Successfully Updated",
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
                                  modelSearch = TempAttr(attrCode: "");
                                  bloc(SearchTemplateAttr(
                                    modelSearch,
                                    paging: paging,
                                    // method: functionSearch?.method ?? Constant.GET,
                                    // url: functionSearch?.url ?? "",
                                  ));
                                });
                              }
                            },
                          ),
                          BlocListener<PermittedFeatBloc, PermittedFeatState>(
                            listener: (context, state) {
                              if (state is PermittedFeatSuccess) {
                                permitted = state.model;

                                premittedAdd = permitted?.featureList
                                    ?.firstWhere(
                                        (e) => e.featureCd == Constant.F_ADD);
                                premittedEdit = permitted?.featureList
                                    ?.firstWhere(
                                        (e) => e.featureCd == Constant.F_EDIT);
                                premittedDelete = permitted?.featureList
                                    ?.firstWhere((e) =>
                                        e.featureCd == Constant.F_DELETE);
                                isSuperAdmin = (permitted?.superAdmin ?? false);
                                bloc(SearchTemplateAttr(
                                  modelSearch,
                                  paging: Paging(pageNo: 1, pageSize: 5),
                                ));
                              }
                              if (state is PermittedFeatError) {
                                showTopSnackBar(context,
                                    UpperSnackBar.error(message: state.errMsg));
                              }
                              if (state is OnLogoutPermittedFeat) {
                                authBloc(AuthLogin());
                              }
                            },
                            child: Container(),
                          ),
                        ],
                        child: Column(
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
                                ],
                                child: Container(),
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
                                          create: (context) =>
                                              HomeBloc()..add(GetMenu()),
                                        ),
                                        BlocProvider(
                                          create: (context) => AuthBloc(),
                                        ),
                                      ],
                                      child: Container(),
                                      // PersistDrawer(
                                      //   initiallyExpanded: expandNavBar,
                                      //   selectedTile: Constant.TEMP_ATTRIBUTE,
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
                                          child: BlocBuilder<
                                              TemplateAttributeBloc,
                                              TemplateAttributeState>(
                                            builder: (context, state) {
                                              return Scrollbar(
                                                controller: dashboardScroll,
                                                child: SingleChildScrollView(
                                                  padding: sccOutterPadding,
                                                  controller: dashboardScroll,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Builder(
                                                        builder: (context) {
                                                          if (state
                                                              is ViewTmplAttrLoaded) {
                                                            return Column(
                                                              children: [
                                                                TempAttrForm(
                                                                  formMode:
                                                                      formMode,
                                                                  model: state
                                                                      .model,
                                                                  onSave:
                                                                      (value) {
                                                                    if (formMode ==
                                                                        Constant
                                                                            .addMode) {
                                                                      bloc(
                                                                          AddTemplateAttribute(
                                                                        value,
                                                                        // functionCreate?.method ?? Constant.POST,
                                                                        // functionCreate?.url ?? "",
                                                                      ));
                                                                    } else if (formMode ==
                                                                        Constant
                                                                            .editMode) {
                                                                      bloc(
                                                                          EditTemplateAttribute(
                                                                        value,
                                                                        // functionUpdate?.method ?? Constant.PUT,
                                                                        // functionUpdate?.url ?? "",
                                                                      ));
                                                                    }
                                                                  },
                                                                  onCancel: () {
                                                                    searchCo
                                                                        .clear();
                                                                    searchVal =
                                                                        '';
                                                                    paging.pageNo =
                                                                        1;
                                                                    searchVal =
                                                                        "";
                                                                    setState(
                                                                        () {
                                                                      formMode =
                                                                          "";
                                                                    });
                                                                    modelSearch =
                                                                        TempAttr(
                                                                            attrCode:
                                                                                "");
                                                                    bloc(
                                                                        SearchTemplateAttr(
                                                                      modelSearch,
                                                                      paging:
                                                                          paging,
                                                                      // method: functionSearch?.method ?? Constant.GET,
                                                                      // url: functionSearch?.url ?? "",
                                                                    ));
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          } else {
                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Visibility(
                                                                  visible:
                                                                      !isMobile,
                                                                  child:
                                                                      SelectableText(
                                                                    'Search by',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          context
                                                                              .scaleFont(14),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible:
                                                                      !isMobile,
                                                                  child:
                                                                      const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 48,
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                      Visibility(
                                                                        visible:
                                                                            !isMobile,
                                                                        child:
                                                                            Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              PortalFormDropdown(
                                                                            categorySelected,
                                                                            category,
                                                                            borderColour:
                                                                                sccWhite,
                                                                            borderRadius:
                                                                                8,
                                                                            borderRadiusBotRight:
                                                                                0,
                                                                            borderRadiusTopRight:
                                                                                0,
                                                                            fillColour:
                                                                                Colors.white,
                                                                            onChange:
                                                                                (value) {
                                                                              setState(() {
                                                                                categorySelected = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            isMobile,
                                                                        child:
                                                                            InkWell(
                                                                          onTap: category.isNotEmpty
                                                                              ? () {
                                                                                  showModalBottomSheet(
                                                                                    context: context,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    // isDismissible: categorySelected != null,
                                                                                    // enableDrag: categorySelected != null,
                                                                                    builder: (context) {
                                                                                      return Container(
                                                                                        height: context.deviceHeight() * 0.8,
                                                                                        padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                                                                                        decoration: const BoxDecoration(
                                                                                          color: Colors.white,
                                                                                          borderRadius: BorderRadius.only(
                                                                                            topLeft: Radius.circular(25.0),
                                                                                            topRight: Radius.circular(25.0),
                                                                                          ),
                                                                                        ),
                                                                                        child: Container(),
                                                                                        //benerin nanti
                                                                                        //     BottomSheetOptions(
                                                                                        //   title:
                                                                                        //       'Search By',
                                                                                        //   options:
                                                                                        //       category,
                                                                                        //   value:
                                                                                        //       categorySelected,
                                                                                        //   onChanged:
                                                                                        //       (value) {
                                                                                        //     if (value != null) {
                                                                                        //       setState(() {
                                                                                        //         categorySelected = value;
                                                                                        //       });
                                                                                        //     }
                                                                                        //   },
                                                                                        // ),
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                }
                                                                              : () {},
                                                                          child:
                                                                              AspectRatio(
                                                                            aspectRatio:
                                                                                1,
                                                                            child:
                                                                                Container(
                                                                              padding: const EdgeInsets.all(12),
                                                                              decoration: BoxDecoration(
                                                                                shape: BoxShape.rectangle,
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                color: sccWhite,
                                                                              ),
                                                                              child: const GradientWidget(
                                                                                gradient: LinearGradient(
                                                                                  begin: Alignment.topCenter,
                                                                                  end: Alignment.bottomCenter,
                                                                                  colors: [
                                                                                    sccButtonLightBlue,
                                                                                    sccButtonBlue,
                                                                                  ],
                                                                                ),
                                                                                child: HeroIcon(HeroIcons.adjustmentsHorizontal
                                                                                    // size: 25,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      // const SizedBox(
                                                                      //   width: 10,
                                                                      // ),
                                                                      Expanded(
                                                                        flex: 3,
                                                                        child:
                                                                            PlainSearchField(
                                                                          controller:
                                                                              searchCo,
                                                                          hint:
                                                                              "Search here...",
                                                                          fillColor:
                                                                              sccFieldColor,
                                                                          borderRadius:
                                                                              8,
                                                                          borderRadiusTopLeft:
                                                                              0,
                                                                          borderRadiusBotLeft:
                                                                              0,
                                                                          prefix: searchCo.text.isNotEmpty
                                                                              ? IconButton(
                                                                                  // splashRadius: 0,
                                                                                  hoverColor: Colors.transparent,
                                                                                  splashColor: Colors.transparent,
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      searchCo.clear();
                                                                                      searchVal = '';
                                                                                    });

                                                                                    paging.pageNo = 1;
                                                                                    modelSearch = TempAttr(attrCode: "");
                                                                                    bloc(SearchTemplateAttr(
                                                                                      modelSearch,
                                                                                      paging: paging,
                                                                                      // method: functionSearch?.method ?? Constant.GET,
                                                                                      // url: functionSearch?.url ?? "",
                                                                                    ));
                                                                                  },
                                                                                  icon: const HeroIcon(
                                                                                    HeroIcons.xCircle,
                                                                                    color: sccText4,
                                                                                  ),
                                                                                )
                                                                              : null,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              searchVal = value?.trim();
                                                                            });
                                                                          },
                                                                          onAction:
                                                                              (value) {
                                                                            modelSearch =
                                                                                TempAttr(
                                                                              tempAttrCd: categorySelected == "TEMPLATE ATTRIBUTE CODE" ? model.tempAttrCd = value : model.tempAttrName = null,
                                                                              tempAttrName: categorySelected == "TEMPLATE ATTRIBUTE NAME" ? model.tempAttrName = value : model.tempAttrCd = null,
                                                                            );
                                                                            paging.pageNo =
                                                                                1;
                                                                            bloc(SearchTemplateAttr(
                                                                              modelSearch,
                                                                              paging: paging,
                                                                              // method: functionSearch?.method ?? Constant.GET,
                                                                              // url: functionSearch?.url ?? "",
                                                                            ));
                                                                          },
                                                                          onSearch:
                                                                              () {
                                                                            modelSearch =
                                                                                TempAttr(
                                                                              tempAttrCd: categorySelected == "TEMPLATE ATTRIBUTE CODE" ? model.tempAttrCd = searchVal : model.tempAttrName = null,
                                                                              tempAttrName: categorySelected == "TEMPLATE ATTRIBUTE NAME" ? model.tempAttrName = searchVal : model.tempAttrCd = null,
                                                                            );
                                                                            paging.pageNo =
                                                                                1;
                                                                            bloc(SearchTemplateAttr(
                                                                              modelSearch,
                                                                              paging: paging,
                                                                              // method: functionSearch?.method ?? Constant.GET,
                                                                              // url: functionSearch?.url ?? "",
                                                                            ));
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                      ),
                                                                      isMobile
                                                                          ? const SizedBox()
                                                                          : (isMobile && (premittedAdd != null || isSuperAdmin))
                                                                              ? AspectRatio(
                                                                                  aspectRatio: 1,
                                                                                  child: ButtonAddMobile(
                                                                                    borderRadius: 12,
                                                                                    onTap: () {
                                                                                      formMode = Constant.addMode;
                                                                                      bloc(ViewTemplateAttr(
                                                                                          // method: functionGet?.method ?? Constant.GET,
                                                                                          // url: functionGet?.url ?? "",
                                                                                          ));
                                                                                    },
                                                                                  ),
                                                                                )
                                                                              : Visibility(
                                                                                  visible: premittedAdd != null,
                                                                                  child: ButtonConfirmWithIcon(
                                                                                    icon: HeroIcon(
                                                                                      HeroIcons.plus,
                                                                                      color: sccWhite,
                                                                                      size: context.scaleFont(18),
                                                                                    ),
                                                                                    text: "Add New",
                                                                                    width: context.deviceWidth() * (context.isDesktop() ? 0.14 : 0.38),
                                                                                    borderRadius: 12,
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        formMode = Constant.addMode;
                                                                                      });
                                                                                      bloc(ViewTemplateAttr());
                                                                                    },
                                                                                    colour: sccNavText2,
                                                                                  ),
                                                                                )
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 16),
                                                                CommonShimmer(
                                                                  isLoading: state
                                                                      is TemplateAttributeLoading,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: isMobile &&
                                                                              state
                                                                                  is! ViewTmplAttrLoaded
                                                                          ? Colors
                                                                              .transparent
                                                                          : sccWhite,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.2),
                                                                          spreadRadius:
                                                                              1,
                                                                          blurRadius:
                                                                              2,
                                                                          offset: const Offset(
                                                                              0,
                                                                              1),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    padding: isMobile
                                                                        ? EdgeInsets
                                                                            .zero
                                                                        : const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                16,
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                'Template Attribute',
                                                                                style: TextStyle(
                                                                                  fontSize: context.scaleFont(18),
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: const Color(0xff2B2B2B),
                                                                                ),
                                                                              ),
                                                                              PagingDropdown(
                                                                                selected: (paging.pageSize ?? 0).toString(),
                                                                                onSelect: (val) {
                                                                                  if (paging.pageSize != val) {
                                                                                    setState(() {
                                                                                      paging.pageSize = val;
                                                                                    });
                                                                                    paging.pageNo = 1;
                                                                                    bloc(SearchTemplateAttr(
                                                                                      modelSearch,
                                                                                      paging: paging,
                                                                                    ));
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        searchList.isNotEmpty
                                                                            ? TmplAttrTable(
                                                                                listModel: searchList,
                                                                                model: model,
                                                                                modelSubmit: model,
                                                                                canDelete: premittedDelete != null,
                                                                                canView: true,
                                                                                canUpdate: premittedEdit != null,
                                                                                onError: (value) => tmplAttrError(value),
                                                                                onDelete: (value) {
                                                                                  showDialog(
                                                                                      context: context,
                                                                                      barrierDismissible: false,
                                                                                      builder: (context) {
                                                                                        return BlocProvider(
                                                                                          create: (context) => TemplateAttributeBloc(),
                                                                                          child: DeleteTempAttrDialog(
                                                                                            attrCode: value.tempAttrCd ?? "",
                                                                                            attrName: value.tempAttrName ?? "[undefined name]",
                                                                                            // method: functionDelete?.method ?? Constant.DELETE,
                                                                                            // url: functionDelete?.url ?? "",
                                                                                            onError: (value) {
                                                                                              tmplAttrError(value);
                                                                                            },
                                                                                            onLogout: () {
                                                                                              authBloc(AuthLogin());
                                                                                            },
                                                                                          ),
                                                                                        );
                                                                                      }).then((val) {
                                                                                    if (val == true) {
                                                                                      // searchCo.clear();
                                                                                      searchVal = '';
                                                                                      // paging.pageNo = 1;
                                                                                      // searchVal = "";
                                                                                      modelSearch = TempAttr(attrCode: "");
                                                                                      bloc(SearchTemplateAttr(
                                                                                        model,
                                                                                        paging: paging,
                                                                                      ));
                                                                                    }
                                                                                  });
                                                                                },
                                                                                onView: (value) {
                                                                                  onView(value, premittedEdit != null);
                                                                                },
                                                                                onEdit: (value) {
                                                                                  formMode = Constant.editMode;
                                                                                  // bloc(ViewTemplateAttr(
                                                                                  //     tmplAttrCd: value.tempAttrCd));
                                                                                  bloc(ViewTemplateAttr(
                                                                                      // tmplAttrCd: value.tempAttrCd)
                                                                                      model: TempAttr(tempAttrCd: value.tempAttrCd)));
                                                                                },
                                                                              )
                                                                            : const EmptyData(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 16,
                                                                ),
                                                                Visibility(
                                                                  visible: !isMobile &&
                                                                      paging.totalPages !=
                                                                          null &&
                                                                      paging.totalData !=
                                                                          null, // && state is PointDataLoaded,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      SimplePaging(
                                                                        pageNo:
                                                                            paging.pageNo!,
                                                                        pageToDisplay: isMobile
                                                                            ? 3
                                                                            : 5,
                                                                        totalPages:
                                                                            paging.totalPages,
                                                                        pageSize:
                                                                            paging.pageSize,
                                                                        totalDataInPage:
                                                                            paging.totalDataInPage,
                                                                        totalData:
                                                                            paging.totalData,
                                                                        onClick:
                                                                            (value) {
                                                                          paging.pageNo =
                                                                              value;
                                                                          bloc(
                                                                              SearchTemplateAttr(
                                                                            modelSearch,
                                                                            paging:
                                                                                paging,
                                                                          ));
                                                                        },
                                                                        onClickFirstPage:
                                                                            () {
                                                                          paging.pageNo =
                                                                              1;
                                                                          bloc(
                                                                              SearchTemplateAttr(
                                                                            modelSearch,
                                                                            paging:
                                                                                paging,
                                                                          ));
                                                                        },
                                                                        onClickPrevious:
                                                                            () {
                                                                          paging.pageNo =
                                                                              paging.pageNo! - 1;
                                                                          bloc(
                                                                              SearchTemplateAttr(
                                                                            modelSearch,
                                                                            paging:
                                                                                paging,
                                                                          ));
                                                                        },
                                                                        onClickNext:
                                                                            () {
                                                                          paging.pageNo =
                                                                              paging.pageNo! + 1;
                                                                          bloc(
                                                                              SearchTemplateAttr(
                                                                            modelSearch,
                                                                            paging:
                                                                                paging,
                                                                          ));
                                                                        },
                                                                        onClickLastPage:
                                                                            () {
                                                                          paging.pageNo =
                                                                              paging.totalPages;
                                                                          bloc(
                                                                              SearchTemplateAttr(
                                                                            modelSearch,
                                                                            paging:
                                                                                paging,
                                                                          ));
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          }
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
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
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
