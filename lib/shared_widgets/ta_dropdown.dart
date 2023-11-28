import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/outline_gradient_button.dart';
import 'package:scc_web/theme/colors.dart';

class TADropdown extends StatefulWidget {
  final List<KeyVal> options;
  final KeyVal? selectedItem;
  final EdgeInsetsGeometry? margin;
  final String? initialText, label;
  final Function(KeyVal) onChange;
  final Function(String?)? onStrChange;
  final Widget? suffix;
  final TextStyle? style;
  final bool readOnly, enabled, enableBorderColor;
  final bool? hideKeyboard; //, isDense;
  final FocusNode? focusNode;
  final double borderRadius;
  final Color? fillColor;
  final FloatingLabelBehavior behavior;
  final double? fontSize;
  final FontWeight? fontWeight;
  const TADropdown(this.selectedItem, this.options,
      {Key? key,
      this.label,
      this.margin,
      this.suffix,
      required this.onChange,
      this.onStrChange,
      this.readOnly = false,
      this.enabled = true,
      this.hideKeyboard,
      this.fillColor,
      this.style,
      this.focusNode,
      this.borderRadius = 8,
      this.behavior = FloatingLabelBehavior.auto,
      this.fontSize,
      this.fontWeight,
      this.enableBorderColor = false,
      this.initialText})
      : super(key: key);

  @override
  State<TADropdown> createState() => _TADropdownState();
}

class _TADropdownState extends State<TADropdown> {
  final boxController = SuggestionsBoxController();
  late TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    textController = TextEditingController(
        text: widget.selectedItem != null
            ? widget.selectedItem!.label
            : (widget.hideKeyboard ?? true)
                ? widget.initialText
                : null);

