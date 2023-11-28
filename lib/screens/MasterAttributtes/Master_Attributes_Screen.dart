// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/mst_attr/bloc/mst_attr_bloc.dart';
import 'package:scc_web/bloc/permitted_feat/bloc/permitted_feat_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/master_attribute.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permitted_func_feat.dart';
import 'package:scc_web/screens/MasterAttributtes/Master_attribute_form.dart';
import 'package:scc_web/screens/MasterAttributtes/delete_mst_attribute_dialog.dart';
import 'package:scc_web/screens/MasterAttributtes/table_mst_attribute.dart';
import 'package:scc_web/screens/MasterAttributtes/view_dialog_attribute.dart';
import 'package:scc_web/shared_widgets/add_finish_dialog.dart';
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
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';

import '../../shared_widgets/vcc_paging_dropdown.dart';

class MasterAttributesScreen extends StatefulWidget {
  const MasterAttributesScreen({super.key});

  @override
  State<MasterAttributesScreen> createState() => _MasterAttributesScreenState();
}

class _MasterAttributesScreenState extends State<MasterAttributesScreen> {
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
          selectedTile: Constant.MST_ATTRIBUTE,
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
              create: (context) => MstAttrBloc()
                ..add(SearchMstAttr(
                  paging: Paging(pageNo: 1, pageSize: 5),
                  model: MstAttribute(attributeCd: ''),
                )),
            ),
            BlocProvider(
              create: (context) => PermittedFeatBloc()
                ..add(
                  GetPermitted(Constant.MST_ATTRIBUTE),
                ),
            )
          ],
          child: const MasterAttributesBody(),
        ),
      ),
    );
  }
}

class MasterAttributesBody extends StatefulWidget {
  const MasterAttributesBody({Key? key}) : super(key: key);

  @override
  State<MasterAttributesBody> createState() => _MasterAttributesBodyState();
}

class _MasterAttributesBodyState extends State<MasterAttributesBody> {
  final controller = ScrollController();
  Login? login;
  late TextEditingController searchCo;
  String? searchVal;
  String formMode = "";
  List<KeyVal> searchCat = [];
  String? searchCatSelected;
  List<MstAttribute> listModel = [];
  MstAttribute modelSearch = MstAttribute(attributeName: '');
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  double offset = 0.0;
  List<Menu> listMenu = [];

  PermittedFunc? permitted;
  FeatureList? premittedAdd;
  FeatureList? premittedView;
  FeatureList? premittedEdit;
  FeatureList? premittedDelete;
  bool isSuperAdmin = false;
  bool expandNavBar = true;
  bool showNavBar = true;
  bool shwBtnBack = false;

  showDialogAddFinish(String? val) {
    showDialog(
      context: context,
      builder: (context) {
        return AddFinishDialog(
          val: val,
          onTap: () {
            context.back();
          },
          title: val,
        );
      },
    );
  }

