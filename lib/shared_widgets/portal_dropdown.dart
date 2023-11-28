import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/drag_behaviour.dart';
import 'package:scc_web/helper/dynamic_ellipsis.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/outline_gradient_button.dart';
import 'package:scc_web/theme/colors.dart';

class PortalFormDropdown extends StatefulWidget {
  final String? selectedItem;
  final String? Function(String?)? validator;
  final List<KeyVal> items;
  // final bool? visible;
  // final Function(bool)? onVisibilityChange;
  final String? hintText;
  final Function(String) onChange;
  final Alignment? optAnchor, mainAnchor;
  final double? triggerWidth,
      portalWidth,
      borderRadius,
      borderRadiusTopLeft,
      borderRadiusTopRight,
      borderRadiusBotLeft,
      borderRadiusBotRight;
  final bool? enabled, isPopToTop;
  final Color? fillColour, borderColour;
  final EdgeInsetsGeometry? mainPadding, optPadding;
  final FontWeight? fontweight;

  const PortalFormDropdown(this.selectedItem, this.items,
      {required this.onChange,
      this.fillColour,
      this.borderColour,
      this.enabled,
      this.mainAnchor,
      this.optAnchor,
      // this.updateable,
      this.validator,
      this.borderRadius,
      this.hintText,
      this.portalWidth,
      this.triggerWidth,
      this.mainPadding,
      this.optPadding,
      Key? key,
      this.isPopToTop,
      this.borderRadiusTopLeft,
      this.borderRadiusTopRight,
      this.borderRadiusBotLeft,
      this.borderRadiusBotRight,
      this.fontweight})
      : super(key: key);

  @override
  State<PortalFormDropdown> createState() => _PortalFormDropdownState();
}

class _PortalFormDropdownState extends State<PortalFormDropdown> {
  bool visible = false;
  bool onHovered = false;
  String? label;
  List<KeyVal> searchList = [];
  // Color fillColor = sccFillLoginField;

