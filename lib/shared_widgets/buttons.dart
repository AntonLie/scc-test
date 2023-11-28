// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';

class ButtonConfirm extends StatefulWidget {
  final Function()? onTap;
  final String text;
  final double? width;
  final Color? colour, textColour, boxShadowColor;
  final double? height;
  final double? textsize;
  final double? borderRadius;
  final double? verticalMargin;
  final double? padding;
  final FontWeight? fontWeight;
  final Key? key;

  const ButtonConfirm(
      {required this.text,
      this.textsize,
      this.onTap,
      this.width,
      this.height,
      this.key,
      this.colour,
      this.textColour,
      this.borderRadius,
      this.verticalMargin,
      this.padding,
      this.fontWeight,
      this.boxShadowColor});

  @override
  _ButtonConfirmState createState() => _ButtonConfirmState();
}

class _ButtonConfirmState extends State<ButtonConfirm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height,
      padding: EdgeInsets.all(widget.padding ?? 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          color: widget.onTap != null
              ? (widget.colour ?? sccButtonPurple)
              : sccButtonGrey,
          boxShadow: [
            BoxShadow(
              color: widget.boxShadowColor ?? Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 4)),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: widget.verticalMargin ?? 8),
          child: FittedBox(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: context.scaleFont(widget.textsize ?? 14),
                color: widget.onTap != null
                    ? (widget.textColour ?? sccWhite)
                    : sccBlack,
                fontWeight: widget.fontWeight ?? FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonCancel extends StatefulWidget {
  final Key? key;
  final Function()? onTap;
  final String text;
  final double? textsize;
  final double? width;
  final double? borderRadius;
  final double? marginVertical;
  final double? padding;
  final Color? color;

  const ButtonCancel(
      {this.color,
      this.key,
      this.textsize,
      required this.text,
      this.onTap,
      this.width,
      this.borderRadius,
      this.marginVertical,
      this.padding});
  @override
  _ButtonCancelState createState() => _ButtonCancelState();
}

class _ButtonCancelState extends State<ButtonCancel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(widget.padding ?? 2),
      decoration: BoxDecoration(
        // border: Border.all(
        //     color: widget.onTap != null ? sccPrimary : sccDarkGray, width: 1.8),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        color: widget.onTap != null
            ? (widget.color ?? sccButtonGrey)
            : sccButtonGrey,
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: widget.onTap != null
        //       ? [
        //           (widget.color??sccButtonPurple),
        //           (widget.color??sccButtonPurple),
        //         ]
        //       : [
        //           sccDarkGray,
        //           sccDarkGray,
        //         ],
        // ),
      ),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          backgroundColor: widget.onTap != null ? sccWhite : sccButtonGrey,
          shape: RoundedRectangleBorder(
              // side: BorderSide(
              //     color: widget.onTap != null ? sccPrimary : sccDarkGray,
              //     width: 1.8),
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12)),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: widget.marginVertical ?? 8),
          child: FittedBox(
            child:
                // GradientWidget(
                //   gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     colors: widget.onTap != null
                //         ? [
                //             sccButtonLightBlue,
                //             sccButtonBlue,
                //           ]
                //         : [
                //             sccBlack,
                //             sccBlack,
                //           ],
                //   ),
                //   child:
                Text(
              widget.text,
              style: TextStyle(
                  fontSize: widget.textsize ?? context.scaleFont(14),
                  color: widget.onTap != null
                      ? (widget.color ?? sccButtonPurple)
                      : sccBlack,
                  fontWeight: FontWeight.w600),
            ),
            // ),
          ),
        ),
      ),
    );
  }
}

class ButtonReset extends StatefulWidget {
  final Key? key;
  final Function()? onTap;
  final String text;
  final double? textsize;
  final double? width;
  final double? borderRadius;
  final double? marginVertical;
  final double? padding;

  const ButtonReset(
      {this.key,
      this.textsize,
      required this.text,
      this.onTap,
      this.width,
      this.borderRadius,
      this.marginVertical,
      this.padding});
  @override
  _ButtonResetState createState() => _ButtonResetState();
}

class _ButtonResetState extends State<ButtonReset> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(widget.padding ?? 2),
      decoration: BoxDecoration(
        // border: Border.all(
        //     color: widget.onTap != null ? sccPrimary : sccDarkGray, width: 1.8),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        color: widget.onTap != null
            ? sccNavText2.withOpacity(0.06)
            : sccButtonGrey,
      ),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          backgroundColor: widget.onTap != null
              ? sccNavText2.withOpacity(0.06)
              : sccButtonGrey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12)),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: widget.marginVertical ?? 8),
          child: FittedBox(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.textsize ?? context.scaleFont(16),
                color: widget.onTap != null ? sccNavText2 : sccWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonConfirmWithIcon extends StatefulWidget {
  final Function()? onTap;
  final String text;
  final Widget icon;
  final double? width, borderRadius;
  final Key? key;
  final Color? colour, boxShadowColor;
  final Color? textColor;

  const ButtonConfirmWithIcon({
    required this.icon,
    required this.text,
    this.onTap,
    this.width,
    this.key,
    // required Color colour,
    this.borderRadius,
    this.colour,
    this.textColor,
    this.boxShadowColor,
  }) : super(key: key);

  @override
  _ButtonConfirmWithIconState createState() => _ButtonConfirmWithIconState();
}

class _ButtonConfirmWithIconState extends State<ButtonConfirmWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: widget.boxShadowColor ?? Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ]),
      width: widget.width ?? context.deviceWidth() * 0.1,
      child: TextButton.icon(
        onPressed: widget.onTap,
        icon: widget.icon,
        label: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: context.dynamicFont(14),
              // color: widget.onTap != null ? sccWhite : sccBlack,
              color: widget.textColor ?? sccWhite,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: widget.colour ?? sccNavText2,
          // elevation: 8,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: widget.colour ?? sccNavText2,
              // style: BorderStyle.solid,
              // width: (1.8),
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          ),
        ),
      ),
    );
  }
}

