import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/master_supplier/bloc/master_supplier_bloc.dart';
import 'package:scc_web/bloc/permitted_feat/bloc/permitted_feat_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/countries.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/master_supplier.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permitted_func_feat.dart';
import 'package:scc_web/screens/master_supplier/DeleteMstSupplierDialog.dart';
import 'package:scc_web/screens/master_supplier/master_supplier_form.dart';
import 'package:scc_web/screens/master_supplier/master_supplier_table.dart';
import 'package:scc_web/screens/master_supplier/search_by_bottom_sheet.dart';
import 'package:scc_web/screens/master_supplier/view_dialog_supplier.dart';
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
import 'package:scc_web/theme/padding.dart';

import '../../shared_widgets/buttons.dart';
import '../../theme/colors.dart';

class MasterSupplierScreen extends StatefulWidget {
  const MasterSupplierScreen({super.key});

  @override
  State<MasterSupplierScreen> createState() => _MasterSupplierScreenState();
}

class _MasterSupplierScreenState extends State<MasterSupplierScreen> {
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
          selectedTile: Constant.supplier,
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
            create: (context) => MasterSupplierBloc()
              ..add(
                SearchMstSupplier(
                  model: Supplier(),
                  paging: Paging(pageNo: 1, pageSize: 5),
                ),
              ),
          ),
          BlocProvider(
            create: (context) => PermittedFeatBloc()
              ..add(
                GetPermitted(Constant.supplier),
              ),
          )
        ],
        child: const MasterSupplierBody(),
      )),
    );
  }
}

class MasterSupplierBody extends StatefulWidget {
  const MasterSupplierBody({super.key});

  @override
  State<MasterSupplierBody> createState() => _MasterSupplierBodyState();
}

class _MasterSupplierBodyState extends State<MasterSupplierBody> {
  late TextEditingController searchCo;
  final pointScroll = ScrollController();
  bool expandNavBar = true;
  bool showNavBar = true;
  String formMode = "";
  // String? searchBySelected;
  String? searchVal;
  List<KeyVal> searchByList = [
    KeyVal("All", ""),
    KeyVal("Supplier Name", Constant.supplierName),
    KeyVal("Supplier Type", Constant.supplierTypeCd),
  ];
  List<Countries> listCountryDrpdwn = [];

  bool shwBtnBack = false;
  KeyVal? searchBySelected;
  List<KeyVal> searchCat = [];
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  List<Supplier> listSupplier = [];
  Supplier modelSearch = Supplier(supplierName: "");
  Login? login;
  PermittedFunc? permitted;
  FeatureList? premittedAdd;
  FeatureList? premittedView;
  FeatureList? premittedEdit;
  FeatureList? premittedDelete;
  bool isSuperAdmin = false;

  @override
  void initState() {
    searchCo = TextEditingController();
    // searchCat.add(
    //   KeyVal("ALL", ""),
    // );
    searchCat.add(
      KeyVal("Supplier Name", Constant.supplierName),
    );
    searchCat.add(
      KeyVal("Supplier Code", Constant.supplierCode),
    );
    searchCat.add(
      KeyVal("Type Of Supplier", Constant.supplierTypeCd),
    );
    searchBySelected = searchCat[0];

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

    bloc(MasterSupplierEvent event) {
      BlocProvider.of<MasterSupplierBloc>(context).add(event);
    }

    supplierFailed(String? msg) {
      showTopSnackBar(
          context, UpperSnackBar.error(message: msg ?? "Error occured"));
    }

    onSearch(String? value) {
      modelSearch = Supplier(
        supplierCd: searchBySelected?.value == Constant.supplierCode
            ? (value ?? "").trim()
            : null,
        supplierName: searchBySelected?.value == Constant.supplierName
            ? (value ?? "").trim()
            : null,
        supplierTypeCd: searchBySelected?.value == Constant.supplierTypeCd
            ? (value ?? "").trim()
            : null,
      );
      paging.pageNo = 1;
      bloc(SearchMstSupplier(model: modelSearch, paging: paging));
    }

    // showDialogAddFinish(String? val) {
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AddFinishDialog(
    //         val: val,
    //         onTap: () {
    //           context.back();
    //         },
    //         title:
    //             'Suppliet Successfully ${formMode == Constant.addMode ? "Added" : "Edited"}',
    //       );
    //     },
    //   );
    // }

    onEdit(Supplier value) {
      setState(() {
        formMode = Constant.editMode;
      });
      bloc(ToMstSupplierForm(model: Supplier(supplierCd: value.supplierCd)));
    }

    onView(Supplier value, bool canUpdate) {
      showDialog(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (context) =>
                  MasterSupplierBloc()..add(ToMstSupplierForm(model: value)),
              child: ViewDialogSupplier(
                onEdit: () {
                  context.back();
                  onEdit(value);
                },
                canUpdate: canUpdate,
              ),
            );
          });
    }

