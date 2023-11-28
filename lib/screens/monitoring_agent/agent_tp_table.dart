import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/mon_agent.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

import '../../helper/constant.dart';

class AgentTpTable extends StatelessWidget {
  final List<AgentTp> listTP;

  const AgentTpTable({super.key, required this.listTP});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: !isMobile,
          child: Container(
            decoration: const BoxDecoration(
              color: sccWhite,
              border: Border(
                top: BorderSide(color: sccLightGrayDivider, width: 2),
                bottom: BorderSide(color: sccLightGrayDivider, width: 2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      bottom: 8, left: 16, top: 8, right: 8),
                  width:
                      (listTP.isEmpty || ((listTP.last.seqNumber ?? 0) < 100))
                          ? 50
                          : ((listTP.last.seqNumber ?? 0) < 1000)
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
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: SelectableText(
                      "Client ID".toUpperCase(),
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: sccBlack,
                        fontSize: context.scaleFont(12),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: SelectableText(
                      "Point Name".toUpperCase(),
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: sccBlack,
                        fontSize: context.scaleFont(12),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: SelectableText(
                      "Point Code".toUpperCase(),
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: sccBlack,
                        fontSize: context.scaleFont(12),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: SelectableText(
                      "Last submit data".toUpperCase(),
                      style: TextStyle(
                        color: sccBlack,
                        fontSize: context.scaleFont(12),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: SelectableText(
                        "Status".toUpperCase(),
                        style: TextStyle(
                          color: sccBlack,
                          fontSize: context.scaleFont(12),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: listTP.isNotEmpty
              ? listTP.map((e) {
                  return Container(
                    decoration: BoxDecoration(
                      color: ((e.seqNumber?.isOdd == true)
                          ? sccChildTrackFilling
                          : sccWhite),
                      border: const Border(
                        bottom:
                            BorderSide(color: sccLightGrayDivider, width: 1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 16, top: 8, right: 8),
                          width: ((listTP.last.seqNumber ?? 0) < 100)
                              ? 50
                              : ((listTP.last.seqNumber ?? 0) < 1000)
                                  ? 60
                                  : 100,
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: SelectableText(
                            "${(e.seqNumber ?? "-")}",
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: context.scaleFont(14),
                              // fontWeight: FontWeight.bold,
                              // color: element.status?.systemCd == Constant.PS_FAIL ? sccRed : sccBlack,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(
                              value: e.clientId ?? "-",
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(
                              value: e.pointName ?? "-",
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(
                              value: e.pointCd ?? "-",
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(
                              value: (e.lastSubmitDate ?? "-")
                                  .replaceAll("T", " "),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Container(
                              // padding: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.only(top: 7, bottom: 9),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: e.status == "Up"
                                    ? sccDeliveredText
                                    : e.status == "Down"
                                        ? sccButtonCancel
                                        : e.status == "Warning"
                                            ? sccYellow
                                            : sccBlack,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(25)),
                              ),
                              constraints: BoxConstraints(
                                  maxWidth: context.deviceWidth() * 0.055),
                              child: Text(
                                e.status ?? "-",
                                style: TextStyle(
                                  fontSize: context.scaleFont(12),

                                  color: sccWhite,

                                  // color: e.status == Constant.STATUS_UP
                                  //     ? sccDeliveredText
                                  //     : e.status == Constant.STATUS_DOWN
                                  //         ? sccButtonCancel
                                  //         : e.status == Constant.STATUS_WARN
                                  //             ? sccYellow
                                  //             : sccBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()
              : [const EmptyData()],
        ),
      ],
    );
  }
}