    return TypeAheadFormField<KeyVal>(
      suggestionsBoxController: boxController,
      textFieldConfiguration: TextFieldConfiguration(
        controller: textController,
        textAlignVertical: TextAlignVertical.bottom,
        enabled: widget.options.isNotEmpty && widget.enabled,
        onTap: () => boxController.toggle(),
        onChanged: (val) {
          if (widget.onStrChange != null) {
            widget.onStrChange!(val);
          }
        },
        // textAlignVertical: TextAlignVertical.center,
        style: widget.style ??
            TextStyle(
              color: widget.selectedItem != null ? sccBlack : sccText4,
              fontSize: widget.fontSize ?? 15,
              fontWeight: widget.fontWeight ?? FontWeight.bold,
              overflow: TextOverflow.fade,
            ),
        decoration: InputDecoration(
          hintText: widget.initialText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 9.5, horizontal: 12),
          hintStyle: widget.style ??
              TextStyle(
                color: widget.selectedItem != null ? null : sccText4,
                fontSize: widget.fontSize ?? 15,
                fontWeight: widget.fontWeight ?? FontWeight.bold,
                overflow: TextOverflow.fade,
              ),
          suffixIcon: widget.enabled
              ? Container(
                  margin: const EdgeInsets.all(8),
                  child: widget.suffix ??
                      // Image.asset(
                      //   'assets/dropdown_icon.png',
                      //   height: context.scaleFont(28),
                      //   width: context.scaleFont(28),
                      // ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (widget.options.isNotEmpty && widget.enabled) {
                            boxController.toggle();
                          }
                        },
                        // splashRadius: 10,
                        child:
                            // GradientWidget(
                            //   gradient: LinearGradient(
                            //     begin: Alignment.topCenter,
                            //     end: Alignment.bottomCenter,
                            //     colors: (!(widget.enabled) || widget.options.isEmpty)
                            //         ? [
                            //             sccText2,
                            //             sccText2,
                            //           ]
                            //         : [
                            //             sccButtonLightBlue,
                            //             sccButtonBlue,
                            //             sccButtonBlue,
                            //           ],
                            //   ),
                            //   child:
                            HeroIcon(
                          HeroIcons.chevronDown,
                          size: context.scaleFont(12),
                          color: sccText4,
                        ),
                      ),
                )
              : null,
          suffixIconColor: sccText4,
          isDense: true,
          floatingLabelBehavior: widget.behavior,
          enabled: widget.enabled,
          labelText: widget.label,
          labelStyle: TextStyle(
            fontSize: context.scaleFont(16),
            color: sccBlack,
          ),
          filled: true,
          fillColor: widget.fillColor ??
              (widget.enabled ? sccWhite : sccFillLoginField),
          hoverColor: widget.fillColor ??
              (widget.enabled ? sccWhite : sccFillLoginField),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                  color:
                      widget.enableBorderColor ? sccBorder : Colors.transparent,
                  width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccDanger, width: 0.5)), //
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccDanger, width: 0.5)),
        ),
      ),
      hideKeyboard: widget.hideKeyboard ?? true,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        constraints: BoxConstraints(maxHeight: context.deviceHeight() / 4),
      ),
      suggestionsBoxVerticalOffset: 8,
      suggestionsCallback: (value) => widget.options,
      itemBuilder: (context, suggestion) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            hoverColor: Colors.transparent,
            horizontalTitleGap: 8,
            minLeadingWidth: 10,
            onTap: () {
              boxController.close();
              textController.value =
                  textController.value.copyWith(text: suggestion.label);
              widget.onChange(suggestion);
            },
            leading: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: OutlineGradientButton(
                onTap: () {
                  boxController.close();
                  textController.value =
                      textController.value.copyWith(text: suggestion.label);
                  widget.onChange(suggestion);
                },
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: widget.selectedItem != null &&
                          widget.selectedItem!.value == suggestion.value
                      ? [
                          // sccButtonLightBlue,
                          sccButtonBlue,
                          sccButtonBlue,
                        ]
                      : [
                          sccInfoGrey,
                          sccInfoGrey,
                        ],
                ),
                strokeWidth: widget.selectedItem != null &&
                        widget.selectedItem!.value == suggestion.value
                    ? 1
                    : 0.5,
                padding: const EdgeInsets.all(1),
                radius: const Radius.circular(125),
                child: GradientWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: widget.selectedItem != null &&
                            widget.selectedItem!.value == suggestion.value
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
            title: Text(
              suggestion.label,
              style: TextStyle(
                color: sccBlack,
                //12 -> 14
                fontSize: widget.fontSize ?? context.scaleFont(14),
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        );
      },
      loadingBuilder: (context) {
        return const SizedBox();
      },
      onSuggestionSelected: (value) {
        // textController.value = textController.value.copyWith(text: value.label);
        // widget.onChange(value);
      },
    );
  }
}

class TAPagingDropdown extends StatefulWidget {
  final List<String> options;
  final String? selectedItem;
  final EdgeInsetsGeometry? margin;
  final String? initialText, label;
  final Function(String?) onChange;
  final Widget? suffix;
  final TextStyle? style;
  final bool readOnly, enabled;
  final bool isDense;
  final FocusNode? focusNode;
  final AxisDirection direction;
  final double borderRadius;
  final Color borderColor;
  final Color? fillColor;
  final FloatingLabelBehavior behavior;
  final double? fontSize;
  final FontWeight? fontWeight;
  const TAPagingDropdown(
    this.selectedItem,
    this.options, {
    Key? key,
    this.label = '',
    this.isDense = true,
    this.margin,
    this.suffix,
    required this.onChange,
    this.readOnly = false,
    this.enabled = true,
    this.fillColor,
    this.style,
    this.focusNode,
    this.initialText = '',
    this.borderRadius = 8,
    this.borderColor = sccTextGray,
    this.behavior = FloatingLabelBehavior.auto,
    this.fontSize,
    this.fontWeight,
    this.direction = AxisDirection.up,
  }) : super(key: key);

  @override
  State<TAPagingDropdown> createState() => _TAPagingDropdownState();
}

