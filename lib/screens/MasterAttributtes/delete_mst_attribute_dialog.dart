import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/mst_attr/bloc/mst_attr_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class DeleteMstAttrDialog extends StatefulWidget {
  final String attributeCd, attributeName; // method, url;

  final Function() onLogout;
  final Function(String) onError;

  const DeleteMstAttrDialog(
      {super.key,
      required this.attributeCd,
      required this.attributeName,
      required this.onLogout,
      required this.onError});

  @override
  State<DeleteMstAttrDialog> createState() => _DeleteMstAttrDialogState();
}

class _DeleteMstAttrDialogState extends State<DeleteMstAttrDialog> {
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    bloc(MstAttrEvent event) {
      BlocProvider.of<MstAttrBloc>(context).add(event);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: context.isDesktop()
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.3),
              vertical: (context.deviceHeight() * 0.1),
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(12),
      // ),
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
                      "Delete Attribute?",
                      style: TextStyle(
                        fontSize: context.scaleFont(20),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isMobile ? (context.deviceHeight() * 0.04) : 24,
                  ),
                  BlocListener<MstAttrBloc, MstAttrState>(
                    listener: (context, state) {
                      if (state is MstAttrError) {
                        context.back();
                        widget.onError(state.error);
                      }
                      if (state is OnLogoutMstAttr) {
                        context.back();
                        widget.onLogout();
                      }
                      if (state is AttrDeleted) {
                        timer = Timer(const Duration(seconds: 3), () {
                          context.back();
                        });
                      }
                    },
                    child: BlocBuilder<MstAttrBloc, MstAttrState>(
                      builder: (context, state) {
                        if (state is AttrDeleted) {
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
                                        '<b>${widget.attributeName}</b> deleted successfully.',
                                    textAlign: TextAlign.center,
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
                                  borderRadius: 8,
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
                                  height: 15,
                                ),
                                Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      bottom: 16),
                                  child: SelectableText(
                                    'Are You sure to delete the attribute : ${widget.attributeName}.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: context.scaleFont(16),
                                        // fontWeight: FontWeight.bold,
                                        color: sccText1),
                                  ),
                                ),
                                SizedBox(
                                  height: isMobile
                                      ? 18
                                      : context.deviceHeight() * 0.05,
                                ),
                                Container(
                                  margin: const EdgeInsetsDirectional.only(),
                                  width: context.deviceWidth() *
                                      (context.isDesktop() ? 0.5 : 0.8),
                                  child: BlocBuilder<MstAttrBloc, MstAttrState>(
                                    builder: (context, state) {
                                      if (state is MstAttrLoading) {
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
                                              text: 'No',
                                              borderRadius: 8,
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
                                              text: 'Yes, delete',
                                              borderRadius: 8,
                                              onTap: () {
                                                bloc(DeleteAttr(
                                                  attributeCd:
                                                      widget.attributeCd,
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
                                const SizedBox(
                                  height: 24,
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
            //   child: BlocBuilder<MstAttrBloc, MstAttrState>(
            //     builder: (context, state) {
            //       return Positioned(
            //         right: 0,
            //         child: InkWell(
            //           onTap: () {
            //             if (state is! MstAttrLoading) {
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