  @override
  void didUpdateWidget(PortalFormDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.updateable == true) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          searchList.clear();
          searchList.addAll(widget.items);
          label = null;
          for (var item in widget.items) {
            if (item.value == widget.selectedItem) {
              label = item.label;
            }
          }
        }));
    // }
  }

  @override
  void initState() {
    label = null;
    for (var item in widget.items) {
      if (item.value == widget.selectedItem) {
        label = item.label;
      }
    }
    searchList.clear();
    searchList.addAll(widget.items);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return FormField<String?>(
      initialValue: widget.selectedItem,
      key: widget.key,
      enabled: (widget.enabled ?? true),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.triggerWidth ?? context.deviceWidth(),
              child: LayoutBuilder(
                builder: (ctx, ctns) => PortalTarget(
                  visible: visible,
                  portalFollower: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        visible = !visible;
                      });
                    },
                  ),
                  child: PortalTarget(
                    visible: visible,
                    // anchor: Aligned(
                    //   follower: widget.mainAnchor ?? Alignment.topCenter,
                    //   target: widget.optAnchor ?? Alignment.bottomCenter,
                    // ),
                    anchor: Aligned(
                      follower: widget.isPopToTop == true
                          ? Alignment.bottomLeft
                          : Alignment.topLeft,
                      target: widget.isPopToTop == true
                          ? Alignment.topLeft
                          : Alignment.bottomLeft,
                    ),
                    portalFollower: Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: widget.portalWidth ?? ctns.maxWidth,
                      height: searchList.length > 5
                          ? (context.deviceHeight() / 3)
                          : null,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(widget.borderRadiusTopLeft ?? 8),
                          bottomLeft:
                              Radius.circular(widget.borderRadiusBotLeft ?? 8),
                          topRight:
                              Radius.circular(widget.borderRadiusTopRight ?? 8),
                          bottomRight:
                              Radius.circular(widget.borderRadiusBotRight ?? 8),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: sccInfoGrey,
                            spreadRadius: 0.1,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                        color: sccWhite,
                      ),
                      child: Scrollbar(
                        controller: controller,
                        child: SingleChildScrollView(
                          padding:
                              widget.mainPadding ?? const EdgeInsets.all(10),
                          controller: controller,
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: searchList.isNotEmpty
                                ? searchList.map((e) {
                                    return Theme(
                                      data: ThemeData(
                                        hoverColor: sccFillField,
                                      ),
                                      child: ListTile(
                                        dense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8),
                                        hoverColor: Colors.transparent,
                                        horizontalTitleGap: 8,
                                        minLeadingWidth: 10,
                                        leading: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4),
                                          child: OutlineGradientButton(
                                            onTap: () {
                                              setState(() {
                                                visible = !visible;
                                                state.didChange(e.value);
                                                widget.onChange(e.value);
                                              });
                                            },
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors:
                                                  widget.selectedItem == e.value
                                                      ? [
                                                          sccButtonPurple,
                                                          sccButtonPurple,
                                                        ]
                                                      : [
                                                          sccInfoGrey,
                                                          sccInfoGrey,
                                                        ],
                                            ),
                                            strokeWidth:
                                                widget.selectedItem == e.value
                                                    ? 1
                                                    : 0.5,
                                            padding: const EdgeInsets.all(1),
                                            radius: const Radius.circular(125),
                                            child: GradientWidget(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: widget.selectedItem ==
                                                        e.value
                                                    ? [
                                                        // sccButtonLightBlue,

                                                        sccButtonPurple,
                                                        sccButtonPurple,
                                                      ]
                                                    : [
                                                        Colors.transparent,
                                                        Colors.transparent,
                                                      ],
                                              ),
                                              child: Icon(
                                                Icons.circle,
                                                size: context.scaleFont(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            visible = !visible;
                                            state.didChange(e.value);
                                            widget.onChange(e.value);
                                          });
                                        },
                                        title: Text(
                                          e.label,
                                          style: TextStyle(
                                            fontSize: context.scaleFont(14),
                                            color: sccBlack,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : [],
                          ),
                        ),
                      ),
                    ),
                    child: InkWell(
                      // focusColor: sccFillField,
                      onTap: () {
                        if (widget.enabled != false) {
                          setState(() {
                            visible = !visible;
                          });
                        }
                        // widget.onVisibilityChange(!widget.visible);
                      },
                      onHover: (value) {
                        setState(() {
                          onHovered = value;
                        });
                      },
                      child: Container(
                        width: widget.triggerWidth ?? ctns.maxWidth,
                        // height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: (widget.borderColour != null)
                                  ? widget.borderColour!
                                  : (widget.enabled == false)
                                      ? sccDisabledTextField
                                      : (state.hasError)
                                          ? sccDanger
                                          : sccLightGray,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  widget.borderRadiusTopLeft ?? 8),
                              bottomLeft: Radius.circular(
                                  widget.borderRadiusBotLeft ?? 8),
                              topRight: Radius.circular(
                                  widget.borderRadiusTopRight ?? 8),
                              bottomRight: Radius.circular(
                                  widget.borderRadiusBotRight ?? 8),
                            ),
                            color: (widget.fillColour != null)
                                ? widget.fillColour!
                                : (widget.enabled == false)
                                    ? sccDisabledTextField
                                    : onHovered
                                        ? sccFillField
                                        : (state.hasError)
                                            ? sccValidateField
                                            : sccWhite
                            // : VccFillLoginField,
                            ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                label ?? (widget.hintText ?? ""),
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: context.scaleFont(14),
                                  fontWeight:
                                      widget.fontweight ?? FontWeight.w400,
                                  color: widget.selectedItem != null
                                      ? sccText3
                                      : Theme.of(context).hintColor,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            Visibility(
                                visible: widget.enabled != false,
                                child: const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: sccButtonPurple,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: state.hasError,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  state.errorText ?? '',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: context.scaleFont(12),
                  ),
                ),
              ),
            )
          ],
        );
      },
      validator: widget.validator,
    );
  }
}

