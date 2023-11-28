import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/assign_mst_item/bloc/assign_mst_item_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/download/bloc/download_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/permitted_feat/bloc/permitted_feat_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/assign_mst_item.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/permitted_func_feat.dart';
import 'package:scc_web/model/use_case.dart';
import 'package:scc_web/screens/master_item/dialog_add_mst_item.dart';
import 'package:scc_web/screens/master_item/dialog_upload_consume.dart';
import 'package:scc_web/screens/master_item/dialog_upload_item.dart';
import 'package:scc_web/screens/master_item/item_table.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/error_dialog.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/progress_bar.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/success_dialog.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';

class MasterItemScreen extends StatefulWidget {
  const MasterItemScreen({super.key});

  @override
  State<MasterItemScreen> createState() => _MasterItemScreenState();
}

class _MasterItemScreenState extends State<MasterItemScreen> {
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
          selectedTile: Constant.item,
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
            create: (context) => AssignMstItemBloc()
              ..add(
                GetMstItemData(
                  model: AssignMstItem(),
                  paging: Paging(pageNo: 1, pageSize: 5),
                ),
              ),
          ),
          BlocProvider(
            create: (context) => PermittedFeatBloc()
              ..add(
                GetPermitted(Constant.item),
              ),
          ),
          BlocProvider(
            create: (context) => DownloadBloc(),
          ),
        ],
        child: const MasterItemBody(),
      )),
    );
  }
}

class MasterItemBody extends StatefulWidget {
  const MasterItemBody({super.key});

  @override
  State<MasterItemBody> createState() => _MasterItemBodyState();
}

class _MasterItemBodyState extends State<MasterItemBody> {
  final controller = ScrollController();
  Login? login;
  late TextEditingController searchCo;
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  String formMode = "";
  String? searchVal;
  List<AssignMstItem> listMstItem = [];
  List<KeyVal> listPoint = [];
  List<ListUseCaseData> listUseCase = [];
  AssignMstItem modelSearch = AssignMstItem(itemCd: "", itemDesc: "");
  KeyVal? searchBySelected;
  List<KeyVal> searchCat = [];
  KeyVal? statusBySelected;
  List<KeyVal> statusCat = [];

  bool expandNavBar = true;
  bool showNavBar = true;
  PermittedFunc? permitted;
  FeatureList? premittedAdd;