class _TAPagingDropdownState extends State<TAPagingDropdown> {
  final boxController = SuggestionsBoxController();
  late TextEditingController textController;
  // @override
  // void initState() {

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    textController =
        TextEditingController(text: widget.selectedItem ?? widget.initialText);
    return TypeAheadFormField<String>(
      suggestionsBoxController: boxController,
      direction: widget.direction,
      textFieldConfiguration: TextFieldConfiguration(
        controller: textController,
        enabled: widget.options.isNotEmpty && widget.enabled,
        onTap: () => boxController.toggle(),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.bottom,
        // textAlignVertical: TextAlignVertical.,
        style: widget.style ??
            TextStyle(
              color: widget.selectedItem != null ? sccBlack : sccText4,
              fontSize: widget.fontSize ?? 12,
            ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            child: widget.suffix ??
                // IconButton(
                //   onPressed: () {
                //     if (widget.options.isNotEmpty && widget.enabled) boxController.toggle();
                //   },
                //   splashRadius: 10,
                //   icon:
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (widget.options.isNotEmpty && widget.enabled) {
                      boxController.toggle();
                    }
                  },
                  child:
                      // GradientWidget(
                      //     gradient: LinearGradient(
                      //       begin: Alignment.topCenter,
                      //       end: Alignment.bottomCenter,
                      //       colors: [
                      //         sccButtonLightBlue,
                      //         sccButtonBlue,
                      //         sccButtonBlue,
                      //       ],
                      //     ),
                      // child:
                      const HeroIcon(
                    HeroIcons.chevronDown,
                    size: 14,
                    color: sccButtonBlue,
                  ),
                  // ),
                ),
          ),
          // ),
          isDense: widget.isDense,
          floatingLabelBehavior: widget.behavior,
          enabled: widget.enabled,
          labelText: widget.label,
          labelStyle: TextStyle(
            fontSize: context.scaleFont(16),
            color: sccBlack,
          ),
          filled: true,
          fillColor:
              widget.fillColor ?? (widget.enabled ? sccWhite : sccInfoGrey),
          hoverColor: widget.enabled ? sccWhite : sccInfoGrey,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.5)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: sccDanger, width: 0.5)), //
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: sccDanger, width: 0.5)),
        ),
        onChanged: (value) {
          widget.onChange(value);
        },
      ),
      hideKeyboard: false,
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        // constraints: BoxConstraints(maxHeight: context.deviceHeight() / 2),
      ),
      suggestionsBoxVerticalOffset: 8,
      suggestionsCallback: (value) => widget.options,
      itemBuilder: (context, suggestion) {
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          hoverColor: Colors.transparent,
          horizontalTitleGap: 8,
          minLeadingWidth: 10,
          onTap: () {
            boxController.close();
            textController.value =
                textController.value.copyWith(text: suggestion);
            widget.onChange(suggestion);
          },
          title: Text(
            suggestion,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: sccText1,
              fontSize: context.scaleFont(12),
              overflow: TextOverflow.clip,
            ),
          ),
        );
      },
      loadingBuilder: (context) {
        return const SizedBox();
      },
      onSuggestionSelected: (value) {
        // textController.value = textController.value.copyWith(text: value.label);
        // widget.onChange(value);
      },
    );
  }
}

class TAFormDropdown extends StatefulWidget {
  final List<KeyVal> options;
  final String? selectedItem;
  final EdgeInsetsGeometry? margin;
  final String? hintText, label;
  final Function(String?) onChange;
  final bool? updatable;
  final Function(String?)? onStrChange;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final TextStyle? style;
  final bool readOnly, enabled, enableBorderColor;
  final bool? isDense, hideKeyboard;
  final FocusNode? focusNode;
  final double borderRadius;
  final InputBorder? enabledBorder;
  final Color? hoverColor;

  ///* Constant fill color that ignore form state. When this called, [focusColor] & [idleColor] shall be ignored
  final Color? fillColor;

  ///* fill color when focus, if fillColor is [null]
  final Color? focusColor;

  ///* fill color when idle, if fillColor is [null]
  final Color? idleColor;

