// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:heroicons/heroicons.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/subscribers.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class SubscribersTableScreen extends StatelessWidget {
  final List<ListSubsTable> listModel;

  final Function(ListSubsTable) onView, onNotif, onCreate, onEdit;

  const SubscribersTableScreen({
    Key? key,
    required this.listModel,
    required this.onView,
    required this.onNotif,
    required this.onCreate,
    required this.onEdit,
  }) : super(key: key);

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                flex: 3,
                child: Container(
                  // color: Colors.blueAccent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Company Name".toUpperCase(),
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
                  // color: Colors.greenAccent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Package Name".toUpperCase(),
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
                  // color: Colors.yellowAccent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Package Price".toUpperCase(),
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
                  // color: Colors.purpleAccent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Gas Fee".toUpperCase(),
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
                  // color: Colors.redAccent,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Status".toUpperCase(),
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
                flex: 4,
                child: Container(
                  // color: Colors.orangeAccent,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Validity Periods".toUpperCase(),
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
                flex: 3,
                child: Container(
                  // color: Colors.greenAccent,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Action".toUpperCase(),
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
        Column(
            mainAxisSize: MainAxisSize.min,
            children: listModel.isNotEmpty
                ? listModel.map((element) {
                    return Container(
                      decoration: BoxDecoration(
                        color: (element.no?.isOdd == true)
                            ? sccChildTrackFilling
                            : sccWhite,
                        border: const Border(
                          // top: BorderSide(color: sccLightGrayDivider, width: 2),
                          bottom:
                              BorderSide(color: sccLightGrayDivider, width: 1),
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
                                ((element.no ?? 0) < 100)
                                    ? 50
                                    : ((element.no ?? 0) < 1000)
                                        ? 60
                                        : 100,
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Text(
                              element.no.toString(),
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
                              // color: sccBlue,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(
                                value: element.companyName,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              // color: sccAmber,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(
                                value: element.packageName ?? '-',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              // color: sccBorder,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(
                                  // value:CurrencyUtil.toIdr double.parse((element.packagePrice ?? 0.00).toString()),
                                  value: element.packagePrice),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              // color: sccAmber,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: element.gasFee),
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
                                  padding:
                                      const EdgeInsets.only(top: 7, bottom: 9),

                                  // margin: const EdgeInsets.symmetric(horizontal: 12),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: element.status == "Active"
                                        ? sccGreen
                                        : element.status == "New"
                                            ? sccBlue.withOpacity(0.4)
                                            : element.status == "Need Upgrade"
                                                ? sccButtonPurple
                                                    .withOpacity(0.5)
                                                : element.status == "Inactive"
                                                    ? sccText4
                                                    : sccBlack,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100)),
                                  ),
                                  constraints: BoxConstraints(
                                      maxWidth: context.deviceWidth() * 0.075),
                                  child: Text(
                                    element.status ?? "-",
                                    style: TextStyle(
                                      fontSize: context.scaleFont(12),
                                      color: element.status == "Active"
                                          ? sccWhite
                                          : element.status == "New"
                                              ? sccBlue
                                              : element.status == "Need Upgrade"
                                                  ? sccButtonPurple
                                                  : element.status == "Inactive"
                                                      ? sccWhite
                                                      : sccDisabled,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              // color: sccLightAmber,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: element.validPeriods),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              // color: sccGreen,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              width: context.deviceWidth() * 0.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: true,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () => onView(element),
                                      icon: HeroIcon(
                                        HeroIcons.eye,
                                        // solid: true,
                                        size: context.deviceWidth() * 0.0125,
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
                                  Visibility(
                                    visible: element.actionEdit!,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () => onEdit(element),
                                      icon: HeroIcon(
                                        HeroIcons.pencil,
                                        // solid: true,
                                        size: context.deviceWidth() * 0.0125,
                                        color: sccBlue,
                                      ),
                                      tooltip: "Edit",
                                      hoverColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      disabledColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      splashRadius: 10,
                                    ),
                                  ),
                                  Visibility(
                                    visible: element.notifButton!,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () => onNotif(element),
                                      icon: HeroIcon(
                                        HeroIcons.envelopeOpen,
                                        // solid: true,
                                        size: context.deviceWidth() * 0.0125,
                                        color: sccBlue,
                                      ),
                                      tooltip: "Notif",
                                      hoverColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      disabledColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      splashRadius: 10,
                                    ),
                                  ),
                                  Visibility(
                                    visible: element.actionCreate!,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () => onCreate(element),
                                      icon: HeroIcon(
                                        HeroIcons.documentPlus,
                                        // solid: true,
                                        size: context.deviceWidth() * 0.0125,
                                        color: sccBlue,
                                      ),
                                      tooltip: "Create",
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
                        ],
                      ),
                    );
                  }).toList()
                : [const EmptyData()])
      ],
    );
  }
}
