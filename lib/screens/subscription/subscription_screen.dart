import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/menu.dart';

import 'package:scc_web/screens/register_product/plan_container.dart';
import 'package:scc_web/screens/subscription/feature_container_subs.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/success_dialog.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEnableOpenDragGesture: false,
        appBar: isMobile
            ? PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Container(),
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
            selectedTile: Constant.subscription,
          ),
        ),
        backgroundColor: sccBackground,
        body: const SubscriptionBody());
  }
}

class SubscriptionBody extends StatefulWidget {
  const SubscriptionBody({super.key});

  @override
  State<SubscriptionBody> createState() => _SubscriptionBodyState();
}

class _SubscriptionBodyState extends State<SubscriptionBody> {
  List<Menu> listMenu = [];
  final mainController = ScrollController();
  bool showNavBar = false;
  bool expandNavBar = true;
  Login? login;
  adminContacted() {
    showDialog(
      context: context,
      builder: (ctx) {
        return SuccessDialog(
          title: "Success !",
          msg: "Admin successfully contacted",
          buttonText: "OK",
          onTap: () => context.closeDialog(),
        );
      },
    );
  }

  authBloc(AuthEvent event) {
    BlocProvider.of<AuthBloc>(context).add(event);
  }

  homeBloc(HomeEvent event) {
    BlocProvider.of<HomeBloc>(context).add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ProfileBloc()..add(GetProfileData()),
            ),
            BlocProvider(
              create: (context) => AuthBloc(),
            ),
            BlocProvider(
              create: (context) => HomeBloc(),
            ),
          ],
          child: CustomAppBar(
            menuTitle: "Subscription",
            menuName: "Upgrade Package",
            formMode: "",
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                    selectedTile: Constant.subscription,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        controller: mainController,
                        child: SingleChildScrollView(
                          padding: sccOutterPadding,
                          controller: mainController,
                          child: Column(
                            children: [
                              Container(
                                width: context.deviceWidth(),
                                decoration: BoxDecoration(
                                  color:
                                      isMobile ? Colors.transparent : sccWhite,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: isMobile
                                    ? EdgeInsets.zero
                                    : const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PricingContainer(
                                      adminContacted: () {
                                        adminContacted();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    FeatureContainer(
                                      adminContacted: () {
                                        adminContacted();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 24,
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