    return Column(
      children: [
        BlocProvider(
          create: (context) => ProfileBloc()..add(GetProfileData()),
          child: CustomAppBar(
            menuTitle: "Supplier",
            menuName: "Master Supplier",
            formMode: formMode,
            onClick: () {
              onSearch(searchVal);
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
                    selectedTile: Constant.supplier,
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
                                MasterSupplierError(state.error);
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
                          BlocListener<MasterSupplierBloc, MasterSupplierState>(
                            listener: (context, state) {
                              if (state is MasterSupplierError) {
                                showTopSnackBar(context,
                                    UpperSnackBar.error(message: state.msg));
                                setState(() {
                                  formMode = "";
                                });
                              }
                              if (state is LoadTable) {
                                if (state.paging != null) {
                                  paging = state.paging!;
                                }
                                listSupplier.clear();
                                listSupplier.addAll(state.listSupplier);
                              }
                              if (state is OnLogoutMasterSupplier) {
                                authBloc(AuthLogin());
                              }
                              if (state is LoadForm) {
                                listCountryDrpdwn.clear();
                                listCountryDrpdwn = state.listCountry;
                                // for (var e in state.listCountry) {
                                //   listCountryDrpdwn
                                //       .add(KeyVal(e.label, e.value.toString()));
                                // }
                              }
                              if (state is MstSupplierAdd) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) {
                                    return SuccessDialog(
                                      title:
                                          "Master Supplier Successfully Added",
                                      msg: state.msg,
                                      buttonText: "OK",
                                      onTap: () => context.back(),
                                    );
                                  },
                                ).then((value) {
                                  searchCo.clear();
                                  searchVal = '';
                                  paging.pageNo = 1;
                                  setState(() {
                                    formMode = "";
                                  });
                                  bloc(SearchMstSupplier(
                                      model: modelSearch, paging: paging));
                                });
                              }
                              if (state is MstSupplierEdit) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) {
                                    return SuccessDialog(
                                      title:
                                          "Master Supplier Successfully Updated",
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
                                  bloc(SearchMstSupplier(
                                      model: modelSearch, paging: paging));
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
                                bloc(SearchMstSupplier(
                                    model: modelSearch,
                                    paging: Paging(pageNo: 1, pageSize: 5)));
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
                          )
                        ],
                        child: Column(
                          children: [
                            Expanded(
                              child: BlocBuilder<MasterSupplierBloc,
                                  MasterSupplierState>(
                                builder: (context, state) {
                                  return Scrollbar(
                                    controller: pointScroll,
                                    child: SingleChildScrollView(
                                      controller: pointScroll,
                                      padding: sccOutterPadding,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Builder(builder: (context) {
                                            if (state is LoadForm) {
                                              return Column(
                                                children: [
                                                  SupplierFormAddEdit(
                                                    formMode: formMode,
                                                    model: state.submitSupplier,
                                                    listCountryDrpdwnForm:
                                                        listCountryDrpdwn,
                                                    listSupplierType:
                                                        state.listSysMaster,
                                                    onClose: () {
                                                      searchCo.clear();
                                                      searchVal = '';
                                                      paging.pageNo = 1;
                                                      searchVal = "";
                                                      setState(() {
                                                        formMode = "";
                                                      });
                                                      bloc(SearchMstSupplier(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                    onSuccesSubmit: (value) {
                                                      if (formMode ==
                                                          Constant.addMode) {
                                                        bloc(SubmitMstSupplier(
                                                            value));
                                                      } else if (formMode ==
                                                          Constant.editMode) {
                                                        {
                                                          bloc(EditMstSupplier(
                                                              value));
                                                        }
                                                      }
                                                    },
                                                    // paging: paging,
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: context
                                                                  .deviceWidth() *
                                                              0.1,
                                                          child: SelectableText(
                                                            'Search by',
                                                            style: TextStyle(
                                                              fontSize: context
                                                                  .scaleFont(
                                                                      14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
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
                                                  SizedBox(
                                                    height: isMobile ? 50 : 48,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Visibility(
                                                          visible: !isMobile,
                                                          child: SizedBox(
                                                            width: 230,
                                                            child:
                                                                PortalFormDropdownKeyVal(
                                                              searchBySelected,
                                                              searchCat,
                                                              enabled: searchCat
                                                                  .isNotEmpty,
                                                              fillColour:
                                                                  Colors.white,
                                                              // fontWeight: FontWeight.normal,
                                                              borderRadius: 8,
                                                              borderRadiusBotRight:
                                                                  0,
                                                              borderRadiusTopRight:
                                                                  0,
                                                              borderColor:
                                                                  sccWhite,
                                                              onChange:
                                                                  (value) {
                                                                setState(() {
                                                                  searchBySelected =
                                                                      value;
                                                                });
                                                              },
                                                            ),
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
                                                                        searchBySelected !=
                                                                            null,
                                                                    isScrollControlled:
                                                                        true,
                                                                    builder:
                                                                        (context) {
                                                                      return SearchByBottomSheet(
                                                                        searchByChange:
                                                                            (KeyVal?
                                                                                val) {},
                                                                        selectedSearchBy:
                                                                            searchBySelected,
                                                                        searchByList:
                                                                            searchCat,
                                                                      );
                                                                    },
                                                                  );
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
                                                                            .adjustmentsVertical,
                                                                        // size: 25,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox(
                                                                // width: 10,
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
                                                            fillColor:
                                                                sccFieldColor,
                                                            hint:
                                                                'Search ${searchBySelected!.label} here...',
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
                                                                      paging.pageNo =
                                                                          1;
                                                                      searchCo
                                                                          .clear();
                                                                      searchVal =
                                                                          '';
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
                                                                    value?.trim() ??
                                                                        "";
                                                              });
                                                            },
                                                            borderRadius: 8,
                                                            borderRadiusTopLeft:
                                                                0,
                                                            borderRadiusBotLeft:
                                                                0,
                                                            suffixSize: 48,
                                                            onAction: (value) {
                                                              onSearch(
                                                                  searchVal);
                                                            },
                                                            onSearch: () {
                                                              onSearch(
                                                                  searchVal);
                                                            },
                                                          ),
                                                        ),
                                                        const Expanded(
                                                          flex: 4,
                                                          child: SizedBox(),
                                                        ),
                                                        // ),
                                                        (premittedAdd != null ||
                                                                isSuperAdmin)
                                                            ? Expanded(
                                                                flex: 2,
                                                                child:
                                                                    ButtonConfirmWithIcon(
                                                                  icon:
                                                                      HeroIcon(
                                                                    HeroIcons
                                                                        .plus,
                                                                    color:
                                                                        sccWhite,
                                                                    size: context
                                                                        .scaleFont(
                                                                            14),
                                                                  ),
                                                                  colour:
                                                                      sccNavText2,
                                                                  text:
                                                                      "Add New",
                                                                  width: context
                                                                          .deviceWidth() *
                                                                      (context.isDesktop()
                                                                          ? 0.13
                                                                          : 0.35),
                                                                  borderRadius:
                                                                      12,
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      formMode =
                                                                          Constant
                                                                              .addMode;
                                                                    });
                                                                    bloc(
                                                                        ToMstSupplierForm());
                                                                  },
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
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  CommonShimmer(
                                                    isLoading: state
                                                        is MasterSupplierLoading,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: isMobile
                                                            ? Colors.transparent
                                                            : sccWhite,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
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
                                                              vertical: 16,
                                                            ),
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
                                                                  'Supplier',
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
                                                                      paging.pageNo =
                                                                          1;
                                                                      bloc(SearchMstSupplier(
                                                                          model:
                                                                              modelSearch,
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
                                                          listSupplier
                                                                  .isNotEmpty
                                                              ? MasterSupplierTable(
                                                                  canView: true,
                                                                  canUpdate:
                                                                      premittedEdit !=
                                                                          null,
                                                                  canDelete:
                                                                      premittedDelete !=
                                                                          null,
                                                                  listSupplier:
                                                                      listSupplier,
                                                                  onEdit:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      formMode =
                                                                          Constant
                                                                              .editMode;
                                                                    });

                                                                    bloc(ToMstSupplierForm(
                                                                        model: Supplier(
                                                                            supplierCd:
                                                                                value.supplierCd)));
                                                                  },
                                                                  onView:
                                                                      (value) {
                                                                    onView(
                                                                      value,
                                                                      premittedEdit !=
                                                                          null,
                                                                    );
                                                                  },
                                                                  onDelete:
                                                                      (value) {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (contex) {
                                                                        return BlocProvider(
                                                                          create: (context) =>
                                                                              MasterSupplierBloc(),
                                                                          child:
                                                                              DeleteMstSupplier(
                                                                            supplierCd:
                                                                                value.supplierCd ?? "",
                                                                            supplierName:
                                                                                value.supplierName ?? "",
                                                                            onError:
                                                                                (value) {
                                                                              supplierFailed(value);
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
                                                                      searchCo
                                                                          .clear();
                                                                      searchVal =
                                                                          '';
                                                                      paging.pageNo =
                                                                          1;
                                                                      searchVal =
                                                                          "";
                                                                      bloc(SearchMstSupplier(
                                                                          model:
                                                                              modelSearch,
                                                                          paging:
                                                                              paging));
                                                                    });
                                                                  },
                                                                )
                                                              : const EmptyData(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Visibility(
                                                    visible: !isMobile &&
                                                        paging.totalPages !=
                                                            null &&
                                                        paging.totalData !=
                                                            null,
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
                                                            bloc(SearchMstSupplier(
                                                                model:
                                                                    modelSearch,
                                                                paging:
                                                                    paging));
                                                          },
                                                          onClickFirstPage: () {
                                                            paging.pageNo = 1;
                                                            bloc(SearchMstSupplier(
                                                                model:
                                                                    modelSearch,
                                                                paging:
                                                                    paging));
                                                          },
                                                          onClickPrevious: () {
                                                            paging.pageNo =
                                                                paging.pageNo! -
                                                                    1;
                                                            bloc(SearchMstSupplier(
                                                                model:
                                                                    modelSearch,
                                                                paging:
                                                                    paging));
                                                          },
                                                          onClickNext: () {
                                                            paging.pageNo =
                                                                paging.pageNo! +
                                                                    1;
                                                            bloc(SearchMstSupplier(
                                                                model:
                                                                    modelSearch,
                                                                paging:
                                                                    paging));
                                                          },
                                                          onClickLastPage: () {
                                                            paging.pageNo =
                                                                paging
                                                                    .totalPages;
                                                            bloc(SearchMstSupplier(
                                                                model:
                                                                    modelSearch,
                                                                paging:
                                                                    paging));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Column(
                                                  //   children: [
                                                  //     PagingRows(
                                                  //       pageNo: paging.pageNo!,
                                                  //       pageToDisplay:
                                                  //           isMobile ? 3 : 5,
                                                  //       totalPages: paging.totalPages,
                                                  //       pageSize: paging.pageSize,
                                                  //       totalDataInPage:
                                                  //           paging.totalDataInPage,
                                                  //       totalData: paging.totalData,
                                                  //       onClick: (value) {
                                                  //         paging.pageNo = value;
                                                  //         bloc(SearchMstSupplier(
                                                  //             model: modelSearch,
                                                  //             paging: paging));
                                                  //       },
                                                  //       onClickFirstPage: () {
                                                  //         paging.pageNo = 1;
                                                  //         bloc(SearchMstSupplier(
                                                  //             model: modelSearch,
                                                  //             paging: paging));
                                                  //       },
                                                  //       onClickPrevious: () {
                                                  //         paging.pageNo =
                                                  //             paging.pageNo! - 1;
                                                  //         bloc(SearchMstSupplier(
                                                  //             model: modelSearch,
                                                  //             paging: paging));
                                                  //       },
                                                  //       onClickNext: () {
                                                  //         paging.pageNo =
                                                  //             paging.pageNo! + 1;
                                                  //         bloc(SearchMstSupplier(
                                                  //             model: modelSearch,
                                                  //             paging: paging));
                                                  //       },
                                                  //       onClickLastPage: () {
                                                  //         paging.pageNo =
                                                  //             paging.totalPages;
                                                  //         bloc(SearchMstSupplier(
                                                  //             model: modelSearch,
                                                  //             paging: paging));
                                                  //       },
                                                  //       selected:
                                                  //           (paging.pageSize ?? 0)
                                                  //               .toString(),
                                                  //       onSelect: (val) {
                                                  //         if (paging.pageSize !=
                                                  //             val) {
                                                  //           setState(() {
                                                  //             paging.pageSize = val;
                                                  //           });
                                                  //           paging.pageNo =
                                                  //               paging.pageNo! - 1;
                                                  //           paging.pageNo = 1;
                                                  //           bloc(SearchMstSupplier(
                                                  //               model: modelSearch,
                                                  //               paging: paging));
                                                  //         }
                                                  //       },
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  const SizedBox(
                                                    height: 24,
                                                  ),
                                                ],
                                              );
                                            }
                                          }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
