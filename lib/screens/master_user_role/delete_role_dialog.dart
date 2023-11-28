// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/mst_usr_role/bloc/mst_usr_role_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class DeleteMasterRoleDialog extends StatefulWidget {
  final String validFrom, username; //, method, url;
  final Function() onLogout;
  final Function(String) onError;
  const DeleteMasterRoleDialog({
    Key? key,
    required this.username,
    required this.onLogout,
    required this.onError,
    required this.validFrom,
  }) : super(key: key);

  @override
  State<DeleteMasterRoleDialog> createState() => _DeleteMasterRoleDialogState();
}

class _DeleteMasterRoleDialogState extends State<DeleteMasterRoleDialog> {
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    bloc(MstUsrRoleEvent event) {
      BlocProvider.of<MstUsrRoleBloc>(context).add(event);
    }

    return Dialog(
      backgroundColor: sccWhite,
      insetPadding: context.isDesktop()
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.3),
              vertical: (context.deviceHeight() * 0.1),
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: isMobile
            ? const EdgeInsets.only(left: 8, right: 8, top: 28, bottom: 12)
            : const EdgeInsets.all(16),
        // margin: isMobile ? EdgeInsets.symmetric(horizontal: 12) : EdgeInsets.all(11),
        // decoration: BoxDecoration(
        //   color: sccWhite,
        //   borderRadius: BorderRadius.circular(12),
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: BlocBuilder<MstUsrRoleBloc, MstUsrRoleState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      if (state is! MasterRoleLoading) {
                        context.back();
                      }
                    },
                    splashColor: Colors.transparent,
                    child: const HeroIcon(
                      HeroIcons.xCircle,
                      size: 24,
                      color: sccText2,
                      // size: 16,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: isMobile ? (context.deviceHeight() * 0.04) : 24,
            ),
            BlocListener<MstUsrRoleBloc, MstUsrRoleState>(
              listener: (context, state) {
                if (state is MasterRoleError) {
                  context.back();
                  widget.onError(state.msg);
                }
                if (state is OnLogoutMasterRole) {
                  context.back();
                  widget.onLogout();
                }
                if (state is DeleteRoleSuccess) {
                  timer = Timer(const Duration(seconds: 3), () {
                    context.back(true);
                  });
                }
              },
              child: BlocBuilder<MstUsrRoleBloc, MstUsrRoleState>(
                builder: (context, state) {
                  if (state is DeleteRoleSuccess) {
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
                            height:
                                context.deviceWidth() * (isMobile ? 0.3 : 0.1),
                            width:
                                context.deviceWidth() * (isMobile ? 0.3 : 0.1),
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
                                  '<b>${widget.username}</b> deleted successfully.',
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
                          Text(
                            "Delete Role?",
                            style: TextStyle(
                              fontSize: context.scaleFont(24),
                              fontWeight: FontWeight.bold,
                              color: sccButtonPurple,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            margin:
                                const EdgeInsetsDirectional.only(bottom: 16),
                            child: SelectableText(
                              'Are you sure to delete ${widget.username}?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: context.scaleFont(16),
                                // fontWeight: FontWeight.bold,
                                color: sccBlack,
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                                isMobile ? 18 : context.deviceHeight() * 0.1,
                          ),
                          Container(
                            margin: const EdgeInsetsDirectional.only(),
                            width: context.deviceWidth() *
                                (context.isDesktop() ? 0.5 : 0.8),
                            child: BlocBuilder<MstUsrRoleBloc, MstUsrRoleState>(
                              builder: (context, state) {
                                if (state is MasterRoleLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Row(
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
                                        text: 'Yes, delete',
                                        borderRadius: 8,
                                        onTap: () {
                                          bloc(DeleteRole(
                                            username: widget.username,
                                            validFrom: widget.validFrom,
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
    );
  }
}
