// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

import 'package:scc_web/helper/app_scale.dart';

import 'dart:math' as math;

import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/theme/colors.dart';

class CustomFormTextField extends StatefulWidget {
  final Key? key;
  final String? hint, label;
  final Function(String?)? onChanged, onAction;
  final String? Function(String?)? validator;
  final Color? hoverColor, cursorColor;

  ///* Constant fill color that ignore form state. When this called, [focusColor] & [idleColor] shall be ignored
  final Color? fillColor;

  ///* fill color when focus, if fillColor is [null]
  final Color? focusColor;

  ///* fill color when idle, if fillColor is [null]
  final Color? idleColor;
  final Function()? onTap;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputformat;
  final FocusNode? focusNode;
  final bool? readOnly, enabled, obscureText;
  final bool isDense;
  final int? maxLine, maxLength, minLine, precision;
  final Widget? suffix;
  final Widget? prefix;
  final String? errorMessage;
  final OutlineInputBorder? enabledBorder,
      disabledBorder,
      focusedBorder,
      errorBorder,
      focusedErrorBorder;

  const CustomFormTextField(
      {this.key,
      this.hint,
      this.label,
      this.validator,
      this.precision,
      this.onChanged,
      this.onAction,
      this.inputType,
      this.inputAction,
      this.focusNode,
      this.fillColor,
      this.hoverColor,
      this.focusColor,
      this.idleColor,
      this.cursorColor,
      this.readOnly,
      this.onTap,
      this.controller,
      this.inputformat,
      this.enabled,
      this.maxLine,
      this.minLine,
      this.maxLength,
      this.isDense = true,
      this.enabledBorder,
      this.disabledBorder,
      this.focusedBorder,
      this.errorBorder,
      this.focusedErrorBorder,
      this.suffix,
      this.prefix,
      this.obscureText,
      this.errorMessage})
      : super(key: key);

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  FocusNode focusNode = FocusNode();
  Color fillColor = sccWhite;
  bool valid = false;

  @override
  void initState() {
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
    super.initState();
  }

  // bool hasFocus = false;
  @override
  Widget build(BuildContext context) {
    // final focusNode = FocusNode();
    return TextFormField(
      // enableInteractiveSelection: this.inputType != TextInputType.number,
      inputFormatters: widget.inputType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : widget.inputType ==
                  const TextInputType.numberWithOptions(decimal: true)
              ? [DecimalTextInputFormatter(decimalRange: widget.precision ?? 2)]
              : widget.inputformat ??
                  [
                    FilteringTextInputFormatter.allow(
                      Constant
                          .regExp, // Hanya huruf, angka, _, -, spasi, @, +, dan .
                    ),
                  ],
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
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
      }, //this.widget.validator,
      onChanged: widget.onChanged,
      focusNode: (widget.focusNode ?? focusNode),
      keyboardType: widget.inputType,
      maxLength: widget.maxLength,
      maxLines: widget.maxLine,
      minLines: widget.minLine,
      obscureText: widget.obscureText ?? false,
      cursorColor: widget.cursorColor,
      // inputFormatters: inputformat,
      textInputAction: widget.inputAction,
      onFieldSubmitted: widget.onAction,
      onTap: widget.onTap,
      // cursorColor: this.widget.cursorColor ?? sccFillLoginField,
      style: TextStyle(
        color: sccBlack,
        fontSize: context.scaleFont(14),
      ),
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 14, color: sccDanger),
        errorText: widget.errorMessage,
        counterText: '',
        // contentPadding: EdgeInsets.only(bottom: 0,top: 0, left: 10),
        suffixIcon: (widget.enabled ?? true)
            ? widget.suffix ??
                (widget.onTap != null
                    ? ExcludeFocus(
                        child:
                            //  IconButton(
                            //   onPressed: this.widget.onTap,
                            //   splashRadius: 10,
                            //   icon: GradientWidget(
                            //     gradient: LinearGradient(
                            //       begin: Alignment.topCenter,
                            //       end: Alignment.bottomCenter,
                            //       colors: [
                            //         sccButtonLightBlue,
                            //         sccButtonBlue,
                            //         sccButtonBlue,
                            //       ],
                            //     ),
                            //     child:
                            HeroIcon(
                          HeroIcons.chevronDown,
                          size: context.scaleFont(28),
                          color: sccText4,
                        ),
                      ) //,
                    // ),
                    // )
                    : null)
            : null,
        prefixIcon: widget.prefix,
        isDense: widget.isDense,
        enabled: widget.enabled ?? true,
        labelText: widget.label,
        // focusColor: sccWhite,
        labelStyle: TextStyle(
          fontSize: context.scaleFont(14),
          color: sccBlack,
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontSize: context.scaleFont(14),
        ),
        filled: true,
        hoverColor: widget.hoverColor ?? sccFillField,
        fillColor: valid
            ? sccValidateField
            : (widget.fillColor != null)
                ? widget.fillColor
                : (!(widget.enabled ?? true))
                    ? sccDisabledTextField
                    : fillColor,
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: //hasFocus ?
                    const BorderSide(color: sccLightGray, width: 1)
                //  : BorderSide.none,
                ), //(color: sccUnselect)),
        disabledBorder: widget.disabledBorder ??
            OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color:
                        widget.fillColor != null ? sccLightGray : sccUnselect)),
        focusedBorder: widget.focusedBorder ??
            OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: widget.fillColor ?? sccButtonBlue, width: 1)),
        errorBorder: widget.errorBorder ??
            OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: sccDanger)),
        focusedErrorBorder: widget.focusedErrorBorder ??
            OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: sccDanger, width: 1.5)),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    List<String> splittedValue = newValue.text.split(".");
    String fullString = splittedValue.length >= 2
        ? "${splittedValue[0].numberFilter}.${splittedValue[1].numberFilter}"
        : newValue.text.numberFilter;
    String combinedString = newValue.text.isNotEmpty && newValue.text[0] == "-"
        ? "-$fullString"
        : fullString;

    String truncated = combinedString;

    if (decimalRange > 0) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";
      }
      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

