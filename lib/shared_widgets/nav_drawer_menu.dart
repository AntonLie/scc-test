import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/route_generator.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/shared_widgets/parent_menu.dart';
import 'package:scc_web/shared_widgets/scroll_to_index.dart';
import 'package:scc_web/shared_widgets/single_menu.dart';

class NavDrawerMenu extends StatefulWidget {
  final AutoScrollController navDrawerController;
  final List<Menu> listMenu;
  final String selectedTile;
  final bool isLoading, isExpanded;
  final Function() onWidgetBuilt, onLogout;

  ///* a callback function called before routing
  final Function()? optionalCallback;
  const NavDrawerMenu({
    this.optionalCallback,
    required this.isExpanded,
    required this.onLogout,
    required this.isLoading,
    required this.onWidgetBuilt,
    required this.selectedTile,
    required this.listMenu,
    required this.navDrawerController,
    Key? key,
  }) : super(key: key);

  @override
  State<NavDrawerMenu> createState() => _NavDrawerMenuState();
}

class _NavDrawerMenuState extends State<NavDrawerMenu> {
  bool isExpanded = true;
  @override
  void initState() {
    isExpanded = widget.isExpanded;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onWidgetBuilt();
      // navDrawerController.addListener(() => _scrollListener());
      // _scrollToIndex(listMenu.indexWhere((element) => element.menuCd == widget.selectedTile));
    });
    super.initState();
  }

  @override
  void didUpdateWidget(NavDrawerMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isExpanded = widget.isExpanded;
      });
    });
  }

  isDashboard(Menu element) {
    String dashboardName = element.menuName ?? '';
    bool isDashboard = dashboardName.toUpperCase() == "DASHBOARD";
    return isDashboard;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: widget.navDrawerController,
      thumbVisibility: context.isWideScreen(),
      child: ListView(
        padding: const EdgeInsets.all(8),
        controller: widget.navDrawerController,
        children: widget.listMenu.map((element) {
          if (element.menuSeq != null) {
            if ((element.menuTypeCd ?? "").toUpperCase().contains("PARENT")) {
              return AutoScrollTag(
                controller: widget.navDrawerController,
                index: element.menuSeq!,
                child: ParentMenu(
                  selected: widget.selectedTile,
                  hExpand: isExpanded,
                  icon: context.mapMenuIcons(element.menuCd ?? ""),
                  title: element.menuName ?? "[UNIDENTIFIED]",
                  menuCd: element.menuCd ?? "",
                  isActive: element.menuCd == widget.selectedTile ||
                      (element.childs ?? [])
                          .any((e) => e.menuCd == widget.selectedTile),
                  menuChildren: element.childs,
                  onRoute:
                      element.menuTypeCd == Constant.mntParentMenuRouting ||
                              isDashboard(element)
                          ? () async {
                              if (widget.optionalCallback != null) {
                                widget.optionalCallback!();
                              }
                              await Future.delayed(
                                  const Duration(milliseconds: 200), () {
                                context.generateRoute(element.menuCd ?? "");
                              });
                            }
                          : null,
                  onLogout: (element.childs ?? [])
                          .any((e) => e.menuCd == Constant.logOut)
                      ? () => widget.onLogout()
                      : null,
                ),
              );
            } else {
              return AutoScrollTag(
                controller: widget.navDrawerController,
                index: element.menuSeq!,
                child: SingleMenu(
                    isLoading: widget.isLoading,
                    isExpanded: isExpanded,
                    isActive: widget.selectedTile == element.menuCd,
                    title: element.menuName ?? "[UNIDENTIFIED]",
                    menuCd: (element.menuCd ?? ""),
                    icon: context.mapMenuIcons(element.menuCd ?? ""),
                    onPressed: (element.menuCd == Constant.logOut)
                        ? () => widget.onLogout()
                        : () {
                            if (widget.optionalCallback != null) {
                              widget.optionalCallback!();
                            }
                            context.generateRoute(element.menuCd ?? "");
                          }),
              );
            }
          } else {
            return const SizedBox();
          }
        }).toList(),
      ),
    );
  }
}