  @override
  void initState() {
    searchCo = TextEditingController();

    // formMode = Constant.addMode;

    searchCat.add(
      KeyVal("Attribute Name", Constant.attributeName),
    );
    searchCat.add(
      KeyVal("Attribute Code", Constant.attributeCd),
    );
    searchCat.add(
      KeyVal("Attribute Type Code", Constant.attributeTypeCd),
    );
    searchCatSelected = searchCat[0].value;
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    bloc(MstAttrEvent event) {
      BlocProvider.of<MstAttrBloc>(context).add(event);
    }

    homeBloc(HomeEvent event) {
      BlocProvider.of<HomeBloc>(context).add(event);
    }

    onSearch(Paging paging, MstAttribute model) {
      bloc(SearchMstAttr(
        paging: paging,
        model: model,
      ));
    }

    onEdit(MstAttribute value) {
      setState(() {
        formMode = Constant.editMode;
      });
      bloc(ToMstAttrForm(model: MstAttribute(attributeCd: value.attributeCd)));
    }

    onView(MstAttribute value, bool canUpdate) {
      showDialog(
        context: context,
        builder: (context) {
          return BlocProvider(
            create: (context) =>
                MstAttrBloc()..add(ToMstAttrForm(model: value)),
            // child: Container(),
            child: ViewDialogAttribute(
              onEdit: () {
                context.back();
                onEdit(value);
              },
              canUpdate: canUpdate,
            ),
          );
        },
      );
    }

    return Column(
      children: [
        BlocProvider(
          create: (context) => ProfileBloc()..add(GetProfileData()),
          child: CustomAppBar(
            menuTitle: "Attributes",
            menuName: "Master Attributes",
            formMode: formMode,
            onClick: () {
              onSearch(paging, modelSearch);
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
                    selectedTile: Constant.MST_ATTRIBUTE,
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
                      child: SizedBox(
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
                                  MstAttrError(state.error);
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
                            BlocListener<MstAttrBloc, MstAttrState>(
                              listener: (context, state) {
                                if (state is MstAttrError) {
                                  showTopSnackBar(
                                      context,
                                      UpperSnackBar.error(
                                          message: state.error));
                                  setState(() {
                                    formMode = "";
                                  });
                                }

                                if (state is MstAttrSubmitted) {
                                  showTopSnackBar(
                                    context,
                                    UpperSnackBar.success(message: state.msg),
                                  );
                                  if (state.paging != null) {
                                    paging = state.paging!;
                                  }
                                  listModel.clear();
                                  listModel.addAll(state.listModel);
                                  setState(() {
                                    formMode = "";
                                  });
                                }
                                if (state is LoadForm) {
                                  setState(() {
                                    // shwBtnBack = !shwBtnBack;
                                  });
                                }
                                if (state is LoadTable) {
                                  if (state.paging != null) {
                                    paging = state.paging!;
                                  }
                                  listModel.clear();
                                  listModel.addAll(state.listModel);
                                  // setState(() {
                                  //   shwBtnBack = !shwBtnBack;
                                  // });
                                }
                                if (state is OnLogoutMstAttr) {
                                  authBloc(AuthLogin());
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
                                      ?.firstWhere((e) =>
                                          e.featureCd == Constant.F_EDIT);
                                  premittedDelete = permitted?.featureList
                                      ?.firstWhere((e) =>
                                          e.featureCd == Constant.F_DELETE);
                                  isSuperAdmin =
                                      (permitted?.superAdmin ?? false);
                                  bloc(SearchMstAttr(
                                    paging: Paging(pageNo: 1, pageSize: 5),
                                    model: MstAttribute(attributeCd: ''),
                                  ));
                                }
                                if (state is PermittedFeatError) {
                                  showTopSnackBar(
                                      context,
                                      UpperSnackBar.error(
                                          message: state.errMsg));
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
                                        BlocBuilder<MstAttrBloc, MstAttrState>(
                                          builder: (context, state) {
                                            if (state is LoadForm) {
                                              return Column(
                                                children: [
                                                  MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider(
                                                        create: (context) =>
                                                            AuthBloc(),
                                                      ),
                                                      BlocProvider(
                                                          create: (context) =>
                                                              MstAttrBloc()),
                                                    ],
                                                    child: MstAttrForm(
                                                        listAttrType:
                                                            state.listAttrType,
                                                        listAttrDataType: state
                                                            .listAttrDataType,
                                                        model:
                                                            state.submitModel,
                                                        formMode: formMode,
                                                        paging: paging,
                                                        onSuccesSubmit:
                                                            (value) {
                                                          searchCo.clear();
                                                          searchVal = '';
                                                          modelSearch =
                                                              MstAttribute(
                                                                  attributeCd:
                                                                      "");
                                                          searchVal = "";

                                                          showDialogAddFinish(
                                                              value.msg);
                                                          if (value.paging !=
                                                              null) {
                                                            paging =
                                                                value.paging!;
                                                          }
                                                          if (formMode ==
                                                              Constant
                                                                  .addMode) {
                                                            paging.pageNo = 1;
                                                          }
                                                          onSearch(paging,
                                                              modelSearch);
                                                          listModel.clear();
                                                          listModel.addAll(
                                                              value.listModel);
                                                          setState(() {
                                                            formMode = "";
                                                          });
                                                        },
                                                        onClose: () {
                                                          paging.pageNo = 1;
                                                          searchCo.clear();
                                                          searchVal = '';
                                                          modelSearch =
                                                              MstAttribute(
                                                                  attributeCd:
                                                                      "");
                                                          searchVal = "";
                                                          setState(() {
                                                            formMode = "";
                                                          });
                                                          onSearch(paging,
                                                              modelSearch);
                                                        }),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Visibility(
                                                    visible: !isMobile,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8,
                                                                left: 4),
                                                        child: Text(
                                                          'Search by ',
                                                          style: TextStyle(
                                                              fontSize: context
                                                                  .scaleFont(
                                                                      14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: !isMobile,
                                                    child: const SizedBox(
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
                                                        isMobile
                                                            ? InkWell(
                                                                onTap: () {
                                                                  // showModalBottomSheet(
                                                                  //   context: context,
                                                                  //   backgroundColor:
                                                                  //       Colors
                                                                  //           .transparent,
                                                                  //   isDismissible:
                                                                  //       true,
                                                                  //   enableDrag: true,
                                                                  //   builder:
                                                                  //       (context) {
                                                                  //     return SearchMstrPartBottomSheet(
                                                                  //       searchByChange:
                                                                  //           (KeyVal?
                                                                  //               val) {
                                                                  //         searchCatSelected =
                                                                  //             val!;
                                                                  //       },
                                                                  //       searchByList:
                                                                  //           searchCat,
                                                                  //       selectedSearchBy:
                                                                  //           searchCatSelected,
                                                                  //     );
                                                                  //   },
                                                                  // );
                                                                },
                                                                child:
                                                                    AspectRatio(
                                                                  aspectRatio:
                                                                      1,
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            12),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
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
                                                                            .adjustmentsHorizontal,
                                                                        // size: 25,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Expanded(
                                                                flex: 2,
                                                                child:
                                                                    PortalFormDropdown(
                                                                  searchCatSelected,
                                                                  searchCat,
                                                                  borderRadius:
                                                                      8,
                                                                  borderRadiusBotRight:
                                                                      0,
                                                                  borderRadiusTopRight:
                                                                      0,
                                                                  borderColour:
                                                                      sccWhite,
                                                                  enabled: searchCat
                                                                          .length >
                                                                      1,
                                                                  onChange:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      searchCatSelected =
                                                                          value;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                        // const SizedBox(
                                                        //   width: 10,
                                                        // ),
                                                        Expanded(
                                                          flex: 3,
                                                          child:
                                                              PlainSearchField(
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
                                                                        searchVal =
                                                                            "";
                                                                        searchCo
                                                                            .clear();
                                                                        searchVal =
                                                                            '';
                                                                      });
                                                                      if (searchVal
                                                                              ?.trim() ==
                                                                          "") {
                                                                        paging.pageNo =
                                                                            1;
                                                                        searchCo
                                                                            .clear();
                                                                        searchVal =
                                                                            '';
                                                                        modelSearch =
                                                                            MstAttribute(attributeCd: "");
                                                                        onSearch(
                                                                            paging,
                                                                            modelSearch);
                                                                      }
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
                                                                searchVal = value
                                                                    ?.trim();
                                                              });
                                                            },
                                                            onAction: (value) {
                                                              paging.pageNo = 1;
                                                              modelSearch = MstAttribute(
                                                                  attributeCd: searchCatSelected ==
                                                                          Constant
                                                                              .attributeCd
                                                                      ? value
                                                                      : null,
                                                                  attributeName:
                                                                      searchCatSelected == Constant.attributeName
                                                                          ? value
                                                                          : null,
                                                                  attrTypeCd: searchCatSelected ==
                                                                          Constant
                                                                              .attributeTypeCd
                                                                      ? value
                                                                      : null);

                                                              onSearch(paging,
                                                                  modelSearch);
                                                            },
                                                            onSearch: () {
                                                              paging.pageNo = 1;
                                                              modelSearch =
                                                                  MstAttribute(
                                                                attributeCd: searchCatSelected ==
                                                                        Constant
                                                                            .attributeCd
                                                                    ? searchVal
                                                                    : null,
                                                                attributeName:
                                                                    searchCatSelected ==
                                                                            Constant.attributeName
                                                                        ? searchVal
                                                                        : null,
                                                                attrTypeCd: searchCatSelected ==
                                                                        Constant
                                                                            .attributeTypeCd
                                                                    ? searchVal
                                                                    : null,
                                                              );
                                                              onSearch(paging,
                                                                  modelSearch);
                                                            },
                                                          ),
                                                        ),
                                                        const Expanded(
                                                          flex: 4,
                                                          child: SizedBox(
                                                            width: 10,
                                                          ),
                                                        ),
                                                        (isMobile &&
                                                                premittedAdd ==
                                                                    null &&
                                                                !isSuperAdmin)
                                                            ? const SizedBox()
                                                            : (isMobile &&
                                                                    (premittedAdd !=
                                                                            null ||
                                                                        isSuperAdmin))
                                                                ? ButtonAddIcon(
                                                                    onTap:
                                                                        // premittedAdd != null || isSuperAdmin
                                                                        //     ?
                                                                        () {
                                                                      if (premittedAdd !=
                                                                          null) {
                                                                        setState(
                                                                            () {
                                                                          formMode =
                                                                              Constant.addMode;
                                                                        });
                                                                        bloc(ToMstAttrForm(
                                                                            // getMethod: functionGet?.method ?? Constant.GET,
                                                                            // getUrl: functionGet?.url ?? "",
                                                                            ));
                                                                      }
                                                                    }
                                                                    // : null
                                                                    ,
                                                                  )
                                                                : Visibility(
                                                                    visible:
                                                                        premittedAdd !=
                                                                            null,
                                                                    child:
                                                                        ButtonConfirmWithIcon(
                                                                      icon:
                                                                          HeroIcon(
                                                                        HeroIcons
                                                                            .plus,
                                                                        color:
                                                                            sccWhite,
                                                                        size: context
                                                                            .scaleFont(14),
                                                                      ),
                                                                      text:
                                                                          "Add New",
                                                                      borderRadius:
                                                                          12,
                                                                      width: context
                                                                              .deviceWidth() *
                                                                          (context.isDesktop()
                                                                              ? 0.14
                                                                              : 0.38),
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          formMode =
                                                                              Constant.addMode;
                                                                        });
                                                                        bloc(ToMstAttrForm(
                                                                            // method: functionGet?.method ?? Constant.GET,
                                                                            // url: functionGet?.url ?? "",
                                                                            ));
                                                                      },
                                                                      colour:
                                                                          sccNavText2,
                                                                    ),
                                                                  ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  CommonShimmer(
                                                    isLoading:
                                                        state is MstAttrLoading,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: isMobile
                                                            ? Colors.transparent
                                                            : sccWhite,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 2,
                                                            offset:
                                                                const Offset(
                                                                    0, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      padding: isMobile
                                                          ? EdgeInsets.zero
                                                          : const EdgeInsets
                                                              .symmetric(
                                                              vertical: 8,
                                                            ),
                                                      child: Column(
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
                                                                  'Attribute',
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
                                                                          1;

                                                                      onSearch(
                                                                          paging,
                                                                          modelSearch);
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          listModel.isNotEmpty
                                                              ? MstAttrTable(
                                                                  listModel:
                                                                      listModel,
                                                                  canDelete: (premittedDelete !=
                                                                          null ||
                                                                      isSuperAdmin),
                                                                  canView: true,
                                                                  canUpdate: premittedEdit !=
                                                                          null ||
                                                                      isSuperAdmin,
                                                                  onDelete:
                                                                      (value) {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (ctx) {
                                                                        return BlocProvider(
                                                                          create: (context) =>
                                                                              MstAttrBloc(),
                                                                          child:
                                                                              DeleteMstAttrDialog(
                                                                            attributeCd:
                                                                                value.attributeCd ?? "",
                                                                            attributeName:
                                                                                value.attributeName ?? "[undefined wf name]",
                                                                            // method: functionDelete?.method ?? Constant.DELETE,
                                                                            // url: functionDelete?.url ?? "",
                                                                            onError:
                                                                                (value) {
                                                                              showTopSnackBar(context, UpperSnackBar.error(message: value));
                                                                            },
                                                                            onLogout:
                                                                                () {
                                                                              authBloc(AuthLogin());
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then(
                                                                        (val) {
                                                                      if (val !=
                                                                              null &&
                                                                          val is bool &&
                                                                          val) {
                                                                        paging.pageNo =
                                                                            1;
                                                                        searchCo
                                                                            .clear();
                                                                        searchVal =
                                                                            '';
                                                                        modelSearch =
                                                                            MstAttribute(attributeCd: "");
                                                                        searchVal =
                                                                            "";
                                                                        onSearch(
                                                                            paging,
                                                                            modelSearch);
                                                                      }
                                                                    });
                                                                  },
                                                                  onEdit:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      formMode =
                                                                          Constant
                                                                              .editMode;
                                                                    });
                                                                    bloc(
                                                                        ToMstAttrForm(
                                                                      model: MstAttribute(
                                                                          attributeCd:
                                                                              value.attributeCd),
                                                                    ));
                                                                  },
                                                                  onView:
                                                                      (value) {
                                                                    onView(
                                                                        value,
                                                                        premittedEdit !=
                                                                            null);
                                                                    // setState(() {
                                                                    //   formMode =
                                                                    //       Constant
                                                                    //           .viewMode;
                                                                    // });
                                                                    // bloc(
                                                                    //     ToMstAttrForm(
                                                                    //   attributeCd: value
                                                                    //       .attributeCd,
                                                                    //   // getMethod: functionGet?.method ?? Constant.GET,
                                                                    //   // getUrl: functionGet?.url ?? "",
                                                                    // ));
                                                                  },
                                                                )
                                                              : const EmptyData(),
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
                                        BlocBuilder<MstAttrBloc, MstAttrState>(
                                          builder: (context, state) {
                                            return Visibility(
                                              visible: !isMobile &&
                                                  paging.totalPages != null &&
                                                  paging.totalData != null &&
                                                  state is LoadTable,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SimplePaging(
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
                                                      onSearch(
                                                          paging, modelSearch);
                                                    },
                                                    onClickFirstPage: () {
                                                      paging.pageNo = 1;
                                                      onSearch(
                                                          paging, modelSearch);
                                                    },
                                                    onClickPrevious: () {
                                                      paging.pageNo =
                                                          paging.pageNo! - 1;
                                                      onSearch(
                                                          paging, modelSearch);
                                                    },
                                                    onClickNext: () {
                                                      paging.pageNo =
                                                          paging.pageNo! + 1;
                                                      onSearch(
                                                          paging, modelSearch);
                                                    },
                                                    onClickLastPage: () {
                                                      paging.pageNo =
                                                          paging.totalPages;
                                                      onSearch(
                                                          paging, modelSearch);
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 24,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
