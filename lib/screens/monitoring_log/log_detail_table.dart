
import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/mon_log.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class LogDtlTable extends StatelessWidget {
  final List<LogModel> listData;

  const LogDtlTable({super.key, required this.listData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceWidth(), //* 0.1,
      child: Column(
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      bottom: 8, left: 16, top: 8, right: 8),
                  width: (listData.isEmpty || ((listData.last.no ?? 0) < 100))
                      ? 50
                      : ((listData.last.no ?? 0) < 1000)
                          ? 60
                          : 100,
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
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                  width: context.deviceWidth() * 0.11,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(
                    "Message ID".toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(12),
                      fontWeight: FontWeight.bold,
                      color: sccBlack,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  width: context.deviceWidth() * 0.1,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(
                    "Message Type".toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(12),
                      fontWeight: FontWeight.bold,
                      color: sccBlack,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  width: context.deviceWidth() * 0.085,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(
                    "Location".toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(12),
                      fontWeight: FontWeight.bold,
                      color: sccBlack,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    // width: context.deviceWidth() * 0.12,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Message Detail".toUpperCase(),
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
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
                  width: context.deviceWidth() * 0.13,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(
                    "Message Date Time".toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(12),
                      fontWeight: FontWeight.bold,
                      color: sccBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: listData.isNotEmpty
                ? listData.map(
                    (element) {
                      return Container(
                        decoration: BoxDecoration(
                          color: (element.messageType == Constant.MLT_ERROR)
                              ? ((element.no?.isOdd == true)
                                  ? sccRed.withOpacity(0.1)
                                  : sccRed.withOpacity(0.05))
                              : ((element.no?.isOdd == true)
                                  ? sccChildTrackFilling
                                  : sccWhite),
                          border: const Border(
                            bottom: BorderSide(
                                color: sccLightGrayDivider, width: 1),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  bottom: 8, left: 16, top: 8, right: 8),
                              width: ((listData.last.no ?? 0) < 100)
                                  ? 50
                                  : ((listData.last.no ?? 0) < 1000)
                                      ? 60
                                      : 100,
                              alignment: Alignment.centerLeft,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: SelectableText(
                                "${(element.no ?? "")}",
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: context.scaleFont(14),
                                  // fontWeight: FontWeight.bold,
                                  color:
                                      element.messageType == Constant.MLT_ERROR
                                          ? sccRed
                                          : sccBlack,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 8),
                              width: context.deviceWidth() * 0.11,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: TableContent(
                                value: element.messageId ?? "-",
                                color: element.messageType == Constant.MLT_ERROR
                                    ? sccRed
                                    : sccBlack,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              width: context.deviceWidth() * 0.1,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: TableContent(
                                value:
                                    "${element.systemValue ?? ""} - ${element.systemDesc ?? ""}",
                                color: element.messageType == Constant.MLT_ERROR
                                    ? sccRed
                                    : sccBlack,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              width: context.deviceWidth() * 0.085,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: TableContent(
                                value: element.location ?? "-",
                                color: element.messageType == Constant.MLT_ERROR
                                    ? sccRed
                                    : sccBlack,
                                fontSize: 14,
                              ),
                            ),
                            Expanded(
                              // flex: 10,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                // width: context.deviceWidth() * 0.15,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: TableContent(
                                  value: element.messageDetail ?? "-",
                                  color:
                                      element.messageType == Constant.MLT_ERROR
                                          ? sccRed
                                          : sccBlack,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, right: 16),
                              width: context.deviceWidth() * 0.13,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: TableContent(
                                value: element.messageDateTime ?? "-",
                                color: element.messageType == Constant.MLT_ERROR
                                    ? sccRed
                                    : sccBlack,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList()
                : [
                    const EmptyData(),
                  ],
          ),
          // SizedBox(
          //   height: 8,
          // )
        ],
      ),
      //     ),
      //   ),
      // ),
    );
  }
}
