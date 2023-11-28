import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class RedirectDialog extends StatelessWidget {
  final Function()? onTap;
  const RedirectDialog({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Timer timer = Timer(const Duration(seconds: 5), () {
    //   if (onTap != null) {
    //     onTap!();
    //   } else {

    //     // context.push(HomeRoute());
    //   }
    // });
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8),
      // ),
      child: SizedBox(
        width: context.deviceWidth(),
        child: Stack(
          children: [
            Container(
              width: context.deviceWidth(),
              padding: isMobile
                  ? const EdgeInsets.only(
                      left: 8, right: 8, top: 28, bottom: 12)
                  : const EdgeInsets.all(16),
              margin: isMobile
                  ? const EdgeInsets.symmetric(horizontal: 12)
                  : const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: sccWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                      // height: 16,
                      ),
                  SelectableText(
                    "Permission Denied",
                    style: TextStyle(
                      fontSize: context.scaleFont(48),
                      fontWeight: FontWeight.bold,
                      color: sccButtonBlue,
                    ),
                  ),
                  const SizedBox(
                      // height: isMobile ? (context.deviceHeight() * 0.04) : 24,
                      ),
                  const SizedBox(
                      // height: 12,
                      ),
                  // SvgPicture.asset(
                  //   "assets/icon_checklist.svg",
                  //   height: context.deviceWidth() * (isMobile ? 0.3 : 0.1),
                  //   width: context.deviceWidth() * (isMobile ? 0.3 : 0.1),
                  // ),
                  // SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsetsDirectional.only(
                      top: 16,
                      start: 17,
                      end: 17,
                      bottom: 16,
                    ),
                    child: Text(
                      "You don't have perrmission to access this menu. please contact your Helpdesk and / or Developer",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.scaleFont(24),
                        color: sccText1,
                      ),
                    ),
                  ),
                  const SizedBox(
                      // height: 24,
                      ),
                  ButtonConfirm(
                    text: 'Okay',
                    height: context.deviceHeight() * 0.075,
                    width: MediaQuery.of(context).size.width / 4,
                    borderRadius: 8,
                    onTap: () {
                      // timer.cancel();

                      if (onTap != null) {
                        onTap!();
                      } else {
                        // context.push(HomeRoute());
                      }
                    },
                  ),
                  const SizedBox(),
                ],
              ),
            ),
            // Visibility(
            //   visible: !isMobile,
            //   child: Positioned(
            //     right: 0,
            //     child: InkWell(
            //       onTap: () {
            //         onTap!();
            //         // timer.cancel();
            //         // context.push(HomeRoute());
            //       },
            //       splashColor: Colors.transparent,
            //       child: Container(
            //         alignment: Alignment.center,
            //         padding: const EdgeInsets.all(4),
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           // border: Border.all(color: VccText2.withOpacity(0.5), width: 0.5),
            //           color: sccWhite,
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.grey.withOpacity(0.5),
            //               spreadRadius: 2,
            //               blurRadius: 7,
            //               offset: const Offset(0, 3),
            //             ),
            //           ],
            //         ),
            //         child: const HeroIcon(
            //           HeroIcons.xMark,
            //           size: 14,
            //           color: sccText2,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
