import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/approval/bloc/approval_bloc.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/approval.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class ApprovReject extends StatefulWidget {
  final ListApproval model;
  final String? reject;
  final Function() onLogout;
  final Function(String) onError;

  const ApprovReject({
    super.key,
    required this.onLogout,
    required this.onError,
    required this.model,
    this.reject,
  });

  @override
  State<ApprovReject> createState() => _ApprovRejectState();
}

class _ApprovRejectState extends State<ApprovReject> {
  Timer? timer;

  bloc(ApprovalEvent event) {
    BlocProvider.of<ApprovalBloc>(context).add(event);
  }

  GetViewApp submitModel = GetViewApp();

  final reject = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  void initState() {
    submitModel.itemCd = widget.model.itemCd;
    submitModel.statusCd = widget.reject;
    submitModel.supplierCd = widget.model.supplierCd;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  : const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sccWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                      widget.reject == Constant.PNS_APPROVED
                          ? "Approval Item Approved ? "
                          : "Reject item ${widget.model.itemName!.trim()} ?",
                      style: TextStyle(
                        fontSize: context.scaleFont(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isMobile ? (context.deviceHeight() * 0.04) : 24,
                  ),
                  BlocListener<ApprovalBloc, ApprovalState>(
                    listener: (context, state) {
                      if (state is ApprovalError) {
                        context.back();
                        widget.onError(state.msg);
                      }
                      if (state is OnLogoutApproval) {
                        context.back();
                        widget.onLogout();
                      }
                      if (state is SuccessApprov) {
                        timer = Timer(const Duration(seconds: 3), () {
                          context.back();
                        });
                      }
                    },
                    child: BlocBuilder<ApprovalBloc, ApprovalState>(
                      builder: (context, state) {
                        if (state is SuccessApprov) {
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
                                    text: widget.reject == Constant.PNS_APPROVED
                                        ? '<b>${widget.model.itemName}</b> Approved Success.'
                                        : '<b>${widget.model.itemName}</b> Rejected.',
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
                                  height: 12,
                                ),
                                Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      bottom: 16),
                                  child: SelectableText(
                                    widget.reject == Constant.PNS_APPROVED
                                        ? "Are You Sure want to Approve Business Process \n ${widget.model.itemName!.trim()} from ${widget.model.supplierName ?? ""} ? "
                                        : "Are You Sure want to Reject Business Process \n ${widget.model.itemName!.trim()} from ${widget.model.supplierName ?? ""} ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: context.scaleFont(16),
                                        // fontWeight: FontWeight.bold,
                                        color: sccText1),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      widget.reject == Constant.PNS_APPROVED,
                                  child: SizedBox(
                                    height: isMobile
                                        ? 18
                                        : context.deviceHeight() * 0.05,
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      widget.reject != Constant.PNS_APPROVED,
                                  child: Form(
                                    key: key,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StyledText(
                                          text: 'Rejected Reason'
                                              ' <r>*</r>'
                                              '',
                                          style: TextStyle(
                                              fontSize: context.scaleFont(12)),
                                          tags: {
                                            'r': StyledTextTag(
                                                style: TextStyle(
                                                    fontSize:
                                                        context.scaleFont(12),
                                                    color: sccDanger))
                                          },
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          child: CustomFormTextField(
                                            maxLine: 5,
                                            controller: reject,
                                            hint: 'Input Rejected Reason',
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty &&
                                                      (widget.reject !=
                                                          Constant
                                                              .PNS_APPROVED)) {
                                                return "This field is mandatory";
                                              } else if (value.trim().length >
                                                  400) {
                                                return "Only 200 characters for maximum allowed";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (val) {
                                              submitModel.notes = val;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      widget.reject != Constant.PNS_APPROVED,
                                  child: SizedBox(
                                    height: isMobile
                                        ? 18
                                        : context.deviceHeight() * 0.05,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsetsDirectional.only(),
                                  width: context.deviceWidth() *
                                      (context.isDesktop() ? 0.5 : 0.8),
                                  child:
                                      BlocBuilder<ApprovalBloc, ApprovalState>(
                                    builder: (context, state) {
                                      if (state is ApprovalLoading) {
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
                                              colour: widget.reject ==
                                                      Constant.PNS_APPROVED
                                                  ? sccGreen
                                                  : sccRed,
                                              text: widget.reject ==
                                                      Constant.PNS_APPROVED
                                                  ? 'Yes, Approved'
                                                  : 'Yes, Rejected',
                                              borderRadius: 8,
                                              onTap: () {
                                                if (widget.reject !=
                                                    Constant.PNS_APPROVED) {
                                                  if (key.currentState!
                                                      .validate()) {
                                                    bloc(SubmitApproval(
                                                        widget.reject,
                                                        model: submitModel));
                                                  }
                                                } else {
                                                  bloc(SubmitApproval(
                                                      widget.reject,
                                                      model: submitModel));
                                                }
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
              child: BlocBuilder<ApprovalBloc, ApprovalState>(
                builder: (context, state) {
                  return Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        if (state is! ApprovalLoading) {
                          context.back();
                        }
                      },
                      splashColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: sccText2.withOpacity(0.5), width: 0.5),
                          color: sccWhite,
                        ),
                        child: const HeroIcon(
                          HeroIcons.xCircle,
                          size: 12,
                          color: sccText2,
                          // size: 16,
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
