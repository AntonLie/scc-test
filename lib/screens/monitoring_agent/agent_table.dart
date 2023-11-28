import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/mon_agent.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class AgentTable extends StatefulWidget {
  final List<Agent> listAgent;
  final Function(Agent) onView;
  const AgentTable({super.key, required this.listAgent, required this.onView});

  @override
  State<AgentTable> createState() => _AgentTableState();
}

class _AgentTableState extends State<AgentTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  width: (widget.listAgent.isEmpty ||
                          ((widget.listAgent.last.seqNumber ?? 0) < 100))
                      ? 50
                      : ((widget.listAgent.last.seqNumber ?? 0) < 1000)
                          ? 60
                          : 100,
                  // width: 60,
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
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.146,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Company".toUpperCase(),
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
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.146,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Client".toUpperCase(),
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
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.2,
                    decoration: const BoxDecoration(
                      // color: sccRed,
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Last Updated".toUpperCase(),
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
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.1,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Status".toUpperCase(),
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
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.1,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Action".toUpperCase(),
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
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.listAgent.isNotEmpty
              ? widget.listAgent
                  .map(
                    (e) => Container(
                      decoration: BoxDecoration(
                        color: (e.seqNumber?.isOdd == true)
                            ? sccChildTrackFilling
                            : sccWhite,
                        // color: sccWhite,
                        border: const Border(
                          bottom:
                              BorderSide(color: sccLightGrayDivider, width: 1),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                right: 8, left: 16, top: 8, bottom: 8),
                            width: (widget.listAgent.isEmpty ||
                                    ((widget.listAgent.last.seqNumber ?? 0) <
                                        100))
                                ? 50
                                : ((widget.listAgent.last.seqNumber ?? 0) <
                                        1000)
                                    ? 60
                                    : 100,
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Text(
                              e.seqNumber.toString(),
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: context.scaleFont(14),
                                color: sccBlack,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.companyName),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.clientId),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              // color: sccRed,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HeroIcon(
                                    HeroIcons.calendarDays,
                                    size: 18,
                                    color: sccNavText2.withOpacity(0.5),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  TableContent(value: e.lastConnectDt),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              // width: context.deviceWidth() * 0.1,
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Center(
                                child: Container(
                                  // padding: const EdgeInsets.symmetric(
                                  //     vertical: 10, horizontal: 10),
                                  padding:
                                      const EdgeInsets.only(top: 7, bottom: 9),
                                  // margin: const EdgeInsets.symmetric(horizontal: 12),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: e.status == "Up"
                                        ? sccDeliveredText
                                        : e.status == "Down"
                                            ? sccButtonCancel
                                            : e.status == "Warning"
                                                ? sccYellow
                                                : sccBlack,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100)),
                                  ),
                                  constraints: BoxConstraints(
                                      maxWidth: context.deviceWidth() * 0.055),
                                  child: Text(
                                    e.status ?? "-",
                                    // "Warning",
                                    // e.status == Constant.STATUS_UP
                                    //     ? "Active"
                                    //     : e.status == Constant.STATUS_DOWN
                                    //         ? "Down"
                                    //         : e.status == Constant.STATUS_WARN
                                    //             ? "Warning"
                                    //             : "Undefined",
                                    style: TextStyle(
                                      fontSize: context.scaleFont(12),
                                      color: sccWhite,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true, //canView || canUpdate || canDelete,
                            child: Expanded(
                              flex: 3,
                              child: Container(
                                alignment: Alignment.center,
                                // width: context.deviceWidth() * 0.08,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: true,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          widget.onView(e);
                                        },
                                        // constraints: BoxConstraints(
                                        // maxWidth: context.deviceWidth() * 0.04,
                                        // ),
                                        icon: HeroIcon(
                                          HeroIcons.eye,
                                          // solid: true,
                                          size: context.deviceWidth() * 0.0125,
                                          color: sccButtonBlue,
                                        ),
                                        tooltip: "View details",
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        disabledColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        splashRadius: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList()
              : [const EmptyData()],
        ),
        SizedBox(
          height: 4.wh,
        ),
      ],
    );
  }
}
