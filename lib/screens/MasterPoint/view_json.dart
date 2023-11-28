import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/point/bloc/point_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';

import 'package:scc_web/theme/colors.dart';

class ViewJson extends StatefulWidget {
  const ViewJson({super.key});

  @override
  State<ViewJson> createState() => _ViewJsonState();
}

class _ViewJsonState extends State<ViewJson> {
  dynamic model;
  String? test;
  @override
  Widget build(BuildContext context) {
    return BlocListener<PointBloc, PointState>(
      listener: (context, state) {
        if (state is PointView) {
          model = state.model;
        }
      },
      child: BlocBuilder<PointBloc, PointState>(
        builder: (context, state) {
          if (state is PointLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Dialog(
                backgroundColor: sccWhite,
                insetPadding: context.isDesktop()
                    ? EdgeInsets.symmetric(
                        horizontal: (context.deviceWidth() * 0.25),
                        vertical: (context.deviceHeight() * 0.1),
                      )
                    : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                    child: Container(
                        width: context.deviceWidth(),
                        padding: isMobile
                            ? const EdgeInsets.only(
                                left: 8, right: 8, top: 28, bottom: 12)
                            : const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "View Json",
                                    style: TextStyle(
                                      fontSize: context.scaleFont(28),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.closeDialog();
                                    },
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16)),
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
                              const Divider(
                                color: sccLightGrayDivider,
                                height: 25,
                                thickness: 2,
                              ),
                              Container(
                                width: context.deviceWidth(),
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  color: sccBackground,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text(model.toString())],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: isMobile
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.center,
                                  children: [
                                    ButtonCancel(
                                      text: "Close",
                                      color: sccNavText2,
                                      width: context.deviceWidth() *
                                          (context.isDesktop() ? 0.11 : 0.35),
                                      onTap: () {
                                        context.back();
                                      },
                                    ),
                                    SizedBox(
                                      width: 8.wh,
                                    ),
                                    ButtonConfirm(
                                      text: "Salin",
                                      width: context.deviceWidth() *
                                          (context.isDesktop() ? 0.11 : 0.35),
                                      onTap: () {
                                        Clipboard.setData(
                                            ClipboardData(text: model ?? "-"));
                                        showTopSnackBar(
                                            context,
                                            const UpperSnackBar.info(
                                                message:
                                                    "Full text copied to clipboard"));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ]))));
          }
        },
      ),
    );
  }
}
