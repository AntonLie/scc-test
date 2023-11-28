import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/bloc/settings/bloc/settings_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/countries.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/profile.dart';
import 'package:scc_web/screens/profile_settings/password_container.dart';
import 'package:scc_web/screens/profile_settings/profile_container.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
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
          selectedTile: Constant.MENU_SETTINGS,
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
            create: (context) => ProfileBloc()..add(GetProfileData()),
          ),
          BlocProvider(
              create: (context) => SettingsBloc() //..add(SetInitial()),
              ),
        ],
        child: const ProfileBody(),
      )),
    );
  }
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final settingsController = ScrollController();
  Profile profile = Profile();
  bool expandNavBar = true;
  bool showNavBar = true;
  bool isLoading = false;
  List<Countries> listCountryDrpdwn = [];
  Login? login;

  onError(String error) {
    showTopSnackBar(context, UpperSnackBar.error(message: error));
  }

  onSuccess(String msg) {
    showTopSnackBar(context, UpperSnackBar.success(message: msg));
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
            if (state is HomeError) {
              ProfileError(state.error);
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
        BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              onError(state.error);
            }
            if (state is SettingsLoading) {
              isLoading = true;
            } else {
              isLoading = false;
            }
            if (state is OnLogoutSettings) {
              authBloc(AuthLogin());
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              onError(state.error);
              // ScaffoldMessenger.of(context)
              //   ..hideCurrentSnackBar()
              //   ..showSnackBar(failSnackBar(message: state.error));
            }
            if (state is OnLogoutProfile) {
              authBloc(AuthLogin());
            }
            if (state is ProfileView) {
              profile = state.profile;
              listCountryDrpdwn = state.listCountry;
            }
            if (state is ProfileLoading) {
              isLoading = true;
            } else {
              isLoading = false;
            }
          },
        ),
      ],
      child: Column(
        children: [
          Visibility(
            visible: !isMobile,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AuthBloc(),
                ),
                BlocProvider(
                  create: (context) => HomeBloc(),
                ),
                BlocProvider(
                  create: (context) => ProfileBloc()
                    ..add(GetProfileData(
                      loadMenu: true,
                    )),
                ),
              ],
              child: CustomAppBar(
                  menuTitle: "Profile Account",
                  showNavBar: showNavBar,
                  initiallyExpanded: expandNavBar,
                  onExpand: () {
                    setState(() {
                      expandNavBar = !expandNavBar;
                    });
                  }),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      // selectedTile: '',
                      selectedTile: Constant.MENU_SETTINGS,
                    ),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    controller: settingsController,
                    child: SingleChildScrollView(
                      controller: settingsController,
                      padding: sccOutterPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonShimmer(
                            isLoading: isLoading,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                                color: sccWhite,
                                border: Border.all(
                                    width: 1, color: sccLightGrayDivider),
                                borderRadius: BorderRadius.circular(16),
                                // borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      fontSize: context.scaleFont(18),
                                      fontWeight: FontWeight.w600,
                                      color: sccText1,
                                    ),
                                  ),
                                ),
                                children: [
                                  const Divider(
                                    height: 1,
                                    color: sccLightGrayDivider,
                                    thickness: 1,
                                  ),
                                  MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) => ProfileBloc()
                                          ..add(UpdateProfileEvent()),
                                      ),
                                      BlocProvider(
                                        create: (context) => AuthBloc(),
                                      ),
                                      BlocProvider(
                                        create: (context) => HomeBloc(),
                                      ),
                                    ],
                                    child: ProfileContainer(
                                      onError: (val) {
                                        onError(val);
                                      },
                                      onSuccess: (val) {
                                        onSuccess(val);
                                      },
                                      listCountryDrpdwnForm: listCountryDrpdwn,
                                      dialCode: profile.dialCode,
                                      base64: profile.base64,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          CommonShimmer(
                            isLoading: isLoading,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                                color: sccWhite,
                                border: Border.all(
                                    width: 1, color: sccLightGrayDivider),
                                borderRadius: BorderRadius.circular(16),
                                // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
                              ),
                              child: Column(
                                children: [
                                  ExpansionTile(
                                    initiallyExpanded: true,
                                    title: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        "Password",
                                        style: TextStyle(
                                          fontSize: context.scaleFont(18),
                                          fontWeight: FontWeight.w600,
                                          color: sccText1,
                                        ),
                                      ),
                                    ),
                                    children: [
                                      const Divider(
                                        height: 1,
                                        color: sccLightGrayDivider,
                                        thickness: 1,
                                      ),
                                      ChangePassword(
                                        onSuccess: (val) {
                                          onSuccess(val);
                                        },
                                        onError: (val) {
                                          onError(val);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
    );
  }
}