class PortalFormDropdownKeyVal extends StatefulWidget {
  final KeyVal? selectedItem;
  final String? Function(KeyVal?)? validator;
  final List<KeyVal> items;
  // final bool? visible;
  // final Function(bool)? onVisibilityChange;
  final String? hintText;
  final Function(KeyVal) onChange;
  final Function(bool)? hideSpecificComponent;
  final Alignment? optAnchor, mainAnchor;
  final double? triggerWidth,
      portalWidth,
      borderRadiusTopLeft,
      borderRadiusTopRight,
      borderRadiusBotLeft,
      borderRadiusBotRight,
      borderRadius;
  final bool? enabled;
  final Color? fillColour, borderColor;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? mainPadding, optPadding;
  const PortalFormDropdownKeyVal(this.selectedItem, this.items,
      {
      // this.visible,
      // this.onVisibilityChange,
      required this.onChange,
      this.hideSpecificComponent,
      this.fillColour,
      this.borderColor,
      this.enabled,
      this.mainAnchor,
      this.optAnchor,
      this.borderRadius,
      // this.updateable,
      this.validator,
      this.hintText,
      this.portalWidth,
      this.triggerWidth,
      this.mainPadding,
      this.optPadding,
      this.boxShadow,
      Key? key,
      this.borderRadiusTopLeft,
      this.borderRadiusTopRight,
      this.borderRadiusBotLeft,
      this.borderRadiusBotRight})
      : super(key: key);

  @override
  State<PortalFormDropdownKeyVal> createState() =>
      _PortalFormDropdownKeyValState();
}

class _PortalFormDropdownKeyValState extends State<PortalFormDropdownKeyVal> {
  bool visible = false;
  bool onHovered = false;
  String? label;
  List<KeyVal> searchList = [];

