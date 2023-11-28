import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/approval.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class ApprovalTable extends StatelessWidget {
  final bool canView, canReject, canApprove;
  final List<ListApproval> dataApproval;
  final Function(ListApproval) onView, onApprove, onReject;
  const ApprovalTable(
      {super.key,
      required this.canView,
      required this.canReject,
      required this.canApprove,
      required this.dataApproval,
      required this.onView,
      required this.onApprove,
      required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: const BoxDecoration(
                color: sccWhite,
                border: Border(
                  top: BorderSide(color: sccLightGrayDivider, width: 2),
                  bottom: BorderSide(color: sccLightGrayDivider, width: 2),
                ),
              ),
              padding: const EdgeInsets.only(right: 12),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 16, right: 8),
                  width: 50,
                  // (listModel.isEmpty) || ((listModel.last.no ?? 0) < 100)
                  //     ? 50
                  //     : ((listModel.last.no ?? 0) < 1000)
                  //         ? 60
                  //         : 100,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(
                    "No".toUpperCase(),
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(12),
                      fontWeight: FontWeight.bold,
                      color: sccBlack,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.2,
                    child: Text(
                      "Item Code".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: context.scaleFont(12),
                        fontWeight: FontWeight.bold,
                        color: sccBlack,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.2,
                    child: Text(
                      "Item Name".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: context.scaleFont(12),
                        fontWeight: FontWeight.bold,
                        color: sccBlack,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    // height: context.deviceHeight() * 0.08,
                    padding: const EdgeInsets.all(8),
                    width: context.deviceWidth() * 0.1,
                    child: Text(
                      "Supplier".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: context.scaleFont(12),
                        fontWeight: FontWeight.bold,
                        color: sccBlack,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Business Process".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: context.scaleFont(12),
                        fontWeight: FontWeight.bold,
                        color: sccBlack,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: canView || canReject || canApprove,
                  child: Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      // 0.11 -> 0.16
                      // width: context.deviceWidth() * 0.11,
                      child: Text(
                        "Actions".toUpperCase(),
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: context.scaleFont(12),
                          fontWeight: FontWeight.bold,
                          color: sccBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ])),
          Column(
              children: dataApproval.isNotEmpty
                  ? dataApproval.map((e) {
                      return Container(
                        decoration: BoxDecoration(
                          color: (e.no?.isOdd == true)
                              ? sccChildTrackFilling
                              : sccWhite,
                          border: const Border(
                            // top: BorderSide(color: sccLightGrayDivider, width: 2),
                            bottom: BorderSide(
                                color: sccLightGrayDivider, width: 1),
                          ),
                        ),
                        padding: const EdgeInsets.only(right: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  right: 8, left: 16, top: 8, bottom: 8),
                              width: // 50,
                                  ((e.no ?? 0) < 100)
                                      ? 50
                                      : ((e.no ?? 0) < 1000)
                                          ? 60
                                          : 100,
                              alignment: Alignment.centerLeft,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Text(
                                e.no.toString(),
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: context.scaleFont(14),
                                  color: sccBlack,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  // width: context.deviceWidth() * 0.2,
                                  child: TableContent(value: e.itemCd ?? "-")),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  // width: context.deviceWidth() * 0.2,
                                  child:
                                      TableContent(value: e.itemName ?? "-")),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  // height: context.deviceHeight() * 0.08,
                                  padding: const EdgeInsets.all(8),
                                  width: context.deviceWidth() * 0.1,
                                  child: TableContent(
                                      value: e.supplierName ?? "-")),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  width: context.deviceWidth() * 0.1,
                                  child: TableContent(
                                      value: e.useCaseName ?? "-")),
                            ),
                            Visibility(
                              visible: canView || canApprove || canReject,
                              child: Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  // height: context.deviceHeight() * 0.08,
                                  padding: const EdgeInsets.all(8),
                                  width: context.deviceWidth() * 0.11,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: canView,
                                        child: Expanded(
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () => onView(e),
                                            icon: HeroIcon(
                                              HeroIcons.eye,
                                              // solid: true,
                                              size:
                                                  context.deviceWidth() * 0.015,
                                              color: sccButtonBlue,
                                            ),
                                            tooltip: "View",
                                            hoverColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            disabledColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            splashRadius: 10,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: canView && canApprove,
                                        child: Expanded(
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              if (canView &&
                                                  canApprove &&
                                                  e.statusCd !=
                                                      Constant.PNS_APPROVED) {
                                                onApprove(e);
                                              } else {
                                                showTopSnackBar(
                                                    context,
                                                    const UpperSnackBar.info(
                                                        message:
                                                            " Can't Approve because the data has already been approved"));
                                              }
                                            },
                                            icon: HeroIcon(
                                              HeroIcons.checkCircle,
                                              // solid: true,
                                              size:
                                                  context.deviceWidth() * 0.015,
                                              color: e.statusCd ==
                                                      Constant.PNS_APPROVED
                                                  ? sccGreen.withOpacity(0.4)
                                                  : sccGreen,
                                            ),
                                            tooltip: e.statusCd ==
                                                    Constant.PNS_APPROVED
                                                ? "Can't Approve"
                                                : "Approve",
                                            hoverColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            disabledColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            splashRadius: 10,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: canReject,
                                        child: Expanded(
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              if (canReject &&
                                                  e.statusCd !=
                                                      Constant.PNS_REJECTED) {
                                                onReject(e);
                                              } else {
                                                showTopSnackBar(
                                                    context,
                                                    const UpperSnackBar.info(
                                                        message:
                                                            "Can't reject because the data has already been rejected"));
                                              }
                                            },
                                            icon: HeroIcon(
                                              HeroIcons.xCircle,

                                              // solid: true,

                                              size:
                                                  context.deviceWidth() * 0.015,
                                              color: e.statusCd ==
                                                      Constant.PNS_REJECTED
                                                  ? sccRed.withOpacity(0.4)
                                                  : sccRed,
                                            ),
                                            tooltip: e.statusCd ==
                                                    Constant.PNS_REJECTED
                                                ? "Can't Reject"
                                                : "Reject",
                                            hoverColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            disabledColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            splashRadius: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()
                  : [
                      const EmptyData(),
                    ]),
        ]);
  }
}
