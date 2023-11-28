import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heroicons/heroicons.dart';

import 'package:scc_web/bloc/point/bloc/point_bloc.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

// import 'package:scc_web/helper/assisted_auto_route.dart';

class DeletePointDialog extends StatefulWidget {
  final String pointCd; // method, url;
  final String? title, pointName;
  final Function() onLogout;
  final Function(String) onError;
  const DeletePointDialog({
    required this.pointCd,
    required this.pointName,
    // required this.method,
    // required this.url,
    this.title,
    required this.onError,
    required this.onLogout,
    Key? key,
  }) : super(key: key);

  @override
  State<DeletePointDialog> createState() => _DeletePointDialogState();
}

class _DeletePointDialogState extends State<DeletePointDialog> {
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    bloc(PointEvent event) {
      BlocProvider.of<PointBloc>(context).add(event);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: context.isDesktop()
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.34),
              vertical: (context.deviceHeight() * 0.1),
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8),
      // ),
      child: SizedBox(
        child: Container(
          padding: const EdgeInsets.all(16),
          //8
          margin: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: sccWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocListener<PointBloc, PointState>(
                listener: (context, state) {
                  if (state is PointError) {
                    context.back();
                    widget.onError(state.msg);
                  }
                  if (state is OnLogoutPoint) {
                    context.back();
                    widget.onLogout();
                  }
                  if (state is PointDeleted) {
                    timer = Timer(const Duration(seconds: 3), () {
                      context.back(true);
                    });
                  }
                },
                child: BlocBuilder<PointBloc, PointState>(
                  builder: (context, state) {
                    if (state is PointDeleted) {
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
                            const SizedBox(height: 10),
                            Visibility(
                              visible: widget.title != null,
                              child: Text(
                                widget.title ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // Changes on fontsize from 24 -> 18
                                  fontSize: context.scaleFont(18),
                                  color: sccButtonPurple,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              margin: const EdgeInsetsDirectional.only(
                                top: 16,
                                start: 17,
                                end: 17,
                                bottom: 16,
                              ),
                              child: StyledText(
                                text:
                                    '<b>${widget.pointName}</b> deleted successfully.',
                                style:
                                    TextStyle(fontSize: context.scaleFont(18)),
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
                              text: 'OK',
                              width: (context.deviceWidth() *
                                  (context.isDesktop() ? 0.12 : 0.3)),
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
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  if (state is! PointLoading) {
                                    context.back();
                                  }
                                },
                                splashColor: Colors.transparent,
                                child: const HeroIcon(
                                  HeroIcons.xCircle,
                                  color: sccButtonPurple,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
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
                                "Delete Point",
                                style: TextStyle(
                                  fontSize: context.scaleFont(18),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              margin:
                                  const EdgeInsetsDirectional.only(bottom: 16),
                              child: SelectableText(
                                'Are you sure to delete ${widget.pointName}?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: context.scaleFont(16),
                                    // fontWeight: FontWeight.bold,
                                    color: sccBlack),
                              ),
                            ),
                            SizedBox(
                              height:
                                  isMobile ? 18 : context.deviceHeight() * 0.05,
                            ),
                            Container(
                              margin: const EdgeInsetsDirectional.only(),
                              width: context.deviceWidth() *
                                  (context.isDesktop() ? 0.5 : 0.8),
                              child: BlocBuilder<PointBloc,
                                  PointState>(
                                builder: (context, state) {
                                  if (state is PointLoading) {
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
                                          borderRadius: 12,
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
                                          borderRadius: 12,
                                          text: 'Yes, delete',
                                          onTap: () {
                                            bloc(DeletePoint(
                                              pointCd: widget.pointCd,
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
      ),
    );
  }
}
