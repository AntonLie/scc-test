// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/master_package/bloc/master_package_bloc.dart';

import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/drag_behaviour.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/user_role.dart';
import 'package:scc_web/screens/inventory/scc_typeahead.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/vcc_checkbox_tile.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../shared_widgets/buttons.dart';
import '../../theme/colors.dart';

class LoVPackageRole extends StatefulWidget {
  final Function(String) onError;
  final Function(List<KeyVal>) onComplete;
  final Function() onLogout;
  final List<KeyVal> selectedItems;
  final bool viewMode;
  final String? nameDialog;

  const LoVPackageRole({
    required this.onError,
    // required this.listUsecase,
    required this.selectedItems,
    required this.viewMode,
    required this.onComplete,
    required this.onLogout,
    Key? key,
    this.nameDialog,
  }) : super(key: key);

  @override
  State<LoVPackageRole> createState() => _LoVPackageRoleState();
}

class _LoVPackageRoleState extends State<LoVPackageRole> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MasterPackageBloc(),
      child: LoVPackageRoleBody(
        nameDialog: widget.nameDialog,
        viewMode: widget.viewMode,
        onError: (value) => widget.onError(value),
        onLogout: () => widget.onLogout(),
        onComplete: (value) => widget.onComplete(value),
        selectedItems: widget.selectedItems,
      ),
    );
  }
}

class LoVPackageRoleBody extends StatefulWidget {
  final Function(String) onError;
  final Function(List<KeyVal>) onComplete;
  final Function() onLogout;
  final String? nameDialog;
  final List<KeyVal> selectedItems;
  final bool viewMode;
  const LoVPackageRoleBody({
    required this.onError,
    required this.viewMode,
    required this.onComplete,
    required this.onLogout,
    required this.selectedItems,
    Key? key,
    this.nameDialog,
  }) : super(key: key);

  @override
  _LoVPackageRoleBodyState createState() => _LoVPackageRoleBodyState();
}

