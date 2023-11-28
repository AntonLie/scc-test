import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/master_product/bloc/master_product_bloc.dart';
import 'package:scc_web/bloc/permitted_feat/bloc/permitted_feat_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/master_product.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permitted_func_feat.dart';
import 'package:scc_web/screens/master_product/delete_master_product.dart';
import 'package:scc_web/screens/master_product/master_product_form.dart';
import 'package:scc_web/screens/master_product/master_product_table.dart';
import 'package:scc_web/screens/master_product/view_dialog_product.dart';
import 'package:scc_web/screens/master_supplier/search_by_bottom_sheet.dart';
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

class MasterProductScreen extends StatefulWidget {
  const MasterProductScreen({super.key});

  @override
  State<MasterProductScreen> createState() => _MasterProductScreenState();
}

class _MasterProductScreenState extends State<MasterProductScreen> {
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
        // child: Container(),
        child: const PersistDrawer(
          initiallyExpanded: true,
          selectedTile: Constant.mstProduct,
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
            create: (context) => MasterProductBloc()
              ..add(GetProductData(
                  model: MasterProductModel(),
                  paging: Paging(pageNo: 1, pageSize: 5))),
          ),
          BlocProvider(
            create: (context) => PermittedFeatBloc()
              ..add(
                GetPermitted(Constant.mstProduct),
              ),
          )
        ],
        child: const MasterProductBody(),
      )),
    );
  }
}

class MasterProductBody extends StatefulWidget {
  const MasterProductBody({super.key});

  @override
  State<MasterProductBody> createState() => _MasterProductBodyState();
}

