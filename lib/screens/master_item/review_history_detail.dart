import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/assign_mst_item.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/theme/colors.dart';

class ReviewHistoryTable extends StatefulWidget {
  final List<ReviewHistory> listHistory;
  final bool minimizeStatus;

  const ReviewHistoryTable({
    super.key,
    required this.listHistory,
    required this.minimizeStatus,
  });

  @override
  State<ReviewHistoryTable> createState() => _ReviewHistoryTableState();
}

class _ReviewHistoryTableState extends State<ReviewHistoryTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: !isMobile,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // width: context.deviceWidth() * 0.1,
                  width: widget.minimizeStatus == true
                      ? context.deviceWidth() * 0.1
                      : context.deviceWidth() * 0.15,
                  // color: sccRed,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: SelectableText(
                    "REVIEW STATUS",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(12),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  ),
                ),
                Container(
                  // width: context.deviceWidth() * 0.1,
                  width: widget.minimizeStatus == true
                      ? context.deviceWidth() * 0.1
                      : context.deviceWidth() * 0.15,
                  // color: sccBlue,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: SelectableText(
                    "DATE & TIME",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(12),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  ),
                ),
                Container(
                  // width: context.deviceWidth() * 0.1,
                  // color: sccBorder,
                  width: widget.minimizeStatus == true
                      ? context.deviceWidth() * 0.08
                      : context.deviceWidth() * 0.12,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: SelectableText(
                    "REVIEWER NAME",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(12),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  ),
                ),
                Container(
                  // width: context.deviceWidth() * 0.1,
                  // color: sccButtonGreen,
                  width: widget.minimizeStatus == true
                      ? context.deviceWidth() * 0.1
                      : context.deviceWidth() * 0.15,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: SelectableText(
                    "REASON",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(12),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.listHistory.isNotEmpty
                ? widget.listHistory.map((e) {
                    return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Container(
                          //   width: context.deviceWidth() * 0.1,
                          //   alignment: Alignment.centerLeft,
                          //   // height: context.deviceHeight() * 0.08,
                          //   padding: const EdgeInsets.all(8),
                          //   child: SelectableText(
                          //     (e.status == "PNS_REJECTED"
                          //             ? "Rejected"
                          //             : e.status == "PNS_WAITING"
                          //                 ? "Pending"
                          //                 : e.status == "PNS_APPROVED"
                          //                     ? "Registered"
                          //                     : "Unregistered")
                          //         .toString(),
                          //     textAlign: TextAlign.left,
                          //     style: TextStyle(
                          //       overflow: TextOverflow.ellipsis,
                          //       fontSize: context.scaleFont(12),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            // color: sccBlue,
                            // width: context.deviceWidth() * 0.08,
                            width: widget.minimizeStatus == true
                                ? context.deviceWidth() * 0.1
                                : context.deviceWidth() * 0.15,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              // width: 100,
                              width: context.deviceWidth() * 0.08,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: e.status == Constant.rejected
                                      ? sccButtonCancel
                                      : e.status == Constant.waiting
                                          ? sccYellow
                                          : e.status == Constant.registered
                                              ? sccDeliveredText
                                              : e.status == Constant.required
                                                  ? sccButtonBlue
                                                  : sccTextGray,
                                ),
                                width: double.infinity,
                                height: 30,
                                padding: const EdgeInsets.all(4),
                                alignment: Alignment.center,
                                child: Text(
                                  e.status == Constant.rejected
                                      ? "Rejected"
                                      : e.status == Constant.waiting
                                          ? "Waiting"
                                          : e.status == Constant.registered
                                              ? "Registered"
                                              : e.status == Constant.required
                                                  ? "Required"
                                                  : "Unregistered",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: context.scaleFont(12),
                                      fontWeight: FontWeight.w600,
                                      color: sccWhite),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // width: context.deviceWidth() * 0.1,
                            width: widget.minimizeStatus == true
                                ? context.deviceWidth() * 0.1
                                : context.deviceWidth() * 0.15,
                            alignment: Alignment.centerLeft,
                            // height: context.deviceHeight() * 0.08,
                            padding: const EdgeInsets.all(8),
                            child: SelectableText(
                              (e.dateTime ?? "-").toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: context.scaleFont(12),
                              ),
                            ),
                          ),
                          Container(
                            // width: context.deviceWidth() * 0.1,
                            width: widget.minimizeStatus == true
                                ? context.deviceWidth() * 0.08
                                : context.deviceWidth() * 0.12,
                            alignment: Alignment.centerLeft,
                            // height: context.deviceHeight() * 0.08,
                            padding: const EdgeInsets.all(8),
                            child: SelectableText(
                              (e.reviewer ?? "-").toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: context.scaleFont(12),
                              ),
                            ),
                          ),
                          Container(
                            // width: context.deviceWidth() * 0.1,
                            width: widget.minimizeStatus == true
                                ? context.deviceWidth() * 0.1
                                : context.deviceWidth() * 0.15,
                            alignment: Alignment.centerLeft,
                            // height: context.deviceHeight() * 0.08,
                            padding: const EdgeInsets.all(8),
                            child: SelectableText(
                              (e.reason ?? "-").toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: context.scaleFont(12),
                              ),
                            ),
                          ),
                        ]);
                  }).toList()
                : [const EmptyData()]),
      ],
    );
  }
}