  @override
  void didUpdateWidget(PortalFormDropdownKeyVal oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          searchList.clear();
          searchList.addAll(widget.items);
          label = null;
          for (var item in widget.items) {
            if (widget.selectedItem != null &&
                item.value == widget.selectedItem!.value) {
              label = item.label;
            }
          }
        }));
  }

  @override
  void initState() {
    label = null;
    for (var item in widget.items) {
      if (widget.selectedItem != null &&
          item.value == widget.selectedItem!.value) {
        label = item.label;
      }
    }
    searchList.clear();
    searchList.addAll(widget.items);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return FormField<KeyVal?>(
      initialValue: widget.selectedItem,
      key: widget.key,
      enabled: (widget.enabled ?? true),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.triggerWidth ?? context.deviceWidth(),
              child: LayoutBuilder(
                builder: (ctx, ctns) => PortalTarget(
                  visible: visible,
                  portalFollower: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        visible = !visible;
                      });
                    },
                  ),
                  child: PortalTarget(
                    visible: visible,
                    anchor: Aligned(
                      follower: widget.mainAnchor ?? Alignment.topCenter,
                      target: widget.optAnchor ?? Alignment.bottomCenter,
                    ),
                    portalFollower: Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: widget.portalWidth ?? ctns.maxWidth,
                        height: searchList.length > 5
                            ? (context.deviceHeight() / 3)
                            : null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: sccInfoGrey,
                              spreadRadius: 0.1,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                          color: sccWhite,
                        ),
                        child: Scrollbar(
                          controller: controller,
                          child: SingleChildScrollView(
                            padding:
                                widget.mainPadding ?? const EdgeInsets.all(10),
                            controller: controller,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: searchList.isNotEmpty
                                  ? searchList.map((e) {
                                      return Theme(
                                        data: ThemeData(
                                          hoverColor: sccFillField,
                                        ),
                                        child: ListTile(
                                          dense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                          hoverColor: Colors.transparent,
                                          horizontalTitleGap: 8,
                                          minLeadingWidth: 10,
                                          leading: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: OutlineGradientButton(
                                              onTap: () {
                                                setState(() {
                                                  visible = !visible;
                                                  state.didChange(e);
                                                  widget.onChange(e);
                                                });
                                              },
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: widget.selectedItem !=
                                                            null &&
                                                        widget.selectedItem!
                                                                .value ==
                                                            e.value
                                                    ? [
                                                        // VccButtonLightBlue,
                                                        sccButtonBlue,
                                                        sccButtonBlue,
                                                      ]
                                                    : [
                                                        sccInfoGrey,
                                                        sccInfoGrey,
                                                      ],
                                              ),
                                              strokeWidth:
                                                  widget.selectedItem != null &&
                                                          widget.selectedItem!
                                                                  .value ==
                                                              e.value
                                                      ? 1
                                                      : 0.5,
                                              padding: const EdgeInsets.all(1),
                                              radius:
                                                  const Radius.circular(125),
                                              child: GradientWidget(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: widget.selectedItem !=
                                                              null &&
                                                          widget.selectedItem!
                                                                  .value ==
                                                              e.value
                                                      ? [
                                                          // sccButtonLightBlue,

                                                          sccButtonBlue,
                                                          sccButtonBlue,
                                                        ]
                                                      : [
                                                          Colors.transparent,
                                                          Colors.transparent,
                                                        ],
                                                ),
                                                child: Icon(
                                                  Icons.circle,
                                                  size: context.scaleFont(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              visible = !visible;
                                              state.didChange(e);
                                              widget.onChange(e);
                                            });
                                          },
                                          title: Text(
                                            e.label,
                                            style: TextStyle(
                                              fontSize: context.scaleFont(14),
                                              color: sccBlack,
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList()
                                  : [],
                            ),
                          ),
                        )),
                    child: InkWell(
                      onTap: () {
                        if (widget.enabled != false) {
                          setState(() {
                            visible = !visible;
                          });
                        }

                        if (widget.selectedItem != null) {
                          widget.hideSpecificComponent!(false);
                        }
                      },
                      onHover: (value) {
                        setState(() {
                          onHovered = value;
                        });
                      },
                      child: Container(
                        width: widget.triggerWidth ?? ctns.maxWidth,
                        height: 48,
                        decoration: BoxDecoration(
                            boxShadow: widget.boxShadow,
                            border: Border.all(
                              color: (widget.borderColor != null)
                                  ? widget.borderColor!
                                  : (widget.enabled == false)
                                      ? sccDisabledTextField
                                      : (state.hasError)
                                          ? sccDanger
                                          : sccLightGray,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  widget.borderRadiusTopLeft ?? 8),
                              bottomLeft: Radius.circular(
                                  widget.borderRadiusBotLeft ?? 8),
                              topRight: Radius.circular(
                                  widget.borderRadiusTopRight ?? 8),
                              bottomRight: Radius.circular(
                                  widget.borderRadiusBotRight ?? 8),
                            ),
                            color: (widget.fillColour != null)
                                ? widget.fillColour!
                                : (widget.enabled == false)
                                    ? sccDisabledTextField
                                    : onHovered
                                        ? sccFillField
                                        : (state.hasError)
                                            ? sccValidateField
                                            :
                                            // (visible)
                                            //     ?
                                            sccWhite
                            // : VccFillLoginField,
                            ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Text(
                                    dynamicEllipsis(
                                      context,
                                      constraints.maxWidth,
                                      (label ?? ("${widget.hintText}" ?? "")),
                                      TextStyle(
                                        fontSize: context.scaleFont(17.5),
                                        color: widget.selectedItem != null
                                            ? sccText3
                                            : Theme.of(context).hintColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: context.scaleFont(14),
                                      fontWeight: FontWeight.w400,
                                      color: widget.selectedItem != null
                                          ? sccText3
                                          : Theme.of(context).hintColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              visible: widget.enabled ?? true,
                              child: HeroIcon(
                                HeroIcons.chevronDown,
                                size: context.scaleFont(20),
                                color: sccNavText2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: state.hasError,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  state.errorText ?? '',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: context.scaleFont(12),
                  ),
                ),
              ),
            )
          ],
        );
      },
      validator: widget.validator,
    );
  }
}

class ColorDropdown extends StatefulWidget {
  final KeyVal? selectedItem;
  final String? Function(KeyVal?)? validator;
  final List<KeyVal> items;
  // final bool? visible;
  // final Function(bool)? onVisibilityChange;
  final String? hintText;
  final Function(KeyVal) onChange;
  final Alignment? optAnchor, mainAnchor;
  final double? triggerWidth, portalWidth, borderRadius;
  final bool? enabled;
  final Color? fillColour, borderColour;
  final EdgeInsetsGeometry? mainPadding, optPadding;
  const ColorDropdown(this.selectedItem, this.items,
      {
      // this.visible,
      // this.onVisibilityChange,
      required this.onChange,
      this.fillColour,
      this.borderColour,
      this.enabled,
      this.mainAnchor,
      this.optAnchor,
      // this.updateable,
      this.validator,
      this.borderRadius,
      this.hintText,
      this.portalWidth,
      this.triggerWidth,
      this.mainPadding,
      this.optPadding,
      Key? key})
      : super(key: key);

