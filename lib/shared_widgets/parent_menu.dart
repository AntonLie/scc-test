import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/route_generator.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/theme/colors.dart';

class ParentMenu extends StatefulWidget {
  final Widget? icon;
  final double rightPadding;
  final bool isActive, hExpand;
  final List<Menu>? menuChildren;
  final Function()? onRoute, onLogout;
  final String title, selected, menuCd;
  const ParentMenu(
      {this.rightPadding = 24,
      this.onRoute,
      this.onLogout,
      required this.isActive,
      required this.menuChildren,
      required this.selected,
      required this.menuCd,
      required this.hExpand,
      this.icon,
      required this.title,
      Key? key})
      : super(key: key);

  @override
  State<ParentMenu> createState() => _ParentMenuState();
}

class _ParentMenuState extends State<ParentMenu> {
  bool expand = false;
  bool hExpand = false;
  bool onHover = false;
  bool isActive = false;
  bool openPortal = false;
  final List<Menu> menuChildren = [];

  @override
  void initState() {
    if (widget.isActive == true) {
      isActive = true;
      expand = true;
    }
    if (widget.menuChildren != null) {
      menuChildren.addAll(widget.menuChildren!);
      menuChildren
          .sort((a, b) => (a.menuSeq ?? 0).compareTo(b.menuSeq ?? 1000));
    }
    hExpand = widget.hExpand;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  void didUpdateWidget(ParentMenu oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        hExpand = widget.hExpand;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget menuChild({
      required String title,
      required String menuCd,
      Function()? onLogout,
      Widget? icon,
    }) {
      return TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 8)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        onPressed: onLogout ?? () => context.generateRoute(menuCd),
        child: Container(
          margin: EdgeInsets.only(right: 8.wh),
          padding: EdgeInsets.symmetric(horizontal: 4.wh, vertical: 4.wh),
          decoration: const BoxDecoration(
            // color: widget.selected == menuCd ? VccNavLightGrey : null,
            // gradient: widget.selected == menuCd
            //     ? LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [
            //           VccButtonLightBlue,
            //           VccButtonBlue,
            //         ],
            //       )
            //     : null,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            // BorderRadius.only(
            //   topRight: Radius.circular(50),
            //   bottomRight: Radius.circular(50),
            // ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: icon != null,
                child: GradientWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.selected == menuCd ? sccNavText2 : sccNavText1,
                      widget.selected == menuCd ? sccNavText2 : sccNavText1,
                    ],
                  ),
                  child: icon ?? const SizedBox(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.brightness_1_rounded,
                        size: context.scaleFont(6),
                        color: widget.selected == menuCd
                            ? sccNavText2
                            : sccNavText1,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: context.scaleFont(12),
                            fontWeight: FontWeight.w600,
                            color: widget.selected == menuCd
                                ? sccNavText2
                                : sccNavText1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget parentMenu() {
      return PortalTarget(
        visible: openPortal,
        portalFollower: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              openPortal = !openPortal;
            });
          },
        ),
        child: PortalTarget(
          visible: onHover || openPortal,
          anchor: Aligned(
            follower: onHover ? Alignment.topLeft : Alignment.centerLeft,
            target: onHover ? Alignment.bottomLeft : Alignment.centerRight,
          ),
          portalFollower: Builder(builder: (context) {
            if (onHover) {
              return Container(
                padding: const EdgeInsets.all(8),
                // height: 100,
                decoration: BoxDecoration(
                  color: sccWhite,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
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
                child: Text(
                  widget.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: context.scaleFont(14),
                    fontWeight: FontWeight.w600,
                    color: isActive ? sccNavText2 : sccNavText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.all(8),
              width: context.deviceWidth() * 0.18,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "${widget.title} menus",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: context.scaleFont(14),
                        fontWeight: FontWeight.w600,
                        color: sccNavText1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: menuChildren.isNotEmpty
                        ? menuChildren.map((e) {
                            if (!(e.menuTypeCd ?? "")
                                .toUpperCase()
                                .contains("PARENT")) {
                              return menuChild(
                                title: e.menuName ?? "[UNIDENTIFIED]",
                                menuCd: e.menuCd ?? "",
                                onLogout: e.menuCd == Constant.logOut
                                    ? widget.onLogout
                                    : null,
                              );
                            } else {
                              return const SizedBox();
                            }
                          }).toList()
                        : [],
                  ),
                ],
              ),
            );
          }),
          child: MouseRegion(
            onHover: (val) {
              setState(() {
                if (!hExpand && !openPortal) {
                  onHover = true;
                }
              });
            },
            onExit: (val) {
              setState(() {
                onHover = false;
              });
            },
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.only(
                    right: 8, top: 8, bottom: 8, left: 8)),
              ),
              onPressed: widget.onRoute ??
                  () {
                    setState(() {
                      if (hExpand) {
                        expand = !expand;
                      } else {
                        openPortal = !openPortal;
                      }
                    });
                  },
              child: Container(
                // margin: EdgeInsets.only(right: 8.wh),
                padding: EdgeInsets.symmetric(horizontal: 4.wh, vertical: 4.wh),
                decoration: BoxDecoration(
                  gradient: isActive == true
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            sccNavLightGrey,
                            sccNavLightGrey,
                          ],
                        )
                      : null,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  // BorderRadius.only(
                  //     topRight: Radius.circular(50),
                  //     bottomRight: Radius.circular(50)),
                ),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientWidget(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isActive
                            //  && widget.menuCd == Constant.settingMenu
                            ? [
                                sccNavText2,
                                sccNavText2,
                              ]
                            : [
                                sccNavText1,
                                sccNavText1,
                              ],
                      ),
                      child: widget.icon ??
                          HeroIcon(
                            // expand ? HeroIcons.chevronUp :
                            HeroIcons.chevronDown,
                            size: context.scaleFont(20),
                          ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ExpandableWidget(
                        expand: hExpand,
                        axisDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 4.wh,
                            ),
                            Expanded(
                              child: Text(
                                widget.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: context.scaleFont(12),
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      //  &&
                                      //         widget.menuCd ==
                                      //             Constant.settingMenu
                                      ? sccNavText2
                                      : sccNavText1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            GradientWidget(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isActive &&
                                        widget.menuCd == Constant.settingMenu
                                    ? [sccNavText1, sccNavText1]
                                    : [
                                        sccNavText2,
                                        sccNavText2,
                                      ],
                              ),
                              child: HeroIcon(
                                // expand ? HeroIcons.chevronUp :
                                HeroIcons.chevronDown,
                                size: context.scaleFont(14),
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
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          parentMenu(),
          Visibility(
            visible: menuChildren.isNotEmpty,
            child: ExpandableWidget(
              expand: hExpand && expand && context.isWideScreen(),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: //widget.children ??
                      (menuChildren).map((element) {
                    if ((element.menuTypeCd ?? "")
                        .toUpperCase()
                        .contains("PARENT")) {
                      return ParentMenu(
                        selected: element.menuCd ?? "",
                        title: element.menuName ?? "[UNIDENTIFIED]",
                        menuCd: element.menuCd ?? "",
                        hExpand: hExpand,
                        menuChildren: element.childs,
                        onRoute: element.menuTypeCd ==
                                Constant.mntParentMenuRouting
                            ? () => context.generateRoute(element.menuCd ?? "")
                            : null,
                        onLogout: (element.childs ?? [])
                                .any((e) => e.menuCd == Constant.logOut)
                            ? widget.onLogout
                            : null,
                        isActive: element.menuCd == widget.selected ||
                            (element.childs ?? [])
                                .any((e) => e.menuCd == widget.selected),
                        rightPadding: widget.rightPadding,
                      );
                    } else {
                      return menuChild(
                        title: element.menuName ?? "[UNIDENTIFIED]",
                        menuCd: element.menuCd ?? "",
                        onLogout: element.menuCd == Constant.logOut
                            ? widget.onLogout
                            : null,
                      );
                    }
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
