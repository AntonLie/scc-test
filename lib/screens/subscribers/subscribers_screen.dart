import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/master_package/bloc/master_package_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';

import 'package:scc_web/bloc/subs/bloc/subs_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';

import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/subscribers.dart';
import 'package:scc_web/screens/subscribers/Subscribers_table.dart';
import 'package:scc_web/screens/subscribers/card_subscription.dart';
import 'package:scc_web/screens/subscribers/subscribers_dialog.dart';
import 'package:scc_web/screens/subscribers/subscribers_form_view.dart';
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
import 'package:scc_web/theme/padding.dart';

class SubscribersScreen extends StatefulWidget {
  const SubscribersScreen({super.key});

  @override
  State<SubscribersScreen> createState() => _SubscribersScreenState();
}

class _SubscribersScreenState extends State<SubscribersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sccBackground,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) => MasterPackageBloc()
              ..add(GetPackageData(
                pkgNm: "",
                paging: Paging(pageSize: 5, pageNo: 1),
              )),
          ),
          BlocProvider(
              create: (context) => SubsBloc()
                ..add(InitSubs(
                  packageTypeCd: "",
                  companyName: "",
                  paging: Paging(pageSize: 5, pageNo: 1),
                )))
        ],
        child: const SubscribersBody(),
      ),
    );
  }
}

class SubscribersBody extends StatefulWidget {
  const SubscribersBody({super.key});

  @override
  State<SubscribersBody> createState() => _SubscribersBodyState();
}

class _SubscribersBodyState extends State<SubscribersBody> {
  subsError(String? msg) {
    showTopSnackBar(
        context, UpperSnackBar.error(message: msg ?? "Error occured"));
  }

  authBloc(AuthEvent event) {
    BlocProvider.of<AuthBloc>(context).add(event);
  }

  bloc(SubsEvent event) {
    BlocProvider.of<SubsBloc>(context).add(event);
  }

  packagebloc(MasterPackageEvent event) {
    BlocProvider.of<MasterPackageBloc>(context).add(event);
  }

  homeBloc(HomeEvent event) {
    BlocProvider.of<HomeBloc>(context).add(event);
  }

  bool showNavBar = true;
  bool expandNavBar = true;
  final controller = ScrollController();
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  TextEditingController searchCo = TextEditingController();
  String searchVal = "";

  String searchHint = "";

  late List<ListSubsTable> dataTbl;

  String? parentMenuSelected;
  List<KeyVal> parentMenuOpt = [
    KeyVal('All', ""),
  ];
  KeyVal? searchPackSelected;
  List<KeyVal> searchPack = [];
  KeyVal searchTypeSelected = KeyVal("All", "");
  List<KeyVal> searchType = [];
  KeyVal? searchBySelected;
  List<KeyVal> searchBy = [];
  String? totalSubs;
  String? totalRevenue;
  String? gasFee;
  Login? login;

  List<KeyVal> systemDrop = [];

  @override
  void initState() {
    dataTbl = [];
    searchHint = "Search here..";
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    searchBy.add(
      KeyVal("Company Name", "companyName"),
    );

    searchPack.add(
      KeyVal("All", ""),
    );
    searchPackSelected = searchPack[0];
    // searchTypeSelected = searchType[0];
    searchBySelected = searchBy[0];

    dataTbl = [];
    super.initState();
  }