  @override
  void initState() {
    searchCo = TextEditingController();
    searchCat.add(KeyVal("All", ""));
    searchCat.add(KeyVal("Item Code", Constant.itemCode));
    searchCat.add(KeyVal("Item Description", Constant.itemDesc));
    searchCat.add(KeyVal("Business Process", Constant.useCaseName));
    statusCat.add(KeyVal("All", ""));

    searchBySelected = searchCat[0];
    statusBySelected = statusCat[0];

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

    bloc(AssignMstItemEvent event) {
      BlocProvider.of<AssignMstItemBloc>(context).add(event);
    }

    // mstItemFailed(String? msg) {
    //   showTopSnackBar(
    //       context, UpperSnackBar.error(message: msg ?? "Error occured"));
    // }

    onSearch(String? value) {
      modelSearch = AssignMstItem(
        searchBy: searchBySelected?.value,
        searchValue: searchVal,
        statusCd: statusBySelected?.value ?? "",
      );
      paging.pageNo = 1;
      bloc(GetMstItemData(model: modelSearch, paging: paging));
    }

    onUploadItem() {
      showDialog(
          context: context,
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AuthBloc(),
                ),
                BlocProvider(
                  create: (context) => DownloadBloc(),
                ),
                BlocProvider(create: (context) => AssignMstItemBloc()),
              ],
              child: DialogUploadItem(
                listUseCase: listUseCase,
                onSubmit: (val) {
                  bloc(UploadMstItem(val, paging));
                  context.closeDialog();
                },
              ),
            );
          });
    }

    onUploadBuildofmaterial() {
      showDialog(
          context: context,
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AuthBloc(),
                ),
                BlocProvider(
                  create: (context) => DownloadBloc(),
                ),
                BlocProvider(create: (context) => AssignMstItemBloc()),
              ],
              child: DialogUploadConsume(
                listPoint: listPoint,
                onSubmit: (val) {
                  bloc(UploadBillMaterial(val, paging));
                  context.closeDialog();
                },
              ),
            );
          });
    }

    onAddAction(AssignMstItem val) {
      showDialog(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (context) =>
                  AssignMstItemBloc()..add(ToMstItemAddEdit(model: val)),
              child: DialogAddItem(
                listUseCase: listUseCase,
                supplierCd: val.supplierCd!,
                onSave: (value) {
                  bloc(SubmitMstItemData(value));
                  context.closeDialog();
                },
                formMode: Constant.addMode,
              ),
            );
          });
    }

    onEditAction(AssignMstItem val) {
      showDialog(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (context) =>
                  AssignMstItemBloc()..add(ToMstItemAddEdit(model: val)),
              child: DialogAddItem(
                supplierCd: val.supplierCd!,
                listUseCase: listUseCase,
                onSave: (value) {
                  bloc(SubmitMstItemData(value));
                  context.closeDialog();
                },
                formMode: Constant.editMode,
              ),
            );
          });
    }

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
              MstItemError(state.error);
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
        BlocListener<AssignMstItemBloc, AssignMstItemState>(
          listener: (context, state) {
            if (state is MstItemError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.error));
              // context.closeDialog();
            }
            if (state is MstItemUploadError) {
              context.closeDialog();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return ErrorDialog(
                    title: "Upload Master Item Process Error",
                    msg: state.error,
                    buttonText: "Close",
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
                bloc(GetMstItemData(model: modelSearch, paging: paging));
              });
            }
            if (state is OnLogoutMstItem) {
              authBloc(AuthLogin());
            }
            if (state is MstItemLoaded) {
              formMode = "";
              listMstItem.clear();
              listPoint.clear();
              statusCat.clear();
              statusCat.add(KeyVal("All", ""));
              for (var e in state.listSysMaster) {
                if (e.systemCd != null) {
                  statusCat.add(KeyVal(
                      e.systemValue ?? "UNKNOWN STATUS", e.systemCd ?? ""));
                }
              }
              if (state.paging != null) {
                paging = state.paging!;
              }
              if (state.data != null) {
                listMstItem = state.data!;
              } else {
                listMstItem = [];
              }
              listPoint = state.listPoint;
              listUseCase = state.listUseCase;
            }
            if (state is MstItemAdd) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return SuccessDialog(
                    title: "Assign Master Item Process Successfully",
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
                bloc(GetMstItemData(model: modelSearch, paging: paging));
              });
            }
            if (state is LoadUpload) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return ProgressBar(
                    onTap: () => const MasterItemRoute(),
                  );
                },
              ).whenComplete(() => const MasterItemRoute());
            }
            if (state is SuccesUpload) {
              context.closeDialog();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return SuccessDialog(
                    title: "Upload Success",
                    msg: state.messageUpload!.msg ??
                        "Successfully upload to master item",
                    buttonText: "OK",
                    onTap: () => context.closeDialog(),
                  );
                },
              ).then((value) {
                searchCo.clear();
                searchVal = '';
                paging.pageNo = 1;
                setState(() {
                  formMode = "";
                });
                bloc(GetMstItemData(model: modelSearch, paging: paging));
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
            }
            if (state is PermittedFeatError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.errMsg));
            }
            if (state is OnLogoutPermittedFeat) {
              authBloc(AuthLogin());
            }
          },
        ),
      ],
      child: Column(
        children: [
          BlocProvider(
            create: (context) => ProfileBloc()..add(GetProfileData()),
            child: CustomAppBar(
              menuTitle: "Assign Master Item",
              menuName: "Master Item",
              formMode: formMode,
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
                  expand: context.isDesktop() && (!isFullscreen(context)),
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
                      selectedTile: Constant.item,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: controller,
                          child: SingleChildScrollView(
                            controller: controller,
                            padding: sccOutterPadding,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<AssignMstItemBloc,
                                    AssignMstItemState>(
                                  builder: (context, state) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          // visible: !isMobile,
                                          alignment: Alignment.bottomLeft,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: context.deviceWidth() *
                                                    0.12,
                                                child: SelectableText(
                                                  'Status',
                                                  style: TextStyle(
                                                    fontSize:
                                                        context.scaleFont(14),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width:
                                                    context.deviceWidth() * 0.1,
                                                child: SelectableText(
                                                  'Search by',
                                                  style: TextStyle(
                                                    fontSize:
                                                        context.scaleFont(14),
                                                    fontWeight: FontWeight.w400,
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
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Visibility(
                                                visible: !isMobile,
                                                child: SizedBox(
                                                  width: context.deviceWidth() *
                                                      0.12,
                                                  child:
                                                      PortalFormDropdownKeyVal(
                                                    statusBySelected,
                                                    statusCat,
                                                    enabled:
                                                        statusCat.isNotEmpty,
                                                    fillColour: Colors.white,
                                                    // fontWeight: FontWeight.normal,
                                                    borderRadius: 8,
                                                    borderColor: sccWhite,
                                                    onChange: (value) {
                                                      setState(() {
                                                        statusBySelected =
                                                            value;
                                                      });
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
                                              Visibility(
                                                visible: !isMobile,
                                                child: SizedBox(
                                                  width: context.deviceWidth() *
                                                      0.12,
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
                                              SizedBox(
                                                width:
                                                    context.deviceWidth() * 0.2,
                                                child: PlainSearchField(
                                                  controller: searchCo,
                                                  fillColor: sccFieldColor,
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
                                                              searchCo.clear();
                                                              searchVal = '';
                                                            });
                                                            onSearch(searchVal);
                                                          },
                                                          icon: const HeroIcon(
                                                            HeroIcons.xCircle,
                                                            color: sccText4,
                                                          ),
                                                        )
                                                      : null,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      searchVal = value ?? "";
                                                    });
                                                  },
                                                  borderRadius: 8,
                                                  borderRadiusTopLeft: 0,
                                                  borderRadiusBotLeft: 0,
                                                  suffixSize: 48,
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
                                              // ),
                                              ButtonConfirmWithIcon(
                                                icon: HeroIcon(
                                                  HeroIcons.arrowUpTray,
                                                  color: sccNavText2,
                                                  size: context.scaleFont(14),
                                                ),
                                                colour: sccNavText2
                                                    .withOpacity(0.3),
                                                textColor: sccNavText2,
                                                text: "Upload Item",
                                                width: context.deviceWidth() *
                                                    0.12,
                                                borderRadius: 12,
                                                boxShadowColor:
                                                    sccWhite.withOpacity(0.3),
                                                onTap: () {
                                                  // setState(() {
                                                  //   formMode =
                                                  //       Constant.addMode;
                                                  // });
                                                  // bloc(ToProductForm());
                                                  onUploadItem();
                                                },
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              ButtonConfirmWithIcon(
                                                icon: HeroIcon(
                                                  HeroIcons.arrowUpTray,
                                                  color: sccWhite,
                                                  size: context.scaleFont(14),
                                                ),
                                                colour: sccNavText2,
                                                text: "Upload Bill of Material",
                                                width: context.deviceWidth() *
                                                    0.145,
                                                borderRadius: 12,
                                                onTap: () {
                                                  onUploadBuildofmaterial();
                                                  // setState(() {
                                                  //   formMode =
                                                  //       Constant.addMode;
                                                  // });
                                                  // bloc(ToProductForm());
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        CommonShimmer(
                                          isLoading: state is MstItemLoading,
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
                                                        'Master Item',
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
                                                            onSearch(searchVal);
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                // ItemTable(),
                                                listMstItem.isNotEmpty
                                                    ? ItemTable(
                                                        canAdd: premittedAdd !=
                                                            null,
                                                        canEdit: true,
                                                        onAdd: (val) {
                                                          onAddAction(val);
                                                        },
                                                        onEdit: (val) {
                                                          onEditAction(val);
                                                        },
                                                        listItem: listMstItem,
                                                      )
                                                    : const EmptyData(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        BlocBuilder<AssignMstItemBloc,
                                            AssignMstItemState>(
                                          builder: (context, state) {
                                            return Visibility(
                                              visible: !isMobile &&
                                                  paging.totalPages != null &&
                                                  paging.totalData != null &&
                                                  listMstItem.isNotEmpty,
                                              // && state is MstItemLoaded,
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
                                                      bloc(GetMstItemData(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                    onClickFirstPage: () {
                                                      paging.pageNo = 1;
                                                      bloc(GetMstItemData(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                    onClickPrevious: () {
                                                      paging.pageNo =
                                                          paging.pageNo! - 1;
                                                      bloc(GetMstItemData(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                    onClickNext: () {
                                                      paging.pageNo =
                                                          paging.pageNo! + 1;
                                                      bloc(GetMstItemData(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                    onClickLastPage: () {
                                                      paging.pageNo =
                                                          paging.totalPages;
                                                      bloc(GetMstItemData(
                                                          model: modelSearch,
                                                          paging: paging));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      ],
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
