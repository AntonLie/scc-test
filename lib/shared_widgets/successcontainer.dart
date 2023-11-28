import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';

class SuccessContainer extends StatelessWidget {
  final String? msg, title, buttonText;
  final Function()? onTap;
  const SuccessContainer(
      {super.key, this.msg, this.title, this.buttonText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.deviceHeight() * 0.65,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Constant.iconChecklist,
              height: context.deviceWidth() * (isMobile ? 0.35 : 0.1),
              width: context.deviceWidth() * (isMobile ? 0.35 : 0.1),
            ),
            const SizedBox(
              height: 12,
            ),
            Visibility(
              visible: title != null,
              child: GradientWidget(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    sccButtonLightBlue,
                    sccButtonBlue,
                  ],
                ),
                child: SelectableText(
                  title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.scaleFont(15),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: title != null,
              child: const SizedBox(
                height: 12,
              ),
            ),

            SelectableText(
              msg ?? "Submitted Successfully",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: context.scaleFont(15), color: sccText1),
            ),
            // const Spacer(),
            SizedBox(
              height: context.deviceHeight() * 0.1,
            ),
            ButtonConfirm(
              text: buttonText ?? 'Back to Menu',
              width: MediaQuery.of(context).size.width / 4,
              borderRadius: 8,
              onTap: () {
                if (onTap != null) {
                  onTap!();
                } else {
                  context.push(const DashboardRoute());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