class _LoVPackageRoleBodyState extends State<LoVPackageRoleBody> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  late ScrollController controller;
  late ScrollController vController;
  late TextEditingController searchCo;
  bool modelLoaded = false;
  RoleUser? selectedMenuList;
  String? selectedRole;
  List<KeyVal> selectedItems = [];
  double? rowWidth;
  int number = 0;

  @override
  void initState() {
    selectedItems = List.from(widget.selectedItems);
    // title = widget.partNo;
    controller = ScrollController();
    vController = ScrollController();
    searchCo = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc(MasterPackageEvent event) {
      BlocProvider.of<MasterPackageBloc>(context).add(event);
    }

    return Dialog(
      insetPadding: kIsWeb && !isWebMobile
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.15),
              vertical: (context.deviceHeight() * 0.1),
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: MultiBlocListener(
          listeners: [
            BlocListener<MasterPackageBloc, MasterPackageState>(
              listener: (context, state) {
                if (state is LoadMenuList) {
                  selectedMenuList = state.model;
                  selectedRole = state.model?.roleCd;
                }
                if (state is PackageError) {
                  context.closeDialog();
                  widget.onError(state.error);
                }
                if (state is OnLogout) {
                  context.closeDialog();
                  widget.onLogout();
                }
              },
            ),
          ],
          child:
              // BlocBuilder<MstRoleBloc, MstRoleState>(
              //   builder: (context, state) {
              //     return
              Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<MasterPackageBloc, MasterPackageState>(
                        builder: (context, state) {
                          return Text(
                            widget.nameDialog ?? "",
                            style: TextStyle(
                              fontSize: context.scaleFont(24),
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      BlocBuilder<MasterPackageBloc, MasterPackageState>(
                        builder: (context, state) {
                          return IconButton(
                            onPressed: () {
                              // if (!(state is UserRoleSubmitLoading)) {
                              context.back();
                              // }
                            },
                            icon: const HeroIcon(
                              HeroIcons.xMark,
                              color: sccButtonPurple,
                            ),
                            splashRadius: 20,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: sccLightGrayDivider,
                  height: 25,
                  thickness: 2,
                ),
                BlocBuilder<MasterPackageBloc, MasterPackageState>(
                  builder: (context, state) {
                    // if (state is UserRoleSubmitLoading) {}
                    return Container(
                      decoration: BoxDecoration(
                        color: sccWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // height: context.deviceHeight(),
                      // width: context.deviceWidth(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Roles",
                                style: TextStyle(
                                  fontSize: context.scaleFont(14),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              height: 56,
                              child: SccMultipleTypeAheadKeyVal(
                                selectedItems: selectedItems,
                                url: Constant.mstRoleDial,
                                apiKeyLabel: "roleName",
                                apiKeyValue: "roleCd",
                                hintText: !widget.viewMode
                                    ? "Select Roles"
                                    : (selectedItems.isEmpty
                                        ? "This User doesn't have any roles"
                                        : ""),
                                enabled: !widget.viewMode,
                                fillColor: sccWhite,
                                onLogout: () {
                                  context.push(const LoginRoute());
                                },
                                onError: (value) {
                                  showTopSnackBar(
                                      context,
                                      UpperSnackBar.error(
                                          message: value ?? "Error occured"));
                                },
                                onSelectionChange: (value) {
                                  bool first = selectedItems.isEmpty;
                                  setState(() {
                                    selectedItems = List.from(value);
                                    if (selectedItems.isEmpty) {
                                      selectedRole = null;
                                    }
                                 
                                  });
                                  if (first && selectedItems.isNotEmpty) {
                                    selectedRole = selectedItems[0].value;
                                    bloc(GetMenuFeature(
                                        roleCd: selectedItems[0].value));
                                  }
                                },
                              ),
                            ),
                          ),
                          // BlocBuilder<MstRoleBloc, MstRoleState>(
                          //   builder: (context, state) {
                          //     return
                          Visibility(
                            visible: selectedItems.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ScrollConfiguration(
                                behavior: DragBehavior(),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: selectedItems.map((element) {
                                      bool match =
                                          (element.value == selectedRole);
                                      return InkWell(
                                        onTap: () {
                                          if (!match) {
                                            bloc(GetMenuFeature(
                                                roleCd: element.value));
                                          }
                                          // setState(() {
                                          //   selectedRole = element.value;
                                          // });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: match
                                                    ? sccButtonPurple
                                                    : sccButtonGrey,
                                                width: match ? 2 : 1,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            element.label,
                                            style: TextStyle(
                                              fontSize: context.scaleFont(14),
                                              color: match
                                                  ? sccButtonPurple
                                                  : sccSubMenuKeyTrace,
                                              fontWeight: match
                                                  ? FontWeight.w400
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            // )
                            //     ;
                            //   },
                          ),
                          // BlocBuilder<MstRoleBloc, MstRoleState>(
                          //   builder: (context, state) {
                          //     return
                          Visibility(
                            visible: selectedRole != null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: LayoutBuilder(
                                builder: (context, ctn) {
                                  return CommonShimmer(
                                    isLoading:
                                        state is MasterPackageSubmitLoading,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: sccWhite,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      // constraints: BoxConstraints(
                                      //   maxHeight: context.deviceHeight() * 0.5,
                                      // ),
                                      width: ctn.maxWidth,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight:
                                                context.deviceHeight() * 0.25),
                                        child: Scrollbar(
                                          controller: vController,
                                          thumbVisibility: true,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            controller: vController,
                                            child: ScrollConfiguration(
                                              behavior: DragBehavior(),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: (selectedMenuList
                                                              ?.menuList
                                                              ?.isNotEmpty ==
                                                          true)
                                                      ? selectedMenuList!
                                                          .menuList!
                                                          .map((element) {
                                                          // number++;
                                                          return MenuFeatureItem(
                                                            model: element,
                                                            width: rowWidth,
                                                            viewMode:
                                                                widget.viewMode,
                                                            getWidth: (value) {
                                                              if (value?.width
                                                                          .compareTo(rowWidth ??
                                                                              0)
                                                                          .isNegative !=
                                                                      true &&
                                                                  value?.width
                                                                          .compareTo(
                                                                              ctn.maxWidth)
                                                                          .isNegative !=
                                                                      true) {
                                                                setState(() {
                                                                  rowWidth = value
                                                                      ?.width;
                                                                  // number = 0;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  rowWidth = ctn
                                                                      .maxWidth;
                                                                  // number = 0;
                                                                });
                                                              }
                                                            },
                                                            onValueChanged:
                                                                (value) {
                                                              selectedMenuList!
                                                                      .menuList![
                                                                  selectedMenuList!
                                                                      .menuList!
                                                                      .indexWhere((e) =>
                                                                          e.menuCd ==
                                                                          element
                                                                              .menuCd)] = value;
                                                              // debugprint(selectedMenuList?.menuList?.toString());
                                                            },
                                                          );
                                                        }).toList()
                                                      : [
                                                          const SizedBox(),
                                                        ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            //   );
                            // },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Visibility(
                            visible: !widget.viewMode
                            //&& selectedItems.isNotEmpty
                            ,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: isMobile
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.end,
                                children: [
                                  ButtonCancel(
                                    text: "Cancel",
                                    width: context.deviceWidth() *
                                        (context.isDesktop() ? 0.11 : 0.35),
                                    onTap: () {
                                      // if (!(state is UserRoleSubmitLoading)) {
                                      context.back();
                                      // }
                                    },
                                  ),
                                  SizedBox(
                                    width: 8.wh,
                                  ),
                                  ButtonConfirm(
                                    text: "Select",
                                    onTap: () {
                                      context.closeDialog();
                                      widget.onComplete(selectedItems);
                                    },
                                    width: context.deviceWidth() *
                                        (context.isDesktop() ? 0.1 : 0.35),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          )
          //     ;
          //   },
          // ),
          ),
    );
  }
}

class MenuFeatureItem extends StatefulWidget {
  final double? width;
  final Function(Size?) getWidth;
  final Function(MenuFeature) onValueChanged;
  final bool viewMode;
  final MenuFeature model;
  const MenuFeatureItem({
    Key? key,
    required this.width,
    required this.model,
    required this.viewMode,
    required this.getWidth,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<MenuFeatureItem> createState() => _MenuFeatureItemState();
}

class _MenuFeatureItemState extends State<MenuFeatureItem> {
  final _cardWidgetKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.getWidth(_cardWidgetKey.currentContext?.size);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _cardWidgetKey,
      width: widget.width,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: sccBorder,
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            width: context.deviceWidth() * 0.155,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Text(
              '${widget.model.no}. ${widget.model.menuName ?? "[UNKNOWN MENU]"}',
              textAlign: TextAlign.left,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: context.scaleFont(16),
                // fontWeight: FontWeight.bold,
                color: sccBlack,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: (widget.model.menuFeatureList?.entries.isNotEmpty == true)
                ? widget.model.menuFeatureList!.entries.map((e) {
                    if (e.value.toString().toUpperCase() == "TRUE") {
                      return VccUnwrapCheckboxListtile(
                        title: e.key.toString(),
                        value: e.value.toString().toUpperCase() == "TRUE",
                        enabled: false, //!widget.viewMode,
                        onChanged: (value) {
                          MenuFeature returnModel = widget.model;
                          returnModel.menuFeatureList![e.key] = e.value;
                          widget.onValueChanged(returnModel);
                          // widget.onValueChanged({e.key.toString(): e.value.toString().toUpperCase() == "TRUE"});
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  }).toList()
                : [
                    const SizedBox(),
                  ],
          ),
        ],
      ),
    );
  }
}