class CurrencyTextInputFormatter extends TextInputFormatter {
  ///* Pass the country code
  final String? locale;

  ///* Pass 0 to 4
  final int? decimalRange;

  CurrencyTextInputFormatter({this.decimalRange = 0, this.locale})
      : assert(decimalRange != null && decimalRange <= 4);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String money = newValue.text;
    NumberFormat formatter = NumberFormat.currency(
        locale: locale ?? 'id',
        decimalDigits: 0,
        symbol: (locale ?? 'id') == 'id' ? 'Rp. ' : null);
    List<String> splittedValue = money.split(formatter.symbols.DECIMAL_SEP);
    String fullString = splittedValue.length >= 2
        ? "${splittedValue[0].numberFilter}${formatter.symbols.DECIMAL_SEP}${splittedValue[1].numberFilter}"
        : money.numberFilter;
    String combinedString =
        money.isNotEmpty && money[0] == "-" ? "-$fullString" : fullString;
    String truncated = combinedString;

    double? cash = double.tryParse(truncated.decimalRpFilter
        .replaceAll(formatter.symbols.DECIMAL_SEP, ".")
        .replaceAll("-", ""));

    int mod = 0;

    String value = money;
    String formatted = '';
    if (cash != null) {
      mod = (cash % 1 == 0)
          ? 0
          : ((cash * 10) % 1 == 0)
              ? 1
              : ((cash * 100) % 1 == 0)
                  ? 2
                  : ((cash * 1000) % 1 == 0)
                      ? 3
                      : 4;
      formatter = NumberFormat.currency(
          locale: locale ?? 'id',
          decimalDigits: mod,
          symbol: (locale ?? 'id') == 'id' ? 'Rp. ' : null);
      formatted = formatter.format(cash);
    }

