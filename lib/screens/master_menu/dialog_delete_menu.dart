import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/master_menu/bloc/master_menu_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class DeleteMstMenuDialog extends StatefulWidget {
  final String menuCd, menuName, method, url;
  final Function() onLogout;
  final Function(String) onError;
  const DeleteMstMenuDialog({
    required this.menuName,
    required this.menuCd,
    required this.onError,
    required this.onLogout,
    required this.method,
    required this.url,
    Key? key,
  }) : super(key: key);

  @override
  State<DeleteMstMenuDialog> createState() => _DeleteMstMenuDialogState();
}

class _DeleteMstMenuDialogState extends State<DeleteMstMenuDialog> {
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    bloc(MasterMenuEvent event) {
      BlocProvider.of<MasterMenuBloc>(context).add(event);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: context.isDesktop()
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.3),
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
                  : const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: sccWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                      "Delete Menu ?",
                      style: TextStyle(
                        fontSize: context.scaleFont(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isMobile ? (context.deviceHeight() * 0.04) : 24,
                  ),
                  BlocListener<MasterMenuBloc, MasterMenuState>(
                    listener: (context, state) {
                      if (state is MasterMenuError) {
                        context.back();
                        widget.onError(state.error);
                      }
                      if (state is OnLogoutMasterMenu) {
                        context.back();
                        widget.onLogout();
                      }
                      if (state is MasterMenuDeleted) {
                        timer = Timer(const Duration(seconds: 3), () {
                          context.back(true);
                        });
                      }
                    },
                    child: BlocBuilder<MasterMenuBloc, MasterMenuState>(
                      builder: (context, state) {
                        if (state is MasterMenuDeleted) {
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
                                        '<b>${widget.menuName}</b> deleted successfully.',
                                    style: TextStyle(
                                      fontSize: context.scaleFont(18),
                                      color: sccText1,
                                    ),
                                    textAlign: TextAlign.center,
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
                                    'Are you sure to delete ${widget.menuName}?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: context.scaleFont(16),
                                        fontWeight: FontWeight.bold,
                                        color: sccBlack),
                                  ),
                                ),
                                SizedBox(
                                  height: isMobile
                                      ? 18
                                      : context.deviceHeight() * 0.1,
                                ),
                                Container(
                                  margin: const EdgeInsetsDirectional.only(),
                                  width: context.deviceWidth() *
                                      (context.isDesktop() ? 0.5 : 0.8),
                                  child: BlocBuilder<MasterMenuBloc,
                                      MasterMenuState>(
                                    builder: (context, state) {
                                      if (state is MasterMenuLoading) {
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
                                              text: 'Cancel',
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
                                                bloc(DeleteMasterMenu(
                                                  menuCd: widget.menuCd,
                                                  method: widget.method,
                                                  url: widget.url,
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
            Visibility(
              visible: !isMobile,
              child: BlocBuilder<MasterMenuBloc, MasterMenuState>(
                builder: (context, state) {
                  return Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        if (state is! MasterMenuLoading) {
                          context.back();
                        }
                      },
                      splashColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: sccText2.withOpacity(0.5), width: 0.5),
                          color: sccWhite,
                        ),
                        child: const HeroIcon(
                          HeroIcons.xCircle,
                          color: sccText2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
