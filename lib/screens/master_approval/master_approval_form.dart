import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';

import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/approval.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class MasterApprovalForm extends StatelessWidget {
  final GetViewApp model;
  final Function() onReject, onApprove, onClose;
  const MasterApprovalForm(
      {super.key,
      required this.model,
      required this.onReject,
      required this.onApprove,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Details',
                style: TextStyle(
                  fontSize: context.scaleFont(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                color: sccLightGrayDivider,
                height: 25,
                thickness: 2,
              ),
              Row(
                children: [
                  SizedBox(
                    width: context.deviceWidth() * 0.37,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Supplier Name',
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(12),
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.supplierName ?? "-",
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Item Code',
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(12),
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.itemCd ?? "-",
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Business Process Code',
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(12),
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.useCaseCd ?? "-",
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: context.deviceWidth() * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Format Serial Number',
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(12),
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.attributeSerialNumber ?? "-",
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'item Name',
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(12),
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.itemName ?? "-",
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Business Process Name',
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(12),
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.useCaseName ?? "-",
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Business Process Desc',
                style: TextStyle(
                    color: sccBlack,
                    fontSize: context.scaleFont(12),
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                model.useCaseDesc ?? "-",
                style: TextStyle(
                    color: sccBlack,
                    fontSize: context.scaleFont(14),
                    fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  SizedBox(
                    width: context.deviceWidth() * 0.37,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Start Date ',
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(12),
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.startDt ?? "-",
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: context.deviceWidth() * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'End Date',
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(12),
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.endDt ?? "-",
                          style: TextStyle(
                              color: sccBlack,
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Touch Point',
                  style: TextStyle(
                    fontSize: context.scaleFont(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  color: sccLightGrayDivider,
                  height: 25,
                  thickness: 2,
                ),
                Column(
                    children: model.useCasePointList!.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.pointCd ?? "-",
                            style: TextStyle(
                              fontSize: context.scaleFont(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(
                            color: sccLightGrayDivider,
                            height: 25,
                            thickness: 2,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: context.deviceWidth() * 0.37,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Point Name',
                                      style: TextStyle(
                                          color: sccBlack,
                                          fontSize: context.scaleFont(12),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      e.typePoint ?? "-",
                                      style: TextStyle(
                                          color: sccBlack,
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: context.deviceWidth() * 0.3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Type',
                                      style: TextStyle(
                                          color: sccBlack,
                                          fontSize: context.scaleFont(12),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      e.typePointName ?? "-",
                                      style: TextStyle(
                                          color: sccBlack,
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox()
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }).toList()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonCancel(
                        text: "Cancel",
                        // width: context.deviceWidth() *
                        //     (context.isDesktop() ? 0.11 : 0.4),
                        width: context.deviceWidth() *
                            (context.isDesktop() ? 0.13 : 0.37),
                        borderRadius: 8,
                        marginVertical: !isMobile ? 11 : 8,
                        onTap: () {
                          onClose();
                        },
                      ),
                      SizedBox(
                        width: 8.wh,
                      ),
                      Visibility(
                        visible: model.statusCd != Constant.PNS_APPROVED,
                        child: ButtonConfirm(
                          text: "Approve",
                          verticalMargin: !isMobile ? 11 : 8,
                          colour: sccGreen,
                          width: context.deviceWidth() *
                              (context.isDesktop() ? 0.13 : 0.37),
                          borderRadius: 8,
                          onTap: () {
                            onApprove();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8.wh,
                      ),
                      Visibility(
                        visible: model.statusCd != Constant.PNS_REJECTED,
                        child: ButtonConfirm(
                          text: "Reject",
                          verticalMargin: !isMobile ? 11 : 8,
                          colour: sccRed,
                          width: context.deviceWidth() *
                              (context.isDesktop() ? 0.13 : 0.37),
                          borderRadius: 8,
                          onTap: () {
                            onReject();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
