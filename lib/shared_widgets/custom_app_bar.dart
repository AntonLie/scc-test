import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/profile.dart';
import 'package:scc_web/screens/notification/notif_portal.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/form_dialog.dart';
import 'package:scc_web/theme/colors.dart';

class CustomAppBar extends StatefulWidget {
  final String? menuTitle, menuName, formMode, childMenu;
  final bool? initiallyExpanded, showNavBar;
  final Function()? onClick, onExpand, onClickChild;
  const CustomAppBar({
    Key? key,
    this.menuTitle,
    this.menuName,
    this.formMode,
    this.onClick,
    this.initiallyExpanded,
    this.onExpand,
    this.showNavBar,
    this.childMenu = "",
    this.onClickChild,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isLoading = false;
  bool openedAll = false;
  bool isHovered = false;
  bool initiallyExpanded = true;
  bool showNavBar = true;
  Profile profile = Profile();
  bool visible = false;
  Login? login;

  @override
  void initState() {
    initiallyExpanded = widget.initiallyExpanded ?? true;
    showNavBar = widget.showNavBar ?? true;
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();
  }

  @override
  void didUpdateWidget(CustomAppBar oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        initiallyExpanded = widget.initiallyExpanded ?? true;
        showNavBar = widget.showNavBar ?? true;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  homeBloc(HomeEvent event) {
    BlocProvider.of<HomeBloc>(context).add(event);
  }

  authBloc(AuthEvent event) {
    BlocProvider.of<AuthBloc>(context).add(event);
  }

  profileBloc(ProfileEvent event) {
    BlocProvider.of<ProfileBloc>(context).add(event);
  }

  Widget profileAnimation(Profile profile) {
    return PortalTarget(
      visible: isHovered,
      anchor: const Aligned(
          follower: Alignment.topCenter, target: Alignment.bottomCenter),
      portalFollower: MouseRegion(
        onHover: (event) {
          if (!isHovered) isHovered = true;
          setState(() {});
        },
        onExit: (event) {
          setState(() {
            isHovered = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          width: 280,
          // height: 100,
          decoration: BoxDecoration(
            color: sccWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(profile.base64 ?? Constant.profileBase64Img),
                    height: context.scaleFont(80),
                    width: context.scaleFont(80),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  profile.fullName ?? "Name",
                  style: TextStyle(
                    color: sccBlack,
                    fontSize: context.scaleFont(14),
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    context.push(const ProfileSettingsRoute());
                    // alertDialogLogout(context, () => homeBloc(DoLogout()));
                  },
                  child: Row(
                    children: [
                      HeroIcon(
                        HeroIcons.user,
                        color: sccNavText2,
                        size: context.scaleFont(16),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Expanded(
                        child: Text(
                          "Account",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: sccBlack),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    alertDialogLogout(context, () => homeBloc(DoLogout()));
                  },
                  child: Row(
                    children: [
                      HeroIcon(
                        HeroIcons.arrowRightOnRectangle,
                        color: sccNavText2,
                        size: context.scaleFont(16),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Expanded(
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: sccBlack),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      child: MouseRegion(
        onHover: (value) {
          if (!isHovered) isHovered = true;
          setState(() {});
        },
        onExit: (value) {
          setState(() {
            isHovered = false;
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            base64Decode(profile.base64 ?? Constant.profileBase64Img),
            height: context.scaleFont(35),
            width: context.scaleFont(35),
          ),
        ),
      ),
    );
  }

  Widget profileContainer(Profile profile) {
    return PortalTarget(
      visible: visible,
      // anchor: const Aligned(
      //   follower: Alignment.topCenter,
      //   target: Alignment.bottomCenter,
      // ),
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            visible = false;
          });
        },
      ),
      child: PortalTarget(
        visible: visible,
        anchor: const Aligned(
          follower: Alignment.topCenter,
          target: Alignment.bottomLeft,
        ),
        portalFollower: Container(
          padding: const EdgeInsets.all(8),
          width: 280,
          // height: 100,
          decoration: BoxDecoration(
            color: sccWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(profile.base64 ?? Constant.profileBase64Img),
                    // base64Decode(Constant.profileBase64Img),
                    height: context.scaleFont(80),
                    width: context.scaleFont(80),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  profile.fullName ?? "Name",
                  // "name",
                  style: TextStyle(
                    color: sccBlack,
                    fontSize: context.scaleFont(14),
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    context.push(const ProfileSettingsRoute());
                    // alertDialogLogout(context, () => homeBloc(DoLogout()));
                  },
                  child: Row(
                    children: [
                      HeroIcon(
                        HeroIcons.user,
                        color: sccNavText2,
                        size: context.scaleFont(16),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Expanded(
                        child: Text(
                          "Account",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: sccBlack),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      visible = false;
                    });
                    alertDialogLogout(context, () => homeBloc(DoLogout()));
                  },
                  child: Row(
                    children: [
                      HeroIcon(
                        HeroIcons.arrowRightOnRectangle,
                        color: sccNavText2,
                        size: context.scaleFont(16),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Expanded(
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: sccBlack),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              visible = !visible;
            });
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  base64Decode(profile.base64 ?? Constant.profileBase64Img),
                  // base64Decode(Constant.profileBase64Img),
                  height: context.scaleFont(35),
                  width: context.scaleFont(35),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5.wh),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName ?? "Person Name",
                      // "Person Name",
                      style: TextStyle(
                        color: defaultElement,
                        fontSize: context.scaleFont(12),
                        overflow: TextOverflow.clip,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      profile.division ?? "Position",
                      // "Position",
                      style: TextStyle(
                        color: defaultGrey,
                        fontSize: context.scaleFont(10),
                        overflow: TextOverflow.clip,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeError) {}
              if (state is LoadHome) {
                login = state.login;
                if (login == null) homeBloc(DoLogout(login: login));
              }
              if (state is OnLogoutHome) {
                context.push(const LoginRoute());
                authBloc(AuthLogin());
              }
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(listener: (context, state) {
            if (state is ProfileError) {
              // ScaffoldMessenger.of(context)
              //   ..hideCurrentSnackBar()
              //   ..showSnackBar(failSnackBar(message: state.error));
            }
            if (state is OnLogoutProfile) {
              authBloc(AuthLogin());
            }
            if (state is ProfileView) {
              setState(() {
                profile = state.profile;
              });
            }
          })
        ],
        child:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          return Container(
            color: sccWhite,
            width: context.deviceWidth(),
            // decoration: const BoxDecoration(),
            child: Row(
              children: [
                Container(
                  transformAlignment: Alignment.bottomCenter,
                  // width: context.deviceWidth() * 0.17,
                  width: context.deviceWidth() *
                      ((context.isWideScreen() && initiallyExpanded)
                          ? 0.17
                          : 0.065),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  // color: sccRed,
                  height: kToolbarHeight + 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: initiallyExpanded == true
                            ? context.deviceWidth() * 0.03
                            : context.deviceWidth() * 0.008,
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        // color: sccAmber,
                        curve: Curves.bounceInOut,
                        child: Visibility(
                          visible: true,
                          child: Text(
                            'SUPPLY CHAIN \nCONNECTIVITY',
                            style: TextStyle(
                                fontSize: context.isFullScreen() &&
                                        initiallyExpanded == true
                                    ? context.dynamicFont(16)
                                    : context.scaleFont(10),
                                color: sccNavText2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: initiallyExpanded == true
                        ? const EdgeInsets.symmetric(horizontal: 20)
                        : const EdgeInsets.symmetric(horizontal: 10),
                    // color: sccGreen,
                    // color: sccWhite,
                    child: Row(
                      children: [
                        ExpandableWidget(
                          expand: context.isDesktop() &&
                              context.isWideScreen() &&
                              (!isFullscreen(context) || showNavBar),
                          child: InkWell(
                            onTap: () {
                              if (widget.onExpand != null) {
                                widget.onExpand!();
                              }
                              // print(widget.onExpand);
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: sccNavText2.withOpacity(0.1),
                                ),
                                child: const HeroIcon(
                                  HeroIcons.bars3,
                                  color: sccNavText2,
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              border: widget.menuName != null
                                  ? const Border(
                                      right: BorderSide(
                                          width: 0.5, color: sccTextGray))
                                  : null),
                          child: Text(
                            widget.menuTitle ?? "",
                            style: TextStyle(
                              fontSize: context.scaleFont(24),
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff2B2B2B),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: widget.menuName != null,
                          child: SizedBox(
                            height: 40,
                            // color: sccAmber,
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: widget.onClick,
                                  child: Text(
                                    widget.menuName ?? "",
                                    style: TextStyle(
                                      fontSize: context.scaleFont(14),
                                      fontWeight: FontWeight.w600,
                                      color: (widget.formMode != "" ||
                                              widget.childMenu != "")
                                          ? sccTextGray
                                          : sccNavText2,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: (widget.childMenu != ""),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      HeroIcon(
                                        HeroIcons.chevronRight,
                                        color: defaultGrey,
                                        size: context.scaleFont(14),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: widget.onClickChild,
                                        child: Text(
                                          // widget.formMode ?? "",
                                          widget.childMenu ?? "",
                                          style: TextStyle(
                                            fontSize: context.scaleFont(14),
                                            fontWeight: FontWeight.w600,
                                            color: (widget.formMode != "")
                                                ? sccTextGray
                                                : sccNavText2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: (widget.formMode) != "",
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      HeroIcon(
                                        HeroIcons.chevronRight,
                                        color: defaultGrey,
                                        size: context.scaleFont(14),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        // widget.formMode ?? "",
                                        widget.formMode == Constant.addMode
                                            ? "Add New"
                                            : widget.formMode ==
                                                    Constant.editMode
                                                ? "Edit"
                                                : widget.formMode ==
                                                        Constant.viewMode
                                                    ? "View"
                                                    : widget.formMode ?? "",
                                        style: TextStyle(
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.w600,
                                          color: sccNavText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const NotifPortal(),
                profileContainer(profile),
                const SizedBox(
                  width: 30,
                )
              ],
            ),
          );
        }));
  }
}
