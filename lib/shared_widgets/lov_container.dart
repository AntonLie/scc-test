import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/theme/colors.dart';

class LovFormContainer extends StatefulWidget {
  final String? hint, value, label;
  final bool? enabled;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final Color? fillColour;
  const LovFormContainer(
      {super.key,
      this.hint,
      this.value,
      this.label,
      this.enabled,
      this.onTap,
      this.validator,
      this.suffix,
      this.fillColour});

  @override
  State<LovFormContainer> createState() => _LovFormContainerState();
}

class _LovFormContainerState extends State<LovFormContainer> {
  bool onHovered = false;
  String? label, value;

  @override
  void didUpdateWidget(LovFormContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.updateable == true) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          label = widget.label;
          value = widget.value;
        }));
    // }
  }

  @override
  void initState() {
    label = widget.label;
    value = widget.value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String?>(
      initialValue: value,
      key: widget.key,
      enabled: (widget.enabled ?? true),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: context.deviceWidth(),
              child: InkWell(
                // focusColor: sccFillField,
                onTap: () {
                  if ((widget.onTap != null) && (widget.enabled ?? true)) {
                    widget.onTap!();
                  }
                },
                onHover: (value) {
                  setState(() {
                    onHovered = value;
                  });
                },
                child: Container(
                  // height: 45,
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
                      borderRadius: BorderRadius.circular(8),
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
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          label ?? (widget.hint ?? ""),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400,
                            color: widget.value != null
                                ? sccText3
                                : Theme.of(context).hintColor,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 2,
                      // ),
                      Visibility(
                        visible: widget.enabled != false,
                        child: widget.suffix ??
                            // GradientWidget(
                            //   gradient: LinearGradient(
                            //     begin: Alignment.topCenter,
                            //     end: Alignment.bottomCenter,
                            //     colors: [
                            //       sccButtonLightBlue,
                            //       sccButtonBlue,
                            //     ],
                            //   ),
                            //   child:
                            HeroIcon(
                              HeroIcons.chevronDown,
                              size: context.scaleFont(24),
                              color: sccText4,
                            ),
                      ),
                      // )
                    ],
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
                    fontSize: context.scaleFont(14),
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
