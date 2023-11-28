import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';

import '../theme/colors.dart';

class VccCheckboxTile extends StatefulWidget {
  final String? title;
  final bool? value;
  final bool enabled;
  final String? Function(bool?)? validator;
  final Function(bool)? onChanged;
  final double? textSize;
  const VccCheckboxTile({
    required this.title,
    required this.enabled,
    required this.value,
    required this.onChanged,
    this.textSize,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  State<VccCheckboxTile> createState() => _VccCheckboxTileState();
}

class _VccCheckboxTileState extends State<VccCheckboxTile> {
  bool secondaryValue = false;

  @override
  void didUpdateWidget(VccCheckboxTile oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.value != null) secondaryValue = widget.value!;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (widget.value != null) secondaryValue = widget.value!;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: secondaryValue,
      key: widget.key,
      enabled: widget.enabled,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (widget.enabled) {
                    setState(() {
                      secondaryValue = !secondaryValue;
                      state.didChange(secondaryValue);
                      if (widget.onChanged != null) {
                        widget.onChanged!(secondaryValue);
                      }
                    });
                  }
                },
                hoverColor: widget.enabled ? sccFillField : Colors.transparent,
                focusColor: Colors.transparent,
                child: SizedBox(
                  height: 40,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: secondaryValue
                                    ? Colors.transparent
                                    : sccText4,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: !widget.enabled
                                  ? sccButtonGrey
                                  : secondaryValue
                                      ? sccButtonPurple
                                      : sccWhite,
                              // gradient: LinearGradient(
                              //   begin: Alignment.topCenter,
                              //   end: Alignment.bottomCenter,
                              //   colors: secondaryValue
                              //       ? [
                              //           sccButtonLightBlue,
                              //           sccButtonBlue,
                              //         ]
                              //       : widget.enabled
                              //           ? [
                              //               sccWhite,
                              //               sccWhite,
                              //             ]
                              //           : [
                              //               sccInfoGrey,
                              //               sccInfoGrey,
                              //             ],
                              // ),
                            ),
                            child: IconButton(
                              padding:
                                  const EdgeInsets.all(0), // here is set 0 padding
                              icon: HeroIcon(
                                HeroIcons.check,
                                size: 40,
                                //transparent
                                color: secondaryValue
                                    ? sccWhite
                                    : Colors.transparent,
                              ),
                              onPressed: () {
                                if (widget.enabled) {
                                  setState(() {
                                    secondaryValue = !secondaryValue;
                                    state.didChange(secondaryValue);
                                    if (widget.onChanged != null) {
                                      widget.onChanged!(secondaryValue);
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            child: Text(
                              widget.title ?? "",
                              style: TextStyle(
                                fontSize:
                                    widget.textSize ?? context.scaleFont(16),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !state.isValid,
              child: Text(
                state.errorText ?? '',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: context.scaleFont(16),
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

class VccUnwrapCheckboxListtile extends StatefulWidget {
  final String? title;
  final bool? value;
  final bool enabled;
  final String? Function(bool?)? validator;
  final Function(bool)? onChanged;
  final double? textSize;
  const VccUnwrapCheckboxListtile({
    required this.title,
    required this.enabled,
    required this.value,
    required this.onChanged,
    this.textSize,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  State<VccUnwrapCheckboxListtile> createState() =>
      _VccUnwrapCheckboxListtileState();
}

class _VccUnwrapCheckboxListtileState extends State<VccUnwrapCheckboxListtile> {
  bool secondaryValue = false;

  @override
  void didUpdateWidget(VccUnwrapCheckboxListtile oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.value != null) secondaryValue = widget.value!;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (widget.value != null) secondaryValue = widget.value!;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: secondaryValue,
      key: widget.key,
      enabled: widget.enabled,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (widget.enabled) {
                    setState(() {
                      secondaryValue = !secondaryValue;
                      state.didChange(secondaryValue);
                      if (widget.onChanged != null) {
                        widget.onChanged!(secondaryValue);
                      }
                    });
                  }
                },
                hoverColor: widget.enabled ? sccFillField : Colors.transparent,
                focusColor: Colors.transparent,
                child: SizedBox(
                  height: 40,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: secondaryValue
                                    ? Colors.transparent
                                    : sccText4,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: !widget.enabled
                                  ? sccButtonGrey
                                  : secondaryValue
                                      ? sccButtonPurple
                                      : sccWhite,
                            ),
                            child: IconButton(
                              padding:
                                  const EdgeInsets.all(0), // here is set 0 padding
                              icon: HeroIcon(
                                HeroIcons.check,
                                size: 40,
                                //transparent
                                color: secondaryValue
                                    ? sccWhite
                                    : Colors.transparent,
                              ),
                              onPressed: () {
                                if (widget.enabled) {
                                  setState(() {
                                    secondaryValue = !secondaryValue;
                                    state.didChange(secondaryValue);
                                    if (widget.onChanged != null) {
                                      widget.onChanged!(secondaryValue);
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.title ?? "",
                          style: TextStyle(
                            fontSize: widget.textSize ?? context.scaleFont(16),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !state.isValid,
              child: Text(
                state.errorText ?? '',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: context.scaleFont(16),
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

class VccCheckboxTileFitted extends StatefulWidget {
  final String? title;
  final bool? value;
  final bool enabled;
  final String? Function(bool?)? validator;
  final Function(bool)? onChanged;
  final double? textSize;
  const VccCheckboxTileFitted({
    required this.title,
    required this.enabled,
    required this.value,
    required this.onChanged,
    this.textSize,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  State<VccCheckboxTileFitted> createState() => _VccCheckboxTileFittedState();
}

class _VccCheckboxTileFittedState extends State<VccCheckboxTileFitted> {
  bool secondaryValue = false;

  @override
  void didUpdateWidget(VccCheckboxTileFitted oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.value != null) secondaryValue = widget.value!;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (widget.value != null) secondaryValue = widget.value!;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: secondaryValue,
      key: widget.key,
      enabled: widget.enabled,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (widget.enabled) {
                    setState(() {
                      secondaryValue = !secondaryValue;
                      state.didChange(secondaryValue);
                      if (widget.onChanged != null) {
                        widget.onChanged!(secondaryValue);
                      }
                    });
                  }
                },
                hoverColor: sccFillField,
                focusColor: Colors.transparent,
                child: SizedBox(
                  height: 40,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: secondaryValue
                                    ? Colors.transparent
                                    : sccText4,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: secondaryValue
                                  ? sccButtonPurple
                                  : widget.enabled
                                      ? sccWhite
                                      : sccInfoGrey,
                            ),
                            child: IconButton(
                              padding:
                                  const EdgeInsets.all(0), // here is set 0 padding
                              icon: HeroIcon(
                                HeroIcons.check,
                                size: 60,
                                //transparent
                                color: secondaryValue ? sccWhite : Colors.white,
                              ),
                              onPressed: () {
                                if (widget.enabled) {
                                  setState(() {
                                    secondaryValue = !secondaryValue;
                                    state.didChange(secondaryValue);
                                    if (widget.onChanged != null) {
                                      widget.onChanged!(secondaryValue);
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.title ?? "",
                          style: TextStyle(
                            fontSize: widget.textSize ?? context.scaleFont(16),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !state.isValid,
              child: Text(
                state.errorText ?? '',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: context.scaleFont(16),
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
