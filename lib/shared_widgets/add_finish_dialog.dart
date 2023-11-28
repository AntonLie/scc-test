import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class AddFinishDialog extends StatelessWidget {
  final String? val;
  final String? title;
  final Function() onTap;
  const AddFinishDialog(
      {Key? key, required this.val, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 5), () {
    //   Navigator.of(context).pop(true);
    // });
    Timer timer = Timer(const Duration(seconds: 3), () {
      onTap();
    });
    return Dialog(
      backgroundColor: sccWhite,
      insetPadding: context.isDesktop()
          ? const EdgeInsets.symmetric(
              horizontal: 136,
              vertical: 48,
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 136,
          vertical: 48,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Constant.iconChecklist,
              height: context.deviceWidth() * 0.07,
              width: context.deviceWidth() * 0.07,
            ),
            const SizedBox(height: 48),
            SelectableText(
              title ?? '',
              style: TextStyle(
                fontSize: context.scaleFont(24),
                fontWeight: FontWeight.w700,
                color: sccButtonPurple,
              ),
            ),
            const SizedBox(height: 18),
            SelectableText(
              val ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: sccText1,
                fontSize: context.scaleFont(16),
              ),
            ),
            const SizedBox(height: 20),
            ButtonConfirm(
              text: 'OK',
              onTap: () {
                if (timer.isActive) {
                  timer.cancel();
                }
                onTap();
              },
              borderRadius: 8,
              width: context.deviceWidth() * 0.15,
            )
          ],
        ),
      ),
    );
  }
}