class _MasterProductBodyState extends State<MasterProductBody> {
  late TextEditingController searchCo;
  final productScroll = ScrollController();
  String formMode = "";
  String? searchVal;
  bool expandNavBar = true;
  bool showNavBar = true;
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  Login? login;
  // late List<MasterProductModel> listProduct;
  MasterProductModel modelSearch =
      MasterProductModel(productName: "", productDesc: "");
  KeyVal? searchBySelected;
  List<KeyVal> searchCat = [];
  List<MasterProductModel> listProduct = [];

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
    //   KeyVal("All", ""),
    // );
    searchCat.add(
      KeyVal("Product Name", Constant.productName),
    );
    searchCat.add(
      KeyVal("Product Desc", Constant.productDesc),
    );
    // searchCat.add(
    //   KeyVal("Touch Point", Constant.touchPoint),
    // );
    searchBySelected = searchCat[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    bloc(MasterProductEvent event) {
      BlocProvider.of<MasterProductBloc>(context).add(event);
    }

    productFailed(String? msg) {
      showTopSnackBar(
          context, UpperSnackBar.error(message: msg ?? "Error occured"));
    }

    homeBloc(HomeEvent event) {
      BlocProvider.of<HomeBloc>(context).add(event);
    }

    onSearch(String? value) {
      modelSearch = MasterProductModel(
        productDesc: searchBySelected?.value == Constant.productDesc
            ? (value ?? "").trim()
            : null,
        productName: searchBySelected?.value == Constant.productName
            ? (value ?? "").trim()
            : null,
        touchPoint: searchBySelected?.value == Constant.touchPoint
            ? (value ?? "").trim()
            : null,
      );
      paging.pageNo = 1;
      bloc(GetProductData(model: modelSearch, paging: paging));
    }

    onEditAction(MasterProductModel value) {
      setState(() {
        formMode = Constant.editMode;
      });
      bloc(
          ToProductForm(model: MasterProductModel(productCd: value.productCd)));
    }

    onView(MasterProductModel value, bool canUpdate) {
      showDialog(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (context) =>
                  MasterProductBloc()..add(ToProductForm(model: value)),
              child: ViewDialogProduct(
                onEdit: () {
                  context.back();
                  onEditAction(value);
                },
                canUpdate: canUpdate,
              ),
            );
          });
    }

    onDeleteAction(MasterProductModel value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return BlocProvider(
            create: (context) => MasterProductBloc(),
            child: DeleteProductDialog(
              title: "Success",
              productCd: value.productCd!,
              productName: value.productName ?? "",
              onError: (value) {
                productFailed(value);
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
          onSearch(searchVal);
          bloc(GetProductData(model: modelSearch, paging: paging));
        }
      });
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
              ProductError(state.error);
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
        BlocListener<MasterProductBloc, MasterProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.error));
              setState(() {
                formMode = "";
              });
            }
            if (state is ProductDataLoaded) {
              formMode = "";
              listProduct.clear();
              if (state.paging != null) {
                paging = state.paging!;
              }
              if (state.data != null) {
                listProduct = state.data!;
              } else {
                listProduct = [];
              }
            }
            if (state is AddProductSubmit) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return SuccessDialog(
                    title: "Master product process successfully",
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
                bloc(GetProductData(
                    model: MasterProductModel(productName: "", productDesc: ""),
                    paging: paging));
              });
            }
            // if (state is EditProductSubmit) {
            //   showDialog(
            //     context: context,
            //     barrierDismissible: false,
            //     builder: (ctx) {
            //       return SuccessDialog(
            //         title: "Master Product Update",
            //         msg: state.msg,
            //         buttonText: "OK",
            //         onTap: () => context.back(),
            //       );
            //     },
            //   ).then((value) {
            //     searchCo.clear();
            //     searchVal = '';
            //     paging.pageNo = 1;
            //     searchVal = "";
            //     setState(() {
            //       formMode = "";
            //     });
            //     bloc(GetProductData(model: modelSearch, paging: paging));
            //   });
            // }
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
              // bloc(SearchMstSupplier(
              //     model: modelSearch,
              //     paging: Paging(pageNo: 1, pageSize: 5)));
              bloc(GetProductData(
                  model: modelSearch, paging: Paging(pageNo: 1, pageSize: 5)));
            }
            if (state is PermittedFeatError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.errMsg));
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
          BlocProvider(
            create: (context) => ProfileBloc()..add(GetProfileData()),
            child: CustomAppBar(
              menuTitle: "Product",
              menuName: "Master Product",
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
                      selectedTile: Constant.mstProduct,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: productScroll,
                          child: SingleChildScrollView(
                            controller: productScroll,
                            padding: sccOutterPadding,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<MasterProductBloc,
                                    MasterProductState>(
                                  builder: (context, state) {
                                    if (state is ProductFormLoaded) {
                                      return Column(
                                        children: [
                                          ProductFormAddEdit(
                                            formMode: formMode,
                                            model: state.model,
                                            listType: state.listSysMaster,
                                            listAttribute: state.listAttribute,
                                            onClose: () {
                                              searchVal = '';
                                              onSearch(searchVal);
                                              setState(() {
                                                formMode = "";
                                              });
                                            },
                                            onSuccesSubmit: (value) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (ctx) {
                                                  return SuccessDialog(
                                                    title:
                                                        "Master Product Successfully Add",
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
                                                bloc(GetProductData(
                                                    model: modelSearch,
                                                    paging: paging));
                                              });
                                              // if (formMode ==
                                              //     Constant.addMode) {
                                              //   bloc(AddProductData(value));
                                              // } else if (formMode ==
                                              //     Constant.editMode) {
                                              //   bloc(EditProductData(value));
                                              // }
                                            },
                                          )
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
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
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                            height: isMobile ? 50 : 48,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Visibility(
                                                  visible: !isMobile,
                                                  child: SizedBox(
                                                    width: 230,
                                                    child:
                                                        PortalFormDropdownKeyVal(
                                                      searchBySelected,
                                                      searchCat,
                                                      enabled:
                                                          searchCat.isNotEmpty,
                                                      fillColour: Colors.white,
                                                      // fontWeight: FontWeight.normal,
                                                      borderRadius: 8,
                                                      borderRadiusBotRight: 0,
                                                      borderRadiusTopRight: 0,
                                                      borderColor: sccWhite,
                                                      onChange: (value) {
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
                                                            context: context,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            isDismissible: true,
                                                            enableDrag:
                                                                searchBySelected !=
                                                                    null,
                                                            isScrollControlled:
                                                                true,
                                                            builder: (context) {
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
                                                              color: sccWhite,
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
                                                              child: HeroIcon(
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
                                                  child: PlainSearchField(
                                                    controller: searchCo,
                                                    // fillColor: Colors.white,
                                                    fillColor: sccFieldColor,
                                                    hint:
                                                        'Search ${searchBySelected!.label} here...',
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
                                                                searchVal = "";
                                                                searchCo
                                                                    .clear();
                                                                searchVal = '';
                                                              });
                                                              paging.pageNo = 1;
                                                              searchCo.clear();
                                                              searchVal = '';
                                                              onSearch(
                                                                  searchVal);
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
                                                            value?.trim() ?? "";
                                                      });
                                                    },
                                                    borderRadius: 8,
                                                    borderRadiusTopLeft: 0,
                                                    borderRadiusBotLeft: 0,
                                                    suffixSize: 48,
                                                    onAction: (value) {
                                                      onSearch(searchVal);
                                                    },
                                                    onSearch: () {
                                                      onSearch(searchVal);
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
                                                    ? ButtonConfirmWithIcon(
                                                        icon: HeroIcon(
                                                          HeroIcons.plus,
                                                          color: sccWhite,
                                                          size: context
                                                              .scaleFont(14),
                                                        ),
                                                        colour: sccNavText2,
                                                        text: "Add New",
                                                        width: context
                                                                .deviceWidth() *
                                                            (context.isDesktop()
                                                                ? 0.14
                                                                : 0.38),
                                                        borderRadius: 12,
                                                        onTap: () {
                                                          setState(() {
                                                            formMode = Constant
                                                                .addMode;
                                                          });
                                                          bloc(ToProductForm());
                                                        },
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
                                            isLoading: state is ProductLoading,
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
                                                          'Product',
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
                                                              bloc(GetProductData(
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
                                                  listProduct.isNotEmpty
                                                      ? MasterProductTable(
                                                          canView: true,
                                                          canUpdate:
                                                              premittedEdit !=
                                                                  null,
                                                          canDelete:
                                                              premittedDelete !=
                                                                  null,
                                                          listProduct:
                                                              listProduct,
                                                          onView: (value) {
                                                            onView(
                                                                value,
                                                                premittedEdit !=
                                                                    null);
                                                          },
                                                          onDelete: (value) =>
                                                              onDeleteAction(
                                                                  value),
                                                          onEdit: (value)
                                                              //   setState(() {
                                                              //     formMode =
                                                              //         Constant.editMode;
                                                              //   });
                                                              //   bloc(ToProductForm(
                                                              //       model: MasterProductModel(
                                                              //           productCd: value
                                                              //               .productCd)));
                                                              // }
                                                              =>
                                                              onEditAction(
                                                            value,
                                                          ),
                                                        )
                                                      : const EmptyData(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          BlocBuilder<MasterProductBloc,
                                              MasterProductState>(
                                            builder: (context, state) {
                                              return Visibility(
                                                visible: !isMobile &&
                                                    paging.totalPages != null &&
                                                    paging.totalData != null &&
                                                    state is ProductDataLoaded,
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
                                                      pageSize: paging.pageSize,
                                                      totalDataInPage: paging
                                                          .totalDataInPage,
                                                      totalData:
                                                          paging.totalData,
                                                      onClick: (value) {
                                                        paging.pageNo = value;
                                                        bloc(GetProductData(
                                                            model: modelSearch,
                                                            paging: paging));
                                                      },
                                                      onClickFirstPage: () {
                                                        paging.pageNo = 1;
                                                        bloc(GetProductData(
                                                            model: modelSearch,
                                                            paging: paging));
                                                      },
                                                      onClickPrevious: () {
                                                        paging.pageNo =
                                                            paging.pageNo! - 1;
                                                        bloc(GetProductData(
                                                            model: modelSearch,
                                                            paging: paging));
                                                      },
                                                      onClickNext: () {
                                                        paging.pageNo =
                                                            paging.pageNo! + 1;
                                                        bloc(GetProductData(
                                                            model: modelSearch,
                                                            paging: paging));
                                                      },
                                                      onClickLastPage: () {
                                                        paging.pageNo =
                                                            paging.totalPages;
                                                        bloc(GetProductData(
                                                            model: modelSearch,
                                                            paging: paging));
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
                                      );
                                    }
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