  final Color? borderColor;
  final FloatingLabelBehavior behavior;
  final double? fontSize;
  final FontWeight? fontWeight;
  const TAFormDropdown(this.selectedItem, this.options,
      {Key? key,
      this.label,
      this.isDense,
      this.margin,
      this.enabledBorder,
      this.suffix,
      required this.onChange,
      this.onStrChange,
      this.updatable,
      this.validator,
      this.readOnly = false,
      this.enabled = true,
      this.hideKeyboard,
      this.fillColor,
      this.hoverColor,
      this.focusColor,
      this.idleColor,
      this.style,
      this.borderColor,
      this.focusNode,
      this.hintText = '',
      this.borderRadius = 8,
      this.behavior = FloatingLabelBehavior.auto,
      this.fontSize,
      this.fontWeight,
      this.enableBorderColor = false})
      : super(key: key);

  @override
  State<TAFormDropdown> createState() => _TAFormDropdownState();
}

class _TAFormDropdownState extends State<TAFormDropdown> {
  final boxController = SuggestionsBoxController();
  late TextEditingController textController;
  List<KeyVal> searchList = [];

  String searchVal = '';
  // @override
  // void initState() {
  // textController = TextEditingController();
  //   super.initState();
  // }

  FocusNode focusNode = FocusNode();
  Color fillColor = sccWhite;
  bool valid = false;

