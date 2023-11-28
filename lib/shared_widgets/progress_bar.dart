import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/theme/colors.dart';

class ProgressBar extends StatelessWidget {
  final Function()? onTap;
  final double? buttonOkWidth;
  const ProgressBar({super.key, this.onTap, this.buttonOkWidth});

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
        backgroundColor: sccWhite.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 16 : 8),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: context.deviceWidth() * 0.5,
          height: context.deviceHeight() * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: CircularPercentIndicator(
                    radius: 50,
                    lineWidth: 8,
                    percent: 0.90,
                    animation: true,
                    animationDuration: 1000,
                    center: const Text("loading"),
                    onAnimationEnd: () {
                      if (timer.isActive) {
                        timer.cancel();
                      }
                      if (onTap != null) {
                        onTap!();
                      } else {
                        context.push(const DashboardRoute());
                      }
                    },
                    progressColor: Colors.blue,
                    backgroundColor: Colors.transparent,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
