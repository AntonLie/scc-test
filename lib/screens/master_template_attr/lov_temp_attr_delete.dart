import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/mst_template_attribute/bloc/template_attribute_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

import '../../helper/constant.dart';
import '../../shared_widgets/buttons.dart';

class DeleteTempAttrDialog extends StatefulWidget {
  final String attrCode, attrName; // method, url;
  final Function() onLogout;
  final Function(String) onError;
  const DeleteTempAttrDialog(
      {super.key,
      required this.attrCode,
      required this.attrName,
      required this.onLogout,
      required this.onError});

  @override
  State<DeleteTempAttrDialog> createState() => _DeleteTempAttrDialogState();
}

class _DeleteTempAttrDialogState extends State<DeleteTempAttrDialog> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    bloc(TemplateAttributeEvent event) {
      BlocProvider.of<TemplateAttributeBloc>(context).add(event);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: context.isDesktop()
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.34),
              vertical: (context.deviceHeight() * 0.1),
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
                  const SizedBox(height: 10),
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
                      "Delete Attribute Template?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.scaleFont(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isMobile ? 18 : 24,
                  ),
                  BlocListener<TemplateAttributeBloc, TemplateAttributeState>(
                    listener: (context, state) {
                      if (state is TemplateAttributeError) {
                        context.back();
                        widget.onError(state.msg);
                      }
                      if (state is OnLogoutTemplateAttribute) {
                        context.back();
                        widget.onLogout();
                      }
                      if (state is DeleteTmplAttrSubmit) {
                        timer = Timer(const Duration(seconds: 3), () {
                          context.back(true);
                        });
                      }
                    },
                    child: BlocBuilder<TemplateAttributeBloc,
                        TemplateAttributeState>(
                      builder: (context, state) {
                        if (state is DeleteTmplAttrSubmit) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                SvgPicture.asset(
                                  Constant.iconChecklist,
                                  height: context.deviceWidth() *
                                      (isMobile ? 0.3 : 0.1),
                                  width: context.deviceWidth() *
                                      (isMobile ? 0.3 : 0.1),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  margin: const EdgeInsetsDirectional.only(
                                    top: 16,
                                    start: 17,
                                    end: 17,
                                    bottom: 16,
                                  ),
                                  child: StyledText(
                                    text:
                                        '<b>${widget.attrName}</b> deleted successfully.',
                                    style: TextStyle(
                                      fontSize: context.scaleFont(18),
                                      color: sccText1,
                                    ),
                                    tags: {
                                      'b': StyledTextTag(
                                          style: TextStyle(
                                        fontSize: context.scaleFont(18),
                                        fontWeight: FontWeight.bold,
                                      ))
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ButtonConfirm(
                                  text: 'Okay',
                                  width: MediaQuery.of(context).size.width / 4,
                                  onTap: () {
                                    if (timer != null && timer!.isActive) {
                                      timer!.cancel();
                                    }
                                    context.back(true);
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      bottom: 16),
                                  child: SelectableText(
                                    'Are You sure to delete : ${widget.attrName}.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: context.scaleFont(18),
                                      // fontWeight: FontWeight.bold,
                                      color: sccText1,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: isMobile ? 18 : 26,
                                ),
                                Container(
                                  margin: const EdgeInsetsDirectional.only(),
                                  width: context.deviceWidth() *
                                      (context.isDesktop() ? 0.5 : 0.8),
                                  child: BlocBuilder<TemplateAttributeBloc,
                                      TemplateAttributeState>(
                                    builder: (context, state) {
                                      if (state is TemplateAttributeLoading) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ButtonCancel(
                                              width: context.deviceWidth() *
                                                  (context.isDesktop()
                                                      ? 0.12
                                                      : 0.3),
                                              // marginVertical: 11,
                                              borderRadius: 8,
                                              text: 'Cancel',
                                              onTap: () => context.back(),
                                            ),
                                            SizedBox(
                                              width: 12.wh,
                                            ),
                                            ButtonConfirm(
                                              width: context.deviceWidth() *
                                                  (context.isDesktop()
                                                      ? 0.12
                                                      : 0.3),
                                              // verticalMargin: 11,
                                              borderRadius: 8,
                                              text: 'Yes, delete',
                                              onTap: () {
                                                bloc(DeleteTemplateAttribute(
                                                  attrCd: widget.attrCode,
                                                  // method: widget.method,
                                                  // url: widget.url,
                                                ));
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Visibility(
            //   visible: !isMobile,
            //   child: BlocBuilder<TemplateAttributeBloc, TemplateAttributeState>(
            //     builder: (context, state) {
            //       return Positioned(
            //         right: 0,
            //         child: InkWell(
            //           onTap: () {
            //             if (state is! TemplateAttributeLoading) {
            //               context.back();
            //             }
            //           },
            //           splashColor: Colors.transparent,
            //           child: Container(
            //             padding: const EdgeInsets.all(6),
            //             decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               border: Border.all(
            //                   color: sccText2.withOpacity(0.5), width: 0.5),
            //               color: sccWhite,
            //             ),
            //             child: const HeroIcon(
            //               HeroIcons.xCircle,
            //               size: 12,
            //               color: sccText2,
            //               // size: 16,
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
