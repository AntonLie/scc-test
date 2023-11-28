// ignore_for_file: deprecated_member_use, overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';

class CustomFormTextFieldNew extends StatefulWidget {
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

  const CustomFormTextFieldNew(
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
  State<CustomFormTextFieldNew> createState() => _CustomFormTextFieldNewState();
}

class _CustomFormTextFieldNewState extends State<CustomFormTextFieldNew> {
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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        fontSize: context.scaleFont(15),
      ),
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 12, color: sccDanger),
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
          fontSize: context.scaleFont(16),
          color: sccBlack,
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontSize: context.scaleFont(16),
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

class CustomSearchFieldNew extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final Function()? onSearch, onTap, onClear;
  final Function(String?)? onChanged, onAction;
  final Color? fillColor;
  final bool enable, readOnly, enableBorderColor, buttonTransparent;
  final Widget? prefix;
  final double? suffixSize, borderRadius;
  const CustomSearchFieldNew({
    super.key,
    this.controller,
    this.fillColor,
    required this.onChanged,
    required this.onSearch,
    this.readOnly = false,
    this.buttonTransparent = false,
    this.prefix,
    this.onTap,
    this.onClear,
    this.onAction,
    this.hint,
    this.enable = true,
    this.suffixSize,
    this.borderRadius,
    this.enableBorderColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFormTextFieldNew(
      hint: hint ?? 'Input Search',
      controller: controller,
      maxLine: 1,
      enabled: enable,
      onAction: onAction,
      onTap: onTap,
      prefix: prefix,
      // cursorColor: sccButtonBlue,
      readOnly: readOnly,
      enabledBorder: OutlineInputBorder(
        borderSide: enableBorderColor
            ? const BorderSide(color: sccBorder, width: 1)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: sccButtonBlue, width: 1),
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
      fillColor: fillColor ?? (enable ? sccWhite : sccInfoGrey),
      hoverColor: fillColor ?? (enable ? sccWhite : sccInfoGrey),
      suffix: InkWell(
        onTap: enable ? onSearch : () {},
        child: Container(
          height: suffixSize ?? 27,
          width: suffixSize ?? 27,
          // padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            gradient: buttonTransparent
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: onSearch != null
                        ? [
                            sccButtonLightBlue,
                            sccButtonBlue,
                          ]
                        : [
                            sccButtonGrey,
                            sccButtonGrey,
                          ],
                  ),
          ),
          child: SvgPicture.asset(
            Constant.iconSearch,
            color: buttonTransparent
                ? onSearch != null
                    ? const Color(0xff7366FF)
                    : sccButtonGrey
                : sccWhite,
            // width: context.scaleFont(18),
            // height: context.scaleFont(18),
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