  onViewAction(ListSubsTable mdl) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => SubsBloc()
            ..add(ToViewSubs(
                companyCd: mdl.companyCd,
                packageCd: mdl.packageCd,
                formMode: Constant.viewMode)),
          child: const SubscribersFormViewBody(),
        );
      },
    );
  }

  onCreateAction(ListSubsTable mdl) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => SubsBloc()
            ..add(ToViewSubs(
                companyCd: mdl.companyCd,
                packageCd: mdl.packageCd,
                formMode: Constant.addMode)),
          child: AddEditSubscribers(
            model: mdl,
            pkgName: searchPack,
            numofPeriods: systemDrop,
            formMode: Constant.addMode,
            onSubmitEdit: (val) {
              bloc(SubmitEditSubs(
                  companyCd: val.companyCd,
                  pkgCd: val.packageCd,
                  newpkgCd: val.newPackageCd,
                  formMode: Constant.addMode,
                  data: val));
            },
          ),
        );
      },
    );
  }

  onEditAction(ListSubsTable mdl) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => SubsBloc()
            ..add(ToViewSubs(
                companyCd: mdl.companyCd,
                packageCd: mdl.packageCd,
                formMode: Constant.editMode)),
          child: AddEditSubscribers(
            model: mdl,
            pkgName: searchPack,
            numofPeriods: systemDrop,
            formMode: Constant.editMode,
            onSubmitEdit: (val) {
              bloc(SubmitEditSubs(
                  companyCd: val.companyCd,
                  pkgCd: val.packageCd,
                  formMode: Constant.editMode,
                  data: val));
            },
          ),
        );
      },
    );
  }

  onNotifAction(ListSubsTable mdl) {
    bloc(SubmitNotify(companyCd: mdl.companyCd, pkgCd: mdl.packageCd));
  }

  @override
  Widget build(BuildContext context) {
    onSearch() {
      paging.pageNo = 1;
      if (searchPackSelected!.value != "") {
        paging.packageCd = int.parse(searchPackSelected!.value);
      }
      bloc(InitSubs(
        packageTypeCd: searchTypeSelected.value,
        companyName: searchVal,
        paging: paging,
      ));
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
              subsError(state.error);
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
        BlocListener<SubsBloc, SubsState>(listener: (context, state) {
          if (state is SubsDataTableLoaded) {
            dataTbl.clear();
            searchType.clear();
            searchPack.clear();

            if (state.paging != null) {
              paging = state.paging!;
            }

            searchPack.add(
              KeyVal("All", ""),
            );
            if (state.dataPackage != null) {
              for (var element in state.dataPackage!) {
                searchPack
                    .add(KeyVal(element.packageName!, element.packageCd!));
              }
            }
            // searchPackSelected = searchPack[0];
            if (state.data != null) {
              setState(() {
                dataTbl = state.data!;
                systemDrop = state.listSystem;
              });
            } else {
              dataTbl = [];
            }

            totalSubs = state.total.totalSubs.toString();
            totalRevenue = state.total.totalRev;
            gasFee = state.total.totalGasFee;
            searchType.add(KeyVal("All", ""));
            searchType.addAll(state.listTypeProduct);
          }
          if (state is SubsError) {
            subsError(state.msg);
          }
          if (state is SubsEditSubmitted) {
            context.closeDialog();
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return SuccessDialog(
                  msg: state.msg,
                  buttonText: "OK",
                  onTap: () => context.back(),
                );
              },
            ).then((value) {
              searchCo.clear();
              paging.pageNo = 1;
              onSearch();
            });
          }

          if (state is SubsNotifySubmitted) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return SuccessDialog(
                  msg: state.msg,
                  buttonText: "OK",
                  onTap: () => context.back(),
                );
              },
            ).then((value) {
              searchCo.clear();
              paging.pageNo = 1;
              onSearch();
            });
          }
          //   if (state is SubsCriteriaLoaded) {
          //     option.clear();
          //     option.add(KeyVal('All', ''));
          //     state.listPackage?.forEach((e) {
          //       option.add(KeyVal(
          //           e.packageName ?? '-', (e.packageCd ?? '-').toString()));
          //     });
          //     optionSelected = option[0];
          //     numPeriods.clear();
          //     state.listNumPeriod.forEach((e) {
          //       numPeriods.add(
          //           KeyVal(e.systemDesc ?? 'Undifined', e.systemValue ?? '0'));
          //     });
          //     onSearch();
          //   }
          // },
        }),
        // BlocListener<MasterPackageBloc, MasterPackageState>(
        //     listener: ((context, state) {
        //   if (state is PackageDataLoaded) {
        //     for (var element in state.data!) {
        //       searchPack.add(KeyVal(element.packageName!, element.packageCd!));
        //     }
        //   }
        // }))
      ],
      child: Column(
        children: [
          BlocProvider(
            create: (context) => ProfileBloc()..add(GetProfileData()),
            child: CustomAppBar(
              menuTitle: "Subscribers",
              menuName: "Subscribers",
              formMode: "",
              onClick: () {
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
                      selectedTile: Constant.SUBSCRIBERS,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          controller: controller,
                          child: SingleChildScrollView(
                            controller: controller,
                            padding: sccOutterPadding,
                            child: Column(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      // height: 100,
                                      padding: isMobile
                                          ? EdgeInsets.zero
                                          : const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      height: context.deviceHeight() * 0.13,
                                      width: context.deviceWidth(),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: CardScreenSubs(
                                              value: totalSubs,
                                              title: "Number of Subscribers",
                                              imgString: Constant.blue,
                                              iconString:
                                                  Constant.iconGroupBlue,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: CardScreenSubs(
                                              value: totalRevenue,
                                              title: "Total Revenue",
                                              imgString: Constant.green,
                                              iconString:
                                                  Constant.iconDollarGreen,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: CardScreenSubs(
                                              value: gasFee,
                                              title: "Gas Fee Revenue",
                                              imgString: Constant.red,
                                              iconString: Constant.iconExitRed,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: context.deviceHeight() * 0.03,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Visibility(
                                        visible: !isMobile,
                                        child: SizedBox(
                                          width: context.deviceWidth() * 0.15,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Package',
                                                style: TextStyle(
                                                  fontSize:
                                                      context.scaleFont(14),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                height: 48,
                                                child: PortalFormDropdownKeyVal(
                                                  searchPackSelected,
                                                  searchPack,
                                                  borderColor:
                                                      Colors.transparent,
                                                  onChange: (value) {
                                                    setState(() {
                                                      if (searchPack.length >
                                                          1) {
                                                        searchPackSelected =
                                                            value;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !isMobile,
                                      child: const SizedBox(
                                        width: 20,
                                      ),
                                    ),
                                    Expanded(
                                      // fit: FlexFit.loose,
                                      flex: 3,
                                      child: Visibility(
                                        visible: !isMobile,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Type Of Packages',
                                              style: TextStyle(
                                                fontSize: context.scaleFont(14),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 48,
                                              width: 250,
                                              child: PortalFormDropdownKeyVal(
                                                searchTypeSelected,
                                                searchType,
                                                enabled: searchType.length > 1,
                                                borderColor: Colors.transparent,
                                                onChange: (value) {
                                                  if (searchType.length > 1) {
                                                    setState(() {
                                                      searchTypeSelected =
                                                          value;
                                                      // print(value);
                                                    });
                                                    // onRefresh(value: toSearch);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      // fit: FlexFit.loose,
                                      flex: 3,
                                      child: Visibility(
                                        visible: !isMobile,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Search by',
                                              style: TextStyle(
                                                fontSize: context.scaleFont(14),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 48,
                                              // width: 250,
                                              child: PortalFormDropdownKeyVal(
                                                searchBySelected,
                                                searchBy,
                                                enabled: searchBy.length > 1,
                                                fillColour: Colors.white,
                                                borderRadius: 8,
                                                borderRadiusBotRight: 0,
                                                borderRadiusTopRight: 0,
                                                borderColor: sccWhite,
                                                onChange: (value) {
                                                  if (searchBy.length > 1) {
                                                    setState(() {
                                                      searchBySelected = value;
                                                    });
                                                    // onRefresh(value: toSearch);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: PlainSearchField(
                                          hint: searchHint,
                                          controller: searchCo,
                                          fillColor: sccFieldColor,
                                          borderRadius: 8,
                                          borderRadiusTopLeft: 0,
                                          borderRadiusBotLeft: 0,
                                          suffixSize: 48,
                                          prefix: searchCo.text.isNotEmpty
                                              ? IconButton(
                                                  // splashRadius: 0,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  onPressed: () {
                                                    setState(() {
                                                      searchCo.clear();
                                                      searchVal = '';
                                                    });
                                                    paging.pageNo = 1;
                                                    searchCo.clear();
                                                    onSearch();
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
                                          onAction: (value) {
                                            onSearch();
                                          },
                                          onSearch: () {
                                            onSearch();
                                          }),
                                    ),
                                    const Expanded(
                                      flex: 3,
                                      child: SizedBox(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                BlocBuilder<SubsBloc, SubsState>(
                                  builder: (context, state) {
                                    return CommonShimmer(
                                      isLoading: state is SubsLoading,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isMobile
                                              ? Colors.transparent
                                              : sccWhite,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Subscribers',
                                                    style: TextStyle(
                                                      fontSize:
                                                          context.scaleFont(18),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xff2B2B2B),
                                                    ),
                                                  ),
                                                  PagingDropdown(
                                                    selected:
                                                        (paging.pageSize ?? 0)
                                                            .toString(),
                                                    onSelect: (val) {
                                                      if (paging.pageSize !=
                                                          val) {
                                                        setState(() {
                                                          paging.pageSize = val;
                                                        });

                                                        onSearch();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            SubscribersTableScreen(
                                              listModel: dataTbl,
                                              onView: (value) {
                                                onViewAction(value);
                                              },
                                              onCreate: (value) {
                                                onCreateAction(value);
                                              },
                                              onEdit: (value) {
                                                onEditAction(value);
                                              },
                                              onNotif: (value) {
                                                onNotifAction(value);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                BlocBuilder<SubsBloc, SubsState>(
                                  builder: (context, state) {
                                    return Visibility(
                                      visible: !isMobile &&
                                          paging.totalPages != null &&
                                          paging.totalData != null &&
                                          dataTbl.isNotEmpty,
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
                                              if (searchPackSelected!.value !=
                                                  "") {
                                                paging.packageCd = int.parse(
                                                    searchPackSelected!.value);
                                              }
                                              bloc(InitSubs(
                                                packageTypeCd:
                                                    searchTypeSelected?.value ??
                                                        '',
                                                companyName: searchVal,
                                                paging: paging,
                                              ));
                                            },
                                            onClickFirstPage: () {
                                              paging.pageNo = 1;
                                              if (searchPackSelected!.value !=
                                                  "") {
                                                paging.packageCd = int.parse(
                                                    searchPackSelected!.value);
                                              }
                                              bloc(InitSubs(
                                                packageTypeCd:
                                                    searchTypeSelected?.value ??
                                                        '',
                                                companyName: searchVal,
                                                paging: paging,
                                              ));
                                            },
                                            onClickPrevious: () {
                                              paging.pageNo =
                                                  paging.pageNo! - 1;
                                              if (searchPackSelected!.value !=
                                                  "") {
                                                paging.packageCd = int.parse(
                                                    searchPackSelected!.value);
                                              }
                                              bloc(InitSubs(
                                                packageTypeCd:
                                                    searchTypeSelected?.value ??
                                                        '',
                                                companyName: searchVal,
                                                paging: paging,
                                              ));
                                            },
                                            onClickNext: () {
                                              paging.pageNo =
                                                  paging.pageNo! + 1;
                                              if (searchPackSelected!.value !=
                                                  "") {
                                                paging.packageCd = int.parse(
                                                    searchPackSelected!.value);
                                              }
                                              bloc(InitSubs(
                                                packageTypeCd:
                                                    searchTypeSelected.value ??
                                                        '',
                                                companyName: searchVal,
                                                paging: paging,
                                              ));
                                            },
                                            onClickLastPage: () {
                                              paging.pageNo = paging.totalPages;
                                              if (searchPackSelected!.value !=
                                                  "") {
                                                paging.packageCd = int.parse(
                                                    searchPackSelected!.value);
                                              }
                                              bloc(InitSubs(
                                                packageTypeCd:
                                                    searchTypeSelected?.value ??
                                                        '',
                                                companyName: searchVal,
                                                paging: paging,
                                              ));
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