  @override
  State<ColorDropdown> createState() => _ColorDropdownState();
}

class _ColorDropdownState extends State<ColorDropdown> {
  bool visible = false;
  bool onHovered = false;
  String? label;
  List<KeyVal> searchList = [];
  // Color fillColor = VccFillLoginField;

  @override
  void didUpdateWidget(ColorDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.updateable == true) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          searchList.clear();
          searchList.addAll(widget.items);
          label = null;
          for (var item in widget.items) {
            if (item.value == widget.selectedItem?.value) {
              label = item.label;
            }
          }
        }));
    // }
  }

  @override
  void initState() {
    label = null;
    for (var item in widget.items) {
      if (item.value == widget.selectedItem?.value) {
        label = item.label;
      }
    }
    searchList.clear();
    searchList.addAll(widget.items);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return FormField<KeyVal?>(
      initialValue: widget.selectedItem,
      key: widget.key,
      enabled: (widget.enabled ?? true),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.triggerWidth ?? context.deviceWidth(),
              child: LayoutBuilder(
                builder: (ctx, ctns) {
                  return PortalTarget(
                    visible: visible,
                    portalFollower: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                    ),
                    child: PortalTarget(
                      visible: visible,
                      anchor: Aligned(
                        follower: widget.mainAnchor ?? Alignment.topCenter,
                        target: widget.optAnchor ?? Alignment.bottomCenter,
                      ),
                      portalFollower: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(4),
                        width: widget.portalWidth ?? ctns.maxWidth,
                        constraints: BoxConstraints(
                          maxHeight: (context.deviceHeight() / 3),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: sccInfoGrey,
                              spreadRadius: 0.1,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                          color: sccWhite,
                        ),
                        child: Scrollbar(
                          controller: controller,
                          child: SingleChildScrollView(
                            controller: controller,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: searchList.isNotEmpty
                                      ? searchList.map((e) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                visible = !visible;
                                                state.didChange(e);
                                                widget.onChange(e);
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              padding: const EdgeInsets.all(12),
                                              margin: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: stringToColor(e.toParse),
                                              ),
                                              child: HeroIcon(
                                                HeroIcons.check,
                                                size: context.scaleFont(28),
                                                color: (e.value ==
                                                        widget.selectedItem
                                                            ?.value)
                                                    ? sccWhite
                                                    : stringToColor(e.toParse),
                                              ),
                                            ),
                                          );
                                        }).toList()
                                      : [],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      child: InkWell(
                        // focusColor: VccFillField,
                        onTap: () {
                          if (widget.enabled != false) {
                            setState(() {
                              visible = !visible;
                            });
                          }
                        },
                        onHover: (value) {
                          setState(() {
                            onHovered = value;
                          });
                        },
                        child: Container(
                          width: widget.triggerWidth ?? ctns.maxWidth,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: (widget.borderColour != null)
                                    ? widget.borderColour!
                                    : (widget.enabled == false)
                                        ? sccDisabledTextField
                                        : (state.hasError)
                                            ? sccDanger
                                            : sccLightGray,
                              ),
                              borderRadius: BorderRadius.circular(
                                  widget.borderRadius ?? 8),
                              color: (widget.fillColour != null)
                                  ? widget.fillColour!
                                  : (widget.enabled == false)
                                      ? sccDisabledTextField
                                      : onHovered
                                          ? sccFillField
                                          : (state.hasError)
                                              ? sccValidateField
                                              : sccWhite
                              // : sccFillLoginField,
                              ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  label ?? (widget.hintText ?? ""),
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w400,
                                    color: widget.selectedItem != null
                                        ? sccText3
                                        : Theme.of(context).hintColor,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),

                              Visibility(
                                visible: widget.enabled != false,
                                child: HeroIcon(
                                  HeroIcons.chevronDown,
                                  size: context.scaleFont(20),
                                  color: sccText4,
                                  // color: sccButtonBlue,
                                ),
                              ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: state.hasError,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  state.errorText ?? '',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: context.scaleFont(12),
                  ),
                ),
              ),
            )
          ],
        );
      },
      validator: widget.validator,
    );
  }
}

