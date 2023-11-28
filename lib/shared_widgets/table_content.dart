import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/dynamic_ellipsis.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class TableContent extends StatelessWidget {
  final String? value;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  const TableContent(
      {Key? key,
      this.fontSize,
      this.fontWeight,
      this.fontStyle,
      required this.value,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Text label(BoxConstraints ctn) {
      return Text(
        dynamicEllipsis(
          context,
          ctn.maxWidth,
          value ?? "-",
          TextStyle(
              fontSize: context.scaleFont((fontSize ?? 14) + 1.5),
              color: color,
              fontWeight: fontWeight ?? FontWeight.w400,
              fontStyle: fontStyle ?? FontStyle.normal),
        ),
        style: TextStyle(
            fontSize: context.scaleFont(fontSize ?? 14),
            color: color,
            fontWeight: fontWeight ?? FontWeight.w400,
            fontStyle: fontStyle ?? FontStyle.normal),
      );
    }

    return LayoutBuilder(
      builder: (ctx, ctn) {
        if ((getTextSize(
              value ?? "-",
              TextStyle(
                fontSize: context.scaleFont((fontSize ?? 14) + 1.5),
                fontWeight: fontWeight ?? FontWeight.w400,
                fontStyle: fontStyle ?? FontStyle.normal,
              ),
              context,
            ) >
            ctn.maxWidth)) {
          return SizedBox(
            child: PortalTooltip(
              value: value,
              maxWidth: ctn.maxWidth,
              child: InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value ?? "-"));
                    showTopSnackBar(
                        context,
                        const UpperSnackBar.info(
                            message: "Full text copied to clipboard"));
                  },
                  child: label(ctn)),
            ),
          );
        } else {
          return SelectableText(
            value ?? '',
            style: TextStyle(
              fontSize: context.scaleFont(14),
              color: color,
            ),
          );
        }
      },
    );
  }
}

class PackageContent extends StatelessWidget {
  final String? value;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  const PackageContent(
      {Key? key,
      this.fontSize,
      this.fontWeight,
      required this.value,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Text label(BoxConstraints ctn) {
      return Text(
        dynamicEllipsis(
          context,
          ctn.maxWidth,
          value ?? "-",
          TextStyle(
            fontSize: context.scaleFont((fontSize ?? 14) + 1.5),
            color: color,
            fontWeight: fontWeight ?? FontWeight.w400,
          ),
        ),
        style: TextStyle(
          fontSize: context.scaleFont(fontSize ?? 14),
          color: color,
          fontWeight: fontWeight ?? FontWeight.w400,
        ),
      );
    }

    return LayoutBuilder(
      builder: (ctx, ctn) {
        if ((getTextSize(
              value ?? "-",
              TextStyle(
                fontSize: context.scaleFont((fontSize ?? 14) + 1.5),
              ),
              context,
            ) >
            ctn.maxWidth)) {
          return SizedBox(
            child: PortalTooltip(
              value: value,
              maxWidth: ctn.maxWidth,
              child: label(ctn),
            ),
          );
        } else {
          return Text(
            value ?? '',
            style: TextStyle(
              fontSize: context.scaleFont(14),
              color: color,
            ),
          );
        }
      },
    );
  }
}

class PortalTooltip extends StatefulWidget {
  final String? value;
  final Widget child;
  final double? maxWidth;
  const PortalTooltip(
      {required this.maxWidth,
      required this.value,
      required this.child,
      Key? key})
      : super(key: key);

  @override
  State<PortalTooltip> createState() => _PortalTooltipState();
}

class _PortalTooltipState extends State<PortalTooltip> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: isHovered,
      anchor: const Aligned(
        follower: Alignment.topCenter,
        target: Alignment.bottomCenter,
      ),
      portalFollower: Container(
        constraints:
            BoxConstraints(maxWidth: widget.maxWidth ?? context.deviceWidth()),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: StyledText(
          text: (widget.value ?? 'This is a <bi>Null</bi> Value'),
          style: TextStyle(
            fontSize: context.scaleFont(14),
          ),
          tags: {
            'bi': StyledTextTag(
              style: TextStyle(
                fontSize: context.scaleFont(14),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            )
          },
        ),
      ),
      child: MouseRegion(
        onHover: (value) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (value) {
          setState(() {
            isHovered = false;
          });
        },
        child: widget.child,
      ),
    );
  }
}
