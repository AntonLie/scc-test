import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';
// import 'package:flutter_svg/svg.dart';

// import 'package:scc_web/helper/approute.gr.dart';
// import 'package:scc_web/helper/assisted_auto_route.dart';

// import 'package:scc_web/shared_widgets/gradient_widgets.dart';
// import 'package:scc_web/shared_widgets/success_container.dart';

class SuccessDialog extends StatelessWidget {
  final String? msg, title, buttonText;
  final double? buttonOkWidth;
  final Function()? onTap;
  const SuccessDialog(
      {this.onTap,
      this.buttonText,
      this.title,
      this.msg,
      this.buttonOkWidth,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(const Duration(seconds: 3), () {
      if (onTap != null) {
        onTap!();
      } else {
        context.push(const DashboardRoute());
      }
    });
    return Dialog(
      insetPadding: context.isDesktop()
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.35),
              vertical: (context.deviceHeight() * 0.1),
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      backgroundColor: sccWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: context.deviceWidth() * 0.4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 12,
              ),
              // Padding(
              //   padding: const EdgeInsetsDirectional.only(bottom: 16),
              //   child: Image.asset(
              //     "assets/circle_checklist.png",
              //     height: context.deviceWidth() * (isMobile ? 0.35 : 0.1),
              //     width: context.deviceWidth() * (isMobile ? 0.35 : 0.1),
              //   ),
              // ),
              SvgPicture.asset(
                // "assets/icon_checklist.svg",
                Constant.iconChecklist,
                height: context.deviceWidth() * (isMobile ? 0.35 : 0.075),
                width: context.deviceWidth() * (isMobile ? 0.35 : 0.075),
              ),
              SizedBox(
                height: isMobile ? 18 : context.deviceHeight() * 0.05,
              ),
              Visibility(
                visible: title != null,
                child: Text(
                  title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // Changes on fontsize from 24 -> 18
                    fontSize: context.scaleFont(18),
                    color: sccButtonPurple,
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(3),
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: sccSuccess,
              //   ),
              //   child: Icon(
              //     Icons.check,
              //     size: context.scaleFont(50),
              //     color: sccWhite,
              //   ),
              // ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: context.deviceWidth() * 0.16,
                  child: SelectableText(
                    msg ?? "Submitted Successfully",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: context.scaleFont(15), color: sccText1),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ButtonConfirm(
                text: buttonText ?? 'OK',
                width: buttonOkWidth ??
                    (context.deviceWidth() *
                        (context.isDesktop() ? 0.12 : 0.3)),
                fontWeight: FontWeight.normal,
                borderRadius: 8,
                onTap: () {
                  if (timer.isActive) {
                    timer.cancel();
                  }
                  if (onTap != null) {
                    onTap!();
                  } else {
                    context.push(const DashboardRoute());
                  }
                },
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
      // SuccessContainer(
      //   title: this.title,
      //   buttonText: this.buttonText,
      //   msg: this.msg,
      //   onTap: this.onTap,
      // ),
    );
  }
}