class DottedAddButton extends StatefulWidget {
  final Function()? onTap;
  final double? width, height;
  final double? textsize;
  final String? text;
  final HeroIcons? icon;
  const DottedAddButton(
      {this.textsize,
      this.onTap,
      this.width,
      this.text,
      Key? key,
      this.icon,
      this.height})
      : super(key: key);

  @override
  _DottedAddButtonState createState() => _DottedAddButtonState();
}

class _DottedAddButtonState extends State<DottedAddButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? context.deviceWidth(),
      height: widget.height ?? 56,
      child: TextButton(
        onPressed: widget.onTap,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.onTap != null ? sccBackground : sccBlue,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 5,
              ),
              GradientWidget(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: widget.onTap != null
                      ? [
                          sccButtonPurple,
                          sccButtonPurple,
                        ]
                      : [
                          sccBlack,
                          sccBlack,
                        ],
                ),
                child: HeroIcon(widget.icon ?? HeroIcons.plusCircle),
              ),
              const SizedBox(
                width: 5,
              ), //Icon(Icons.add_circle_outline)),
              Text(
                widget.text ?? ' Add Detail',
                style: TextStyle(
                    fontSize: widget.textsize ?? context.scaleFont(14),
                    color: widget.onTap != null ? sccButtonPurple : sccBlue,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );

    // return Container(
    //   width: widget.width ?? context.deviceWidth(),
    //   child: DottedBorder(
    //     borderType: BorderType.RRect,
    //     radius: Radius.circular(8),
    //     padding: EdgeInsets.all(6),
    //     color: sccHintText,
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.all(Radius.circular(12)),
    //       child: TextButton(
    //         onPressed: widget.onTap,
    //         child: Container(
    //           alignment: Alignment.center,
    //           margin: const EdgeInsets.symmetric(vertical: 11),
    //           child: StyledText(
    //             text: '<plus/> Add Detail',
    //             overflow: TextOverflow.clip,
    //             style: TextStyle(
    //                 fontSize: widget.textsize ?? context.scaleFont(16),
    //                 color: widget.onTap != null ? sccPrimary : sccBlack,
    //                 fontWeight: FontWeight.bold),
    //             tags: {
    //               'plus': StyledTextIconTag(
    //                 Icons.add_circle_outline,
    //                 color: widget.onTap != null ? sccPrimary : sccBlack,
    //               ),
    //             },
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class ButtonAddIcon extends StatefulWidget {
  final Function()? onTap;
  final double? borderRadius;
  const ButtonAddIcon({Key? key, required this.onTap, this.borderRadius})
      : super(key: key);

  @override
  _ButtonAddIconState createState() => _ButtonAddIconState();
}

class _ButtonAddIconState extends State<ButtonAddIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                sccButtonPurple,
                sccButtonPurple,
              ]),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ButtonAddMobile extends StatefulWidget {
  final double? size;
  final Function()? onTap;

  final double? borderRadius;
  const ButtonAddMobile({
    this.size,
    required this.onTap,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  @override
  _ButtonAddMobileState createState() => _ButtonAddMobileState();
}

class _ButtonAddMobileState extends State<ButtonAddMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size ?? double.infinity,
      height: widget.size ?? double.infinity,
      decoration: BoxDecoration(
        // border: Border.all(
        //     color: widget.onTap != null ? sccPrimary : sccDarkGray, width: 1.8),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.onTap != null
              ? [
                  sccButtonPurple,
                  sccButtonPurple,
                ]
              : [
                  sccDarkGray,
                  sccDarkGray,
                ],
        ),
      ),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          // backgroundColor: widget.onTap != null ? sccPrimary : sccDarkGray,
          shape: RoundedRectangleBorder(
              // side: BorderSide(
              //     color: widget.onTap != null ? sccPrimary : sccDarkGray,
              //     width: 1.8),
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 4)),
        ),
        child: Container(
          alignment: Alignment.center,
          child: HeroIcon(
            HeroIcons.plus,
            color: sccWhite,
            size: context.scaleFont(16),
          ),
        ),
      ),
    );
  }
}

class ButtonShowHidewithIcon extends StatefulWidget {
  const ButtonShowHidewithIcon({super.key});

  @override
  State<ButtonShowHidewithIcon> createState() => _ButtonShowHidewithIconState();
}

class _ButtonShowHidewithIconState extends State<ButtonShowHidewithIcon> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
