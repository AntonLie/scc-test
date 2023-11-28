import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/mon_log.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class LogTable extends StatelessWidget {
  final List<LogModel> listData;
  final Function(LogModel) onView;

  const LogTable({super.key, required this.listData, required this.onView});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceWidth(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      // width: context.deviceWidth() * 0.21,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "Process ID".toUpperCase(),
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
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(8),
                      // width: context.deviceWidth() * 0.26,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "Module".toUpperCase(),
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
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(8),
                      // width: context.deviceWidth() * 0.15,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "Function".toUpperCase(),
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
                      // width: context.deviceWidth() * 0.15,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "Created By".toUpperCase(),
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
                      // width: context.deviceWidth() * 0.15,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "Process Date".toUpperCase(),
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
                      // width: context.deviceWidth() * 0.15,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "End Date".toUpperCase(),
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
                      // width: context.deviceWidth() * 0.15,
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
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      // width: context.deviceWidth() * 0.15,
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
            children: listData.isNotEmpty
                ? listData
                    .map((e) => Container(
                          decoration: BoxDecoration(
                            color: (e.status == Constant.PS_FAIL)
                                ? ((e.no?.isOdd == true)
                                    ? sccRed.withOpacity(0.1)
                                    : sccRed.withOpacity(0.05))
                                : ((e.no?.isOdd == true)
                                    ? sccChildTrackFilling
                                    : sccWhite),
                            border: const Border(
                              // top: BorderSide(color: sccLightGrayDivider, width: 2),
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
                                  (e.no.toString()),
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: context.scaleFont(14),
                                    // fontWeight: FontWeight.bold,
                                    // color: element.status?.systemCd == Constant.PS_FAIL ? VccRed : VccBlack,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  // color: Colors.green,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  child: TableContent(value: e.processId),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  // color: Colors.red,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  child: TableContent(value: e.moduleName),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  // color: Colors.blue,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  child: TableContent(value: e.functionName),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  // color: Colors.grey,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  child: TableContent(value: e.createdBy),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  // color: Colors.yellow,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  child: TableContent(value: e.startDt),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  // color: Colors.amberAccent,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  child: TableContent(value: e.endDt ?? "-"),
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
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 7, bottom: 9),

                                      // margin: const EdgeInsets.symmetric(horizontal: 12),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: e.status == Constant.PS_SUCCESS
                                            ? sccButtonGreen
                                            : e.status == Constant.PS_FAIL
                                                ? sccRed
                                                : e.status ==
                                                        Constant.PS_SUCCESS_WARN
                                                    ? sccYellow
                                                    : sccButtonBlue,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                      ),
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              context.deviceWidth() * 0.065),
                                      child: Text(
                                        e.status == Constant.PS_SUCCESS
                                            ? "Success"
                                            : e.status == Constant.PS_FAIL
                                                ? "Failed"
                                                : e.status ==
                                                        Constant.PS_SUCCESS_WARN
                                                    ? "Warning"
                                                    : "In Progress",
                                        style: TextStyle(
                                          fontSize: context.dynamicFont(13),
                                          color: sccWhite,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    true, //canView || canUpdate || canDelete,
                                child: Expanded(
                                  flex: 2,
                                  child: Container(
                                    // color: Colors.orange,
                                    alignment: Alignment.centerLeft,
                                    // width: context.deviceWidth() * 0.08,
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: true,
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              onView(e);
                                            },
                                            // constraints: BoxConstraints(
                                            // maxWidth: context.deviceWidth() * 0.04,
                                            // ),
                                            icon: HeroIcon(
                                              HeroIcons.eye,
                                              // solid: true,
                                              size: context.deviceWidth() *
                                                  0.0125,
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
                        ))
                    .toList()
                : [const EmptyData()],
          ),
        ],
      ),
    );
  }
}
