// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/master_supplier/bloc/master_supplier_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class DeleteMstSupplier extends StatefulWidget {
  final String supplierCd, supplierName;
  final Function() onLogout;
  final Function(String) onError;

  const DeleteMstSupplier(
      {super.key,
      required this.supplierCd,
      required this.onLogout,
      required this.onError,
      required this.supplierName});

  @override
  State<DeleteMstSupplier> createState() => _DeleteMstSupplierState();
}

class _DeleteMstSupplierState extends State<DeleteMstSupplier> {
  Timer? timer;

  bloc(MasterSupplierEvent event) {
    BlocProvider.of<MasterSupplierBloc>(context).add(event);
  }

  @override
  Widget build(BuildContext context) {
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
                      "Delete Supplier?",
                      style: TextStyle(
                        fontSize: context.scaleFont(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isMobile ? (context.deviceHeight() * 0.04) : 24,
                  ),
                  BlocListener<MasterSupplierBloc, MasterSupplierState>(
                    listener: (context, state) {
                      if (state is MasterSupplierError) {
                        context.back();
                        widget.onError(state.msg);
                      }
                      if (state is OnLogoutMasterSupplier) {
                        context.back();
                        widget.onLogout();
                      }
                      if (state is SuppDeleted) {
                        timer = Timer(const Duration(seconds: 3), () {
                          context.back();
                        });
                      }
                    },
                    child: BlocBuilder<MasterSupplierBloc, MasterSupplierState>(
                      builder: (context, state) {
                        if (state is SuppDeleted) {
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
                                        '<b>${widget.supplierCd}</b> deleted successfully.',
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
                                    'Are You sure to delete Supplier : ${widget.supplierName}.',
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
                                  child: BlocBuilder<MasterSupplierBloc,
                                      MasterSupplierState>(
                                    builder: (context, state) {
                                      if (state is MasterSupplierLoading) {
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
                                                bloc(DeleteSupplier(
                                                  supplierCd: widget.supplierCd,
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
            //   child: BlocBuilder<MasterSupplierBloc, MasterSupplierState>(
            //     builder: (context, state) {
            //       return Positioned(
            //         right: 0,
            //         child: InkWell(
            //           onTap: () {
            //             if (state is! MasterSupplierLoading) {
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
