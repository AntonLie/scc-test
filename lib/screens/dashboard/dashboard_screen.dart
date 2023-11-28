import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/profile.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/profile_label.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/widgets/dashboard/business_select.dart';
import 'package:scc_web/widgets/dashboard/dashboard_chart.dart';
import 'package:scc_web/widgets/dashboard/dashboard_map.dart';
import 'package:scc_web/widgets/dashboard/period.dart';

import '../../helper/app_route.gr.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc()..add(GetMenu()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
      ],
      child: const Scaffold(
          backgroundColor: sccBackground,
          drawerEnableOpenDragGesture: false,
          // drawer: MultiBlocProvider(providers: BlocProvider(create: (context) => ), child: child),
          body: DashboardBody()),
    );
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  Profile profile = Profile();
  bool expandNavBar = true;
  bool showNavBar = true;
  bool showMap = false;
  String formMode = "";
  Login? login;
  final controller = ScrollController();
  final mediaQueryData = const MediaQueryData();
  final ScrollController scrollController = ScrollController();

  //Search State
  late TextEditingController searchBusiness;
  KeyVal? searchBySelected;
  List<KeyVal> searchCat = [];

  handleSearchSelectedBusiness(value) {
    setState(() {
      searchBySelected = value;
    });
  }

  handleShowMap(bool value) {
    setState(() {
      showMap = value;
    });
  }

  void handleSearch() async {
    handleShowMap(true);
  }

  //Calendar State
  DateTime? startDtSelected;
  DateTime? endDtSelected;
  bool reset = false;

  void handleResetDate(bool value) {
    reset = value;
  }

  void handleDateSelected(DateTime? startDate, DateTime? endDate) {
    startDtSelected = startDate;
    endDtSelected = endDate;

    print(startDtSelected);
    print(endDtSelected);
  }

  void handleEndDate(DateTime value) {
    endDtSelected = value;
  }

  @override
  void initState() {
    searchCat.add(KeyVal("ALL", "ALL"));
    searchCat.add(KeyVal("INE_001 & Inventory Non Engine", "INE001"));
    searchCat.add(KeyVal("IE_001 & Inventory Engine", "IE001"));
    searchCat.add(KeyVal("TUC_001 & Test Use Case", "TUC001"));
    searchCat.add(KeyVal("VPAD_001 & Vehicle Pairing And Delivery", "VPAD001"));

    // searchBySelected = searchCat[0];
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
        ],
        child: Column(
          children: [
            BlocProvider(
              create: (context) => ProfileBloc()..add(GetProfileData()),
              child: CustomAppBar(
                menuTitle: "Dashboard",
                formMode: formMode,
                showNavBar: showNavBar,
                initiallyExpanded: expandNavBar,
                onExpand: () {
                  setState(() {
                    expandNavBar = !expandNavBar;
                  });
                },
              ),
            ),
            Expanded(
                child: Row(
              children: [
                ExpandableWidget(
                  expand: context.isDesktop(),
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
                      selectedTile: Constant.dashboard,
                    ),
                  ),
                ),
                Flexible(
                  child: MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => HomeBloc(),
                        ),
                        BlocProvider(
                          create: (context) => AuthBloc(),
                        ),
                      ],
                      child: Scrollbar(
                        thumbVisibility: false,
                        controller: scrollController,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          controller: scrollController,
                          children: [
                            Column(
                              children: [
                                Container(
                                    color: Colors.white,
                                    child: SingleChildScrollView(
                                      controller: controller,
                                      padding: const EdgeInsets.only(
                                          right: 25, left: 25),
                                      child: Column(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: SizedBox(
                                                  child: BlocProvider(
                                                create: (context) =>
                                                    ProfileBloc()
                                                      ..add(GetProfileData()),
                                                child: const ProfileLabel(
                                                    label: "Hello, "),
                                              ))),
                                          Row(
                                            children: [
                                              BusinessSelect(
                                                  handleShowMap: handleShowMap,
                                                  handleSearch: handleSearch),
                                              Period(
                                                  reset: reset,
                                                  handleResetDate:
                                                      handleResetDate,
                                                  handleDateSelected:
                                                      handleDateSelected,
                                                  handleEndDate: handleEndDate)
                                            ],
                                          ),
                                          DashboardMap(
                                            showMap: showMap,
                                            searchBySelected: searchBySelected,
                                          ),
                                          const DashboardChart(),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ))
          ],
        ));
  }
}