    if (truncated.isNotEmpty) {
      if ((decimalRange ?? 0) > 0) {
        if (cash != null &&
            (cash % 1 == 0) &&
            value.endsWith(formatter.symbols.DECIMAL_SEP)) {
          formatted = formatted + formatter.symbols.DECIMAL_SEP;
        } else if (value.contains(formatter.symbols.DECIMAL_SEP) &&
            value
                    .substring(value.indexOf(formatter.symbols.DECIMAL_SEP) + 1)
                    .length >
                (decimalRange ?? 0)) {
          formatted = oldValue.text;
          newSelection = oldValue.selection;
        } else if (value == formatter.symbols.DECIMAL_SEP) {
          formatted =
              "${formatter.currencySymbol}0${formatter.symbols.DECIMAL_SEP}";
        }
      }
    } else {
      formatted = truncated;
    }

    if (truncated.startsWith("-")) {
      formatted = "-${(formatted.replaceAll("-", ""))}";
    }
    newSelection = newValue.selection.copyWith(
      baseOffset: math.min(formatted.length, formatted.length + 1),
      extentOffset: math.min(formatted.length, formatted.length + 1),
    );
    return TextEditingValue(
      text: formatted,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class AlphaNumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;

    String newString = newValue.text.alNum;

    newSelection = newValue.selection.copyWith(
      baseOffset: math.min(newString.length, newString.length + 1),
      extentOffset: math.min(newString.length, newString.length + 1),
    );
    return TextEditingValue(
      text: newString,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class PlainSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final Function()? onSearch, onTap, onClear;
  final Function(String?)? onChanged, onAction;
  final Color? fillColor, borderColor;
  final bool enable, readOnly;
  final Widget? prefix, icon;
  final double? suffixSize,
      borderRadius,
      borderRadiusTopLeft,
      borderRadiusTopRight,
      borderRadiusBotLeft,
      borderRadiusBotRight;
  const PlainSearchField({
    this.controller,
    this.fillColor,
    required this.onChanged,
    required this.onSearch,
    this.readOnly = false,
    this.prefix,
    this.borderColor,
    this.onTap,
    this.onClear,
    this.onAction,
    this.hint,
    this.enable = true,
    this.suffixSize,
    this.borderRadius,
    Key? key,
    this.icon,
    this.borderRadiusTopLeft,
    this.borderRadiusTopRight,
    this.borderRadiusBotLeft,
    this.borderRadiusBotRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadiusTopLeft ?? 8),
          bottomLeft: Radius.circular(borderRadiusBotLeft ?? 8),
          topRight: Radius.circular(borderRadiusTopRight ?? 8),
          bottomRight: Radius.circular(borderRadiusBotRight ?? 8),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     spreadRadius: 0,
        //     blurRadius: 0.5,
        //     offset: const Offset(0, 0),
        //   )
        // ]
      ),
      child: CustomFormTextField(
        hint: hint ?? 'Input Search',
        controller: controller,
        maxLine: 1,
        enabled: enable,
        inputformat: [
          FilteringTextInputFormatter.allow(
            Constant.regExp, // Hanya huruf, angka, _, -, spasi, @, +, dan .
          ),
        ],
        onAction: onAction,
        onTap: onTap,
        prefix: prefix,
        // cursorColor: VccButtonBlue,
        readOnly: readOnly,

        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: borderColor ?? Colors.transparent, width: 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadiusTopLeft ?? 8),
            bottomLeft: Radius.circular(borderRadiusBotLeft ?? 8),
            topRight: Radius.circular(borderRadiusTopRight ?? 8),
            bottomRight: Radius.circular(borderRadiusBotRight ?? 8),
          ), //BorderRadius.circular(borderRadius ?? 8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: sccButtonPurple, width: 1),
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        fillColor: fillColor ?? (enable ? sccWhite : sccInfoGrey),
        hoverColor: fillColor ?? (enable ? sccWhite : sccInfoGrey),
        cursorColor: sccButtonPurple,

        suffix: InkWell(
          onTap: enable ? onSearch : () {},
          child: Container(
            height: suffixSize ?? 27,
            width: suffixSize ?? 27,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              color: Colors.transparent,
            ),
            child: SvgPicture.asset(
              Constant.iconSearch,
              colorFilter: const ColorFilter.mode(sccNavText2, BlendMode.srcIn),
              // package: ,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class StfPlainSearchField extends StatefulWidget {
  final String? hint, value;
  final Function()? onSearch, onTap, onClear;
  final Function(String?)? onChanged, onAction;
  final Color? fillColor;
  final bool enable, readOnly;
  final Widget? prefix;
  final double? suffixSize,
      borderRadius,
      borderRadiusTopLeft,
      borderRadiusBotLeft,
      borderRadiusTopRight,
      borderRadiusBotRight;
  const StfPlainSearchField({
    super.key,
    this.fillColor,
    required this.onChanged,
    required this.onSearch,
    required this.value,
    this.readOnly = false,
    this.prefix,
    this.onTap,
    this.onClear,
    this.onAction,
    this.hint,
    this.enable = true,
    this.suffixSize,
    this.borderRadius,
    this.borderRadiusTopLeft,
    this.borderRadiusBotLeft,
    this.borderRadiusTopRight,
    this.borderRadiusBotRight,
  });

  @override
  State<StfPlainSearchField> createState() => _StfPlainSearchFieldState();
}

class _StfPlainSearchFieldState extends State<StfPlainSearchField> {
  String? value;
  late TextEditingController controller;

  @override
  void initState() {
    value = widget.value;
    controller = TextEditingController(text: value);
    //controller?.value.text;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  void didUpdateWidget(StfPlainSearchField oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        value = widget.value; //controller?.value.text;
      });
      controller.value = controller.value.copyWith(
        text: value,
        selection: TextSelection(
          baseOffset: value?.length ?? 0,
          extentOffset: value?.length ?? 0,
        ),
      );
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomFormTextField(
      hint: widget.hint ?? 'Input Search',
      controller: controller,
      maxLine: 1,
      enabled: widget.enable,
      onAction: widget.onAction,
      inputformat: [
        FilteringTextInputFormatter.allow(
          Constant.regExp, // Hanya huruf, angka, _, -, spasi, @, +, dan .
        ),
      ],
      onTap: widget.onTap,
      prefix: widget.prefix ??
          (value?.isNotEmpty == true
              ? IconButton(
                  // splashRadius: 0,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    if (widget.onClear != null) {
                      widget.onClear!();
                    }
                  },
                  icon: const HeroIcon(
                    HeroIcons.xCircle,
                    // solid: true,
                    color: sccText4,
                  ),
                )
              : null),
      // cursorColor: sccButtonBlue,
      readOnly: widget.readOnly,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 1),
        // borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.borderRadiusTopLeft ?? 8),
          bottomLeft: Radius.circular(widget.borderRadiusBotLeft ?? 8),
          topRight: Radius.circular(widget.borderRadiusTopRight ?? 8),
          bottomRight: Radius.circular(widget.borderRadiusBotRight ?? 8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: sccButtonBlue, width: 1),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
      ),
      fillColor: widget.fillColor ?? (widget.enable ? sccWhite : sccInfoGrey),
      hoverColor: widget.fillColor ?? (widget.enable ? sccWhite : sccInfoGrey),
      suffix: InkWell(
        onTap: widget.enable ? widget.onSearch : () {},
        child: Container(
          height: widget.suffixSize ?? 27,
          width: widget.suffixSize ?? 27,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(widget.borderRadiusTopLeft ?? 8),
            //   bottomLeft: Radius.circular(widget.borderRadiusBotLeft ?? 8),
            //   topRight: Radius.circular(widget.borderRadiusTopRight ?? 8),
            //   bottomRight: Radius.circular(widget.borderRadiusBotRight ?? 8),
            // ),
            color: Colors.transparent,
          ),
          child: SvgPicture.asset(
            Constant.iconSearch,
            // color: widget.onSearch != null ? sccNavText2 : sccButtonGrey,
            colorFilter: const ColorFilter.mode(sccNavText2, BlendMode.srcIn),
            // width: context.scaleFont(18),
            // height: context.scaleFont(18),
          ),
        ),
      ),
      onChanged: (value) {
        if (widget.onChanged != null) {
          setState(() {
            this.value = value;
          });
          widget.onChanged!(value);
        }
      },
    );
  }
}