class PortalDropdown extends StatefulWidget {
  final KeyVal? selectedItem;
  final List<KeyVal> items;
  // final bool? visible;
  // final Function(bool)? onVisibilityChange;
  final String? hintText;
  final bool? enabled, isBold;
  final Function(KeyVal) onChange;
  final Alignment? optAnchor, mainAnchor;
  final double? triggerWidth,
      portalWidth,
      borderRadius,
      borderRadiusTopLeft,
      borderRadiusTopRight,
      borderRadiusBotLeft,
      borderRadiusBotRight;
  final Color? colour, constantColour;
  final EdgeInsetsGeometry? mainPadding, optPadding;
  const PortalDropdown(
      {super.key,
      this.selectedItem,
      required this.items,
      this.hintText,
      this.enabled,
      this.isBold,
      required this.onChange,
      this.optAnchor,
      this.mainAnchor,
      this.triggerWidth,
      this.portalWidth,
      this.borderRadius,
      this.colour,
      this.constantColour,
      this.mainPadding,
      this.optPadding,
      this.borderRadiusTopLeft,
      this.borderRadiusTopRight,
      this.borderRadiusBotLeft,
      this.borderRadiusBotRight});

  @override
  State<PortalDropdown> createState() => _PortalDropdownState();
}

class _PortalDropdownState extends State<PortalDropdown> {
  bool visible = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return SizedBox(
      width: widget.triggerWidth ?? context.deviceWidth() * 0.17,
      child: LayoutBuilder(
        builder: (ctx, ctns) {
          return PortalTarget(
            visible: visible,
            portalFollower: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  visible = !visible;
                });
              },
            ),
            child: PortalTarget(
              visible: visible,
              anchor: Aligned(
                follower: widget.mainAnchor ?? Alignment.topCenter,
                target: widget.optAnchor ?? Alignment.bottomCenter,
              ),
              portalFollower: Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: widget.portalWidth ?? ctns.maxWidth,
                  height: widget.items.length > 5
                      ? (context.deviceHeight() / 3)
                      : null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: sccInfoGrey,
                        spreadRadius: 0.1,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: sccWhite,
                  ),
                  child: Scrollbar(
                    controller: controller,
                    child: SingleChildScrollView(
                      padding: widget.mainPadding ?? const EdgeInsets.all(10),
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.items.isNotEmpty
                            ? widget.items.map((e) {
                                return PortalOption(
                                  label: e.label,
                                  isSelected: ((widget.selectedItem != null) &&
                                      (widget.selectedItem!.value == e.value)),
                                  onTap: () {
                                    setState(() {
                                      visible = !visible;
                                    });
                                    widget.onChange(e);
                                  },
                                );
                              }).toList()
                            : [],
                      ),
                    ),
                  )),
              child: InkWell(
                onTap: () {
                  if (widget.enabled != false) {
                    setState(() {
                      visible = !visible;
                    });
                  }
                },
                child: Container(
                  width: widget.triggerWidth ?? ctns.maxWidth,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.borderRadiusTopLeft ?? 8),
                      bottomLeft:
                          Radius.circular(widget.borderRadiusBotLeft ?? 8),
                      topRight:
                          Radius.circular(widget.borderRadiusTopRight ?? 8),
                      bottomRight:
                          Radius.circular(widget.borderRadiusBotRight ?? 8),
                    ),
                    color: widget.constantColour ??
                        ((widget.enabled == false)
                            ? sccDisabledTextField
                            : (widget.colour ?? sccWhite)),
                  ),
                  padding: widget.mainPadding ??
                      const EdgeInsets.only(
                          top: 2, bottom: 2, left: 8, right: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.selectedItem != null
                              ? widget.selectedItem!.label
                              : (widget.hintText ?? ""),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: (widget.isBold ?? true)
                                ? FontWeight.bold
                                : FontWeight.w400,
                            color: widget.selectedItem != null
                                ? sccText3
                                : sccHintText,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: sccButtonPurple,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PortalOption extends StatefulWidget {
  final Function() onTap;
  final bool isSelected;
  final String label;
  const PortalOption(
      {super.key,
      required this.onTap,
      required this.isSelected,
      required this.label});

  @override
  State<PortalOption> createState() => _PortalOptionState();
}

class _PortalOptionState extends State<PortalOption> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (value) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (value) {
        setState(() {
          hovered = false;
        });
      },
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        hoverColor: Colors.transparent,
        horizontalTitleGap: 8,
        minLeadingWidth: 10,
        leading: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: OutlineGradientButton(
            onTap: () {
              widget.onTap();
            },
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: (widget.isSelected || hovered)
                  ? [
                      sccButtonPurple,
                      sccButtonPurple,
                    ]
                  : [
                      sccInfoGrey,
                      sccInfoGrey,
                    ],
            ),
            strokeWidth: widget.isSelected ? 1 : 0.5,
            padding: const EdgeInsets.all(1),
            radius: const Radius.circular(125),
            child: Icon(
              Icons.circle,
              size: context.scaleFont(12),
              color: (widget.isSelected || hovered)
                  ? sccButtonPurple
                  : Colors.transparent,
            ),
          ),
        ),
        onTap: () {
          widget.onTap();
        },
        title: Text(
          widget.label,
          style: TextStyle(
            fontSize: context.scaleFont(14),
            color: sccBlack,
            overflow: TextOverflow.clip,
          ),
        ),
      ),
    );
  }
}

