import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';

class ConfirmSaveDialog extends StatefulWidget {
  final Function() onSave;
  final String? sTitle, sValue, allTitle, allValue, textBtn;

  const ConfirmSaveDialog(
      {super.key,
      required this.onSave,
      this.sTitle,
      this.sValue,
      this.allTitle,
      this.allValue, this.textBtn});

  @override
  State<ConfirmSaveDialog> createState() => _ConfirmSaveDialogState();
}

class _ConfirmSaveDialogState extends State<ConfirmSaveDialog> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: context.isDesktop()
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.3),
              vertical: (context.deviceHeight() * 0.25),
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SizedBox(
        child: Stack(
          children: [
            Container(
              padding: isMobile
                  ? const EdgeInsets.only(
                      left: 8, right: 8, top: 28, bottom: 12)
                  : const EdgeInsets.all(16),
              margin: isMobile
                  ? const EdgeInsets.symmetric(horizontal: 12)
                  : const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sccWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          context.closeDialog();
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          // color: sccRed,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              color: sccWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(
                                    5.0,
                                    5.0,
                                  ),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ),
                              ]),
                          child: HeroIcon(
                            HeroIcons.xMark,
                            color: sccButtonPurple,
                            size: context.scaleFont(28),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GradientWidget(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        sccButtonLightBlue,
                        sccButtonBlue,
                      ],
                    ),
                    child: SelectableText(
                      widget.allTitle ?? "Save ${widget.sTitle ?? "Data"}?",
                      style: TextStyle(
                        color: sccBlack,
                        fontSize: context.scaleFont(20),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isMobile ? (context.deviceHeight() * 0.04) : 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: const EdgeInsetsDirectional.only(bottom: 8),
                          child: SelectableText(
                            widget.allValue ??
                                'Are you sure you want to save ${widget.sTitle ?? "Data"} : ${widget.sValue ?? "Data"}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: context.scaleFont(16),
                                // fontWeight: FontWeight.bold,
                                color: sccText1),
                          ),
                        ),
                        SizedBox(
                          height: context.deviceHeight() * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonCancel(
                              width: context.deviceWidth() *
                                  (context.isDesktop() ? 0.12 : 0.3),
                              text: 'Cancel',
                              borderRadius: 8,
                              onTap: () => context.back(),
                            ),
                            SizedBox(
                              width: 12.wh,
                            ),
                            ButtonConfirm(
                              width: context.deviceWidth() *
                                  (context.isDesktop() ? 0.12 : 0.3),
                              text: widget.textBtn ?? 'Yes, Save',
                              borderRadius: 8,
                              onTap: widget.onSave,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: isMobile ? 18 : context.deviceHeight() * 0.03,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