  @override
  void didUpdateWidget(TAFormDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.updatable == true) {
      searchList.clear();
      searchList.addAll(widget.options);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          if (widget.selectedItem != null &&
              widget.options
                  .any((element) => element.value == widget.selectedItem)) {
            textController.value = textController.value.copyWith(
                text: widget.options
                    .firstWhere(
                        (element) => element.value == widget.selectedItem)
                    .label);
          } else {
            textController.value = textController.value.copyWith(text: "");
          }
        }));
  }

  @override
  void initState() {
    textController = TextEditingController();
    if (widget.selectedItem != null &&
        widget.options.any((element) => element.value == widget.selectedItem)) {
      textController.value = textController.value.copyWith(
          text: widget.options
              .firstWhere((element) => element.value == widget.selectedItem)
              .label);
    }

    // focusNode.addListener(() {
    //   if (focusNode.hasFocus) {
    //     setState(() {
    //       fillColor = widget.focusColor ?? sccWhite;
    //     });
    //   } else {
    //     setState(() {
    //       fillColor = widget.idleColor ?? sccFillLoginField;
    //     });
    //   }
    // });
    searchList.addAll(widget.options);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TypeAheadFormField<KeyVal>(
          suggestionsBoxController: boxController,
          textFieldConfiguration: TextFieldConfiguration(
            controller: textController,
            focusNode: widget.focusNode ?? focusNode,
            enabled: widget.options.isNotEmpty && widget.enabled,
            onTap: () => boxController.open(),
            // on
            onChanged: (val) {
              if (widget.onStrChange != null) {
                widget.onStrChange!(val);
              }
              // if (widget.hideKeyboard != true) {
              //   setState(() {
              //     searchList.clear();

              //     widget.options.forEach((element) {
              //       if (element.label.toUpperCase().contains(val.toUpperCase())) {
              //         searchList.add(element);
              //       }
              //     });
              //   });
              // }
            },
            textAlignVertical: TextAlignVertical.center,
            style: widget.style ??
                TextStyle(
                  color: sccBlack,
                  fontSize: context.scaleFont(15),
                  // fontWeight: widget.fontWeight,
                  // overflow: TextOverflow.fade,
                ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.style ??
                  TextStyle(
                    // color: widget.selectedItem != null ? sccBlack : sccText4,
                    fontSize: context.scaleFont(14),
                    fontWeight: FontWeight.w400,
                    // overflow: TextOverflow.fade,
                  ),
              suffixIcon: widget.enabled
                  ? ExcludeFocus(
                      child: widget.suffix ??
                          // Image.asset(
                          //   'assets/dropdown_icon.png',
                          //   height: context.scaleFont(28),
                          //   width: context.scaleFont(28),
                          // ),
                          IconButton(
                            onPressed: () {
                              if (widget.options.isNotEmpty && widget.enabled) {
                                boxController.open();
                              }
                            },
                            splashRadius: 10,
                            icon: HeroIcon(
                              HeroIcons.chevronDown,
                              size: context.scaleFont(20),
                              style: HeroIconStyle.solid,
                              color: sccButtonPurple,
                            ),
                          ),
                    )
                  : Container(
                      width: 1,
                    ),
              // suffixIconColor: sccButtonBlue,
              isDense: widget.isDense ?? true,
              floatingLabelBehavior: widget.behavior,
              enabled: widget.enabled,
              labelText: widget.label,
              labelStyle: TextStyle(
                fontSize: context.scaleFont(16),
                color: sccBlack,
              ),
              filled: true,
              fillColor: valid
                  ? sccValidateField
                  : (widget.fillColor != null)
                      ? widget.fillColor
                      : (!(widget.enabled))
                          ? sccDisabledTextField
                          : fillColor,
              hoverColor: widget.hoverColor ?? sccFillField,
              enabledBorder: widget.enabledBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: //hasFocus ?
                        BorderSide(
                            color: widget.borderColor ?? sccLightGray,
                            width: 1),
                    //  : BorderSide.none,
                  ), //(color: sccUnselect)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: widget.fillColor != null
                          ? sccLightGray
                          : sccUnselect)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: widget.fillColor ?? sccButtonBlue, width: 1)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: sccDanger)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: sccDanger, width: 1.5)),
            ),
          ),
          hideKeyboard: widget.hideKeyboard ?? true,
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            constraints: BoxConstraints(maxHeight: context.deviceHeight() / 4),
          ),
          suggestionsBoxVerticalOffset: 8,
          suggestionsCallback: (value) => widget.updatable == true
              ? searchList
              : ((widget.hideKeyboard ?? true) || value.toUpperCase() == "ALL")
                  ? widget.options
                  : List<KeyVal>.from(widget.options.where((element) => element
                      .label
                      .toUpperCase()
                      .contains(value.toUpperCase()))), // searchList,
          itemBuilder: (context, suggestion) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                hoverColor: Colors.transparent,
                horizontalTitleGap: 8,
                minLeadingWidth: 10,
                onTap: () {
                  boxController.close();
                  textController.value =
                      textController.value.copyWith(text: suggestion.label);
                  widget.onChange(suggestion.value);
                },
                leading: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: OutlineGradientButton(
                    onTap: () {
                      boxController.close();
                      textController.value =
                          textController.value.copyWith(text: suggestion.value);

                      widget.onChange(suggestion.value);
                    },
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: widget.selectedItem != null &&
                              widget.selectedItem == suggestion.value
                          ? [
                              // sccButtonLightBlue,
                              sccButtonBlue,
                              sccButtonBlue,
                            ]
                          : [
                              sccInfoGrey,
                              sccInfoGrey,
                            ],
                    ),
                    strokeWidth: widget.selectedItem != null &&
                            widget.selectedItem == suggestion.value
                        ? 1
                        : 0.5,
                    padding: const EdgeInsets.all(1),
                    radius: const Radius.circular(125),
                    child: GradientWidget(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: widget.selectedItem != null &&
                                widget.selectedItem == suggestion.value
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
                        size: context.scaleFont(13),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  suggestion.label,
                  style: TextStyle(
                    color: sccBlack,
                    fontSize: context.scaleFont(13),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            );
          },
          hideOnEmpty: true,
          loadingBuilder: (context) {
            return const SizedBox();
          },
          onSuggestionSelected: (value) {
            // textController.value = textController.value.copyWith(text: value.label);
            // widget.onChange(value);
          },
          validator: (value) {
            if (widget.validator != null) {
              final stringReturn = widget.validator!(value);
              setState(() {
                if (stringReturn != null && stringReturn.isNotEmpty) {
                  valid = true;
                } else {
                  valid = false;
                }
              });
              return stringReturn;
            } else {
              return null;
            }
          }, // widget.validator,
        ),
      ],
    );
  }
}