class PortalFormMultipleDropdown extends StatefulWidget {
  final List<String> opt;
  final String? Function(List<String>?)? validator;
  final List<KeyVal> items;
  // final bool? visible;
  // final Function(bool)? onVisibilityChange;
  final String? hintText;
  final Function(List<String>) onChange;
  final Alignment? optAnchor, mainAnchor;
  final double? triggerWidth, portalWidth, borderRadius;
  final bool? enabled;
  final ScrollController? controller;
  final Color? fillColour, borderColour;
  final EdgeInsetsGeometry? mainPadding, optPadding;
  const PortalFormMultipleDropdown(this.opt, this.items,
      {
      // this.visible,
      // this.onVisibilityChange,
      required this.onChange,
      this.fillColour,
      this.borderColour,
      this.enabled,
      this.mainAnchor,
      this.optAnchor,
      // this.updateable,
      this.validator,
      this.borderRadius,
      this.hintText,
      this.portalWidth,
      this.triggerWidth,
      this.mainPadding,
      this.optPadding,
      Key? key,
      this.controller})
      : super(key: key);

  @override
  State<PortalFormMultipleDropdown> createState() =>
      _PortalFormMultipleDropdownState();
}

class _PortalFormMultipleDropdownState
    extends State<PortalFormMultipleDropdown> {
  bool visible = false;
  bool onHovered = false;
  List<String> selecteds = [];
  List<KeyVal> searchList = [];
  // Color fillColor = VccFillLoginField;

  @override
  void didUpdateWidget(PortalFormMultipleDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.updateable == true) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          searchList.clear();
          searchList.addAll(widget.items);
          selecteds.clear();
          selecteds.addAll(widget.opt);
        }));
    // }
  }

  @override
  void initState() {
    searchList.clear();
    searchList.addAll(widget.items);
    selecteds.clear();
    selecteds.addAll(widget.opt);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = ScrollController();
    return FormField<List<String>>(
      initialValue: widget.opt,
      key: widget.key,
      enabled: (widget.enabled ?? true),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.triggerWidth ?? context.deviceWidth(),
              child: LayoutBuilder(
                builder: (ctx, ctns) => PortalTarget(
                  visible: visible,
                  portalFollower: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        visible = !visible;
                      });
                    },
                  ),
                  child: PortalTarget(
                    visible: visible,
                    anchor: Aligned(
                      follower: widget.mainAnchor ?? Alignment.topCenter,
                      target: widget.optAnchor ?? Alignment.bottomCenter,
                    ),
                    portalFollower: Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: widget.portalWidth ?? ctns.maxWidth,
                        height: searchList.length > 5
                            ? (context.deviceHeight() / 3)
                            : null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: sccInfoGrey,
                              spreadRadius: 0.1,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                          color: sccWhite,
                        ),
                        child: Scrollbar(
                          controller: widget.controller,
                          child: SingleChildScrollView(
                            padding:
                                widget.mainPadding ?? const EdgeInsets.all(10),
                            controller: widget.controller,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: searchList.isNotEmpty
                                  ? searchList.map((e) {
                                      return Theme(
                                        data: ThemeData(
                                          hoverColor: sccFillField,
                                        ),
                                        child: CheckboxListTile(
                                            enabled: true,
                                            value: (selecteds.any((element) =>
                                                element == e.value)),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                if (!(selecteds.any((element) =>
                                                    element == e.value))) {
                                                  selecteds.add(e.value);
                                                } else {
                                                  selecteds.removeWhere(
                                                      (element) =>
                                                          element == e.value);
                                                }

                                                state.didChange(selecteds);
                                                widget.onChange(selecteds);
                                              });
                                            },
                                            title: Text(e.label)),
                                      );
                                    }).toList()
                                  : [],
                            ),
                          ),
                        )),
                    child: InkWell(
                      onTap: () {
                        if (widget.enabled != false) {
                          setState(() {
                            visible = !visible;
                          });
                        }
                      },
                      onHover: (value) {
                        setState(() {
                          onHovered = value;
                        });
                      },
                      child: Container(
                        width: widget.triggerWidth ?? ctns.maxWidth,
                        height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  // (widget.borderColour != null)
                                  //     ? widget.borderColour!
                                  //     : (widget.fillColour != null)
                                  //         ? widget.fillColour!
                                  //         :
                                  (widget.enabled == false)
                                      ? sccDisabledTextField
                                      : (state.hasError)
                                          ? sccDanger
                                          :
                                          // (visible)
                                          //     ? sccButtonBlue
                                          //     :
                                          sccLightGray,
                            ),
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius ?? 8),
                            color: (widget.fillColour != null)
                                ? widget.fillColour!
                                : (widget.enabled == false)
                                    ? sccDisabledTextField
                                    : onHovered
                                        ? sccFillField
                                        : (state.hasError)
                                            ? sccValidateField
                                            :
                                            // (visible)
                                            //     ?
                                            sccWhite
                            // : sccFillLoginField,
                            ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: ScrollConfiguration(
                                behavior: DragBehavior(),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: selecteds.isNotEmpty
                                        ? selecteds.map((e) {
                                            if (searchList.any((element) =>
                                                element.value == e)) {
                                              return Container(
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.all(4),
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          widget.borderRadius ??
                                                              8),
                                                  color: sccDisabled,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4),
                                                      child: Text(
                                                        searchList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .value ==
                                                                    e,
                                                                orElse: () =>
                                                                    KeyVal(
                                                                        "", ""))
                                                            .label,
                                                        style: TextStyle(
                                                          fontSize: context
                                                              .scaleFont(14),
                                                          color: sccTextGray2,
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: widget.enabled !=
                                                          false,
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selecteds.remove(e);
                                                          });
                                                          state.didChange(
                                                              selecteds);
                                                          widget.onChange(
                                                              selecteds);
                                                        },
                                                        child: HeroIcon(
                                                          HeroIcons.xMark,
                                                          size: context
                                                              .scaleFont(18),
                                                          color: sccText4,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          }).toList()
                                        : [
                                            Text(
                                              widget.hintText ?? "",
                                              style: TextStyle(
                                                fontSize: context.scaleFont(14),
                                                color: sccHintText,
                                              ),
                                            ),
                                          ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selecteds.isNotEmpty &&
                                  widget.enabled != false,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selecteds.clear();
                                  });

                                  state.didChange(selecteds);
                                  widget.onChange(selecteds);
                                },
                                child: HeroIcon(
                                  HeroIcons.xMark,
                                  size: context.scaleFont(24),
                                  color: sccText4,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selecteds.isNotEmpty &&
                                  widget.enabled != false,
                              child: const VerticalDivider(
                                color: sccText4,
                                width: 12,
                                thickness: 1,
                              ),
                            ),
                            Visibility(
                              visible: widget.enabled != false,
                              child: HeroIcon(
                                HeroIcons.chevronDown,
                                size: context.scaleFont(20),
                                color: sccText4,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: state.hasError,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  state.errorText ?? '',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: context.scaleFont(12),
                  ),
                ),
              ),
            )
          ],
        );
      },
      validator: widget.validator,
    );
  }
}
