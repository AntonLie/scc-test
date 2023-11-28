// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class CustomCheckboxListTile extends StatefulWidget {
  final String? title;
  final bool? value;
  final bool enabled;
  final bool validate;
  final bool? mandatory;
  final Function(bool)? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  const CustomCheckboxListTile({
    this.title,
    required this.enabled,
    this.validate = false,
    this.value,
    this.onChanged,
    this.mandatory,
    this.contentPadding,
    Key? key,
  });
  @override
  _CustomCheckboxListTileState createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  bool secondaryValue = false;

  @override
  void initState() {
    if (widget.value != null) secondaryValue = widget.value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final oldCheckboxTheme = theme.checkboxTheme;

    // final newCheckBoxTheme = oldCheckboxTheme.copyWith(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    // );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          focusColor: sccFillField,
          highlightColor: sccFillField,
          onTap: () {
            if (widget.enabled) {
              setState(() {
                secondaryValue = !secondaryValue;
              });
              if (widget.onChanged != null) widget.onChanged!(secondaryValue);
            }
          },
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Stack(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: secondaryValue
                            ? SvgPicture.asset(
                                Constant.knobOn,
                                key: UniqueKey(),
                              )
                            : SvgPicture.asset(
                                Constant.knobOff,
                                key: UniqueKey(),
                              ),
                      ),
                      Visibility(
                        visible: !widget.enabled,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: sccCheckbox.withOpacity(0.5),
                          ),
                        ),
                      )
                    ],
                  )),
              widget.mandatory != null && widget.mandatory!
                  ? StyledText(
                      text: '${widget.title ?? '<Title>'}<r> *</r>',
                      style: TextStyle(
                          fontSize: context.scaleFont(14),
                          fontWeight: FontWeight.w400),
                      tags: {
                        'r': StyledTextTag(
                            style: TextStyle(
                                fontSize: context.scaleFont(14),
                                fontWeight: FontWeight.w400,
                                color: sccDanger))
                      },
                    )
                  : Text(
                      widget.title ?? '<Title>',
                      style: TextStyle(
                          fontSize: context.scaleFont(14),
                          fontWeight: FontWeight.w400,
                          color: widget.enabled ? sccText3 : sccCheckbox),
                    ),
            ],
          ),
        ),

        // Theme(
        //   data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
        //   child: GradientWidget(
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [
        //         sccButtonLightBlue,
        //         sccButtonBlue,
        //       ],
        //     ),
        //     child: CheckboxListTile(
        //       contentPadding: widget.contentPadding,
        //       controlAffinity: ListTileControlAffinity.leading,
        //       value: secondaryValue,
        //       activeColor: sccButtonBlue,
        //       title: widget.mandatory != null && widget.mandatory!
        //           ? StyledText(
        //               text: (widget.title ?? '<Title>') + '<r> *</r>',
        //               style: TextStyle(fontSize: context.scaleFont(14), fontWeight: FontWeight.w400),
        //               tags: {
        //                 'r': StyledTextTag(
        //                     style: TextStyle(
        //                         fontSize: context.scaleFont(14), fontWeight: FontWeight.w400,
        //                         color: sccDanger))
        //               },
        //             )
        //           : Text(
        //               widget.title ?? '<Title>',
        //               style: TextStyle(fontSize: context.scaleFont(14), fontWeight: FontWeight.w400),
        //             ),
        //       // subtitle: SelectableText(widget.subtitle),
        //       onChanged: (value) {
        //         if (widget.enabled && value != null) {
        //           setState(() {
        //             secondaryValue = value;
        //           });
        //           if (widget.onChanged != null) widget.onChanged!(value);
        //         }
        //       },
        //     ),
        //   ),
        // ),
        Visibility(
          visible: widget.validate && !secondaryValue,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: SelectableText(
              "This field is mandatory",
              style: TextStyle(fontSize: 12, color: sccDanger),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color checkedIconColor;
  final Color checkedFillColor;
  final Widget? checkedIcon;
  final Color uncheckedIconColor;
  final Color uncheckedFillColor;
  final Widget? uncheckedIcon;
  final double? borderWidth;
  // final double? checkBoxSize;
  final bool shouldShowBorder;
  final Color? borderColor;
  final double? borderRadius;
  final double? splashRadius;
  final Color? splashColor;
  final String? tooltip;
  final MouseCursor? mouseCursors;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.checkedIconColor = Colors.white,
    this.checkedFillColor = Colors.blue,
    this.checkedIcon,
    this.uncheckedIconColor = Colors.transparent,
    this.uncheckedFillColor = Colors.white,
    this.uncheckedIcon,
    this.borderWidth,
    // this.checkBoxSize,
    this.shouldShowBorder = false,
    this.borderColor,
    this.borderRadius,
    this.splashRadius,
    this.splashColor = Colors.transparent,
    this.tooltip,
    this.mouseCursors,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _checked;
  late CheckStatus _status;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    _checked = widget.value;
    if (_checked) {
      _status = CheckStatus.checked;
    } else {
      _status = CheckStatus.unchecked;
    }
  }

  Widget _buildIcon() {
    late Color fillColor;
    late Color iconColor;
    late Widget iconData;

    switch (_status) {
      case CheckStatus.checked:
        fillColor = widget.checkedFillColor;
        iconColor = widget.checkedIconColor;
        iconData = widget.checkedIcon ??
            Icon(
              Icons.check,
              color: iconColor,
              // size: widget.checkBoxSize ?? 18,
            );
        break;
      case CheckStatus.unchecked:
        fillColor = widget.uncheckedFillColor;
        iconColor = widget.uncheckedIconColor;
        iconData = widget.uncheckedIcon ??
            Icon(
              Icons.close,
              color: iconColor,
              // size: widget.checkBoxSize ?? 18,
            );
        break;
    }

    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius:
            BorderRadius.all(Radius.circular(widget.borderRadius ?? 8)),
        border: Border.all(
          color: widget.shouldShowBorder
              ? (widget.borderColor ?? Colors.teal.withOpacity(0.6))
              : (!widget.value
                  ? (widget.borderColor ?? Colors.teal.withOpacity(0.6))
                  : Colors.transparent),
          width: widget.shouldShowBorder ? widget.borderWidth ?? 2.0 : 1.0,
        ),
      ),
      child: iconData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _buildIcon(),
      onPressed: () => widget.onChanged(!_checked),
      splashRadius: widget.splashRadius,
      splashColor: widget.splashColor,
      tooltip: widget.tooltip,
      mouseCursor: widget.mouseCursors ?? SystemMouseCursors.click,
    );
  }
}

enum CheckStatus {
  checked,
  unchecked,
}
