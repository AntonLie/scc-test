import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/drag_behaviour.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/screens/master_package/role_dialog.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';

class RoleField extends StatefulWidget {
  final List<KeyVal> selectedItems;
  final String? Function(List<KeyVal>?)? validator;
  final String? hintText;
  final Function(List<KeyVal>) onChange;
  final double? triggerWidth, borderRadius;
  final String? nameDialog;
  final bool? enabled;
  final Color? fillColour, borderColour;
  const RoleField(
    this.selectedItems, {
    required this.onChange,
    this.fillColour,
    this.borderColour,
    this.enabled,
    this.validator,
    this.borderRadius,
    this.hintText,
    this.triggerWidth,
    Key? key,
    this.nameDialog,
  }) : super(key: key);

  @override
  State<RoleField> createState() => _RoleFieldState();
}

class _RoleFieldState extends State<RoleField> {
  bool onHovered = false;
  // bool visible = false;
  List<KeyVal> selecteds = [];

  @override
  void initState() {
    selecteds = List.from(widget.selectedItems);
    super.initState();
  }

  @override
  void didUpdateWidget(RoleField oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selecteds = List.from(widget.selectedItems);
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<KeyVal>>(
      initialValue: widget.selectedItems,
      key: widget.key,
      enabled: (widget.enabled ?? true),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (ctx, ctns) {
                return InkWell(
                  onTap: () {
                    if (widget.enabled != false) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return LoVPackageRole(
                            nameDialog: widget.nameDialog,
                            viewMode: widget.enabled == false,
                            selectedItems: selecteds,
                            onComplete: (value) {
                              selecteds = List.from(value);
                              state.didChange(selecteds.map((e) => e).toList());
                              widget.onChange(selecteds.map((e) => e).toList());
                            },
                            onError: (value) {
                              showTopSnackBar(
                                  context, UpperSnackBar.error(message: value));
                            },
                            onLogout: () {
                              context.push(const LoginRoute());
                            },
                          );
                        },
                      );
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
                          color: (widget.enabled == false)
                              ? sccDisabledTextField
                              : (state.hasError)
                                  ? sccDanger
                                  : sccLightGray,
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
                                        return Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(4),
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                widget.borderRadius ?? 8),
                                            color: sccDisabled,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: Text(
                                                  e.label,
                                                  style: TextStyle(
                                                    fontSize:
                                                        context.scaleFont(14),
                                                    color: sccTextGray2,
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    widget.enabled != false,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selecteds.remove(e);
                                                    });
                                                    state.didChange(selecteds
                                                        .map((e) => e)
                                                        .toList());
                                                    widget.onChange(selecteds
                                                        .map((e) => e)
                                                        .toList());
                                                  },
                                                  child: HeroIcon(
                                                    HeroIcons.xMark,
                                                    size: context.scaleFont(18),
                                                    color: sccText4,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
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
                          visible:
                              selecteds.isNotEmpty && widget.enabled != false,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selecteds.clear();
                              });

                              state.didChange(selecteds.map((e) => e).toList());
                              widget.onChange(selecteds.map((e) => e).toList());
                            },
                            child: HeroIcon(
                              HeroIcons.xMark,
                              size: context.scaleFont(24),
                              color: sccText4,
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              selecteds.isNotEmpty && widget.enabled != false,
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
                            size: context.scaleFont(24),
                            color: sccText4,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
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
