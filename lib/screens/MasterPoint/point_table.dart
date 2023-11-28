import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
// import 'package:scc_web/helper/horizontal_drag_scroll.dart';
// import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/point.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
// import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class MasterPointTable extends StatelessWidget {
  final List<ListDataNewPoint> listModel;
  final Function(ListDataNewPoint) onView, onDelete, onEdit, onJson;
  final bool canView, canUpdate, canDelete, canJson;
  const MasterPointTable(
      {required this.listModel,
      required this.onView,
      required this.onEdit,
      required this.onDelete,
      required this.canView,
      required this.canUpdate,
      required this.canDelete,
      Key? key,
      required this.onJson,
      required this.canJson})
      : super(key: key);

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
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  // width: context.deviceWidth() * 0.2,
                  child: Text(
                    "Point Name".toUpperCase(),
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
                    "Type".toUpperCase(),
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
                    "Template Atribute".toUpperCase(),
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
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  width: context.deviceWidth() * 0.1,
                  child: Text(
                    "Master Consume".toUpperCase(),
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
                  alignment: Alignment.center,
                  // height: context.deviceHeight() * 0.08,
                  padding: const EdgeInsets.all(8),
                  width: context.deviceWidth() * 0.1,
                  child: Text(
                    "Last Update".toUpperCase(),
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
              Visibility(
                visible: canView || canUpdate || canDelete,
                child: Expanded(
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
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              // height: context.deviceHeight() * 0.08,
                              padding: const EdgeInsets.all(8),
                              // width: context.deviceWidth() * 0.2,
                              child: TableContent(
                                value: element.pointName,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              // height: context.deviceHeight() * 0.08,
                              padding: const EdgeInsets.all(8),
                              width: context.deviceWidth() * 0.2,
                              child: TableContent(
                                value: element.pointType,
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
                              child: TableContent(
                                value: element.tmplAttrCd,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              // height: context.deviceHeight() * 0.08,
                              padding: const EdgeInsets.all(8),
                              width: context.deviceWidth() * 0.1,
                              child: TableContent(
                                value:
                                    element.flagConsume == false ? 'no' : 'yes',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              // height: context.deviceHeight() * 0.08,
                              padding: const EdgeInsets.all(8),
                              width: context.deviceWidth() * 0.1,
                              child: TableContent(
                                value: element.lastUpdated,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: canView || canUpdate || canDelete,
                            child: Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                // height: context.deviceHeight() * 0.08,
                                padding: const EdgeInsets.all(8),
                                width: context.deviceWidth() * 0.11,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: canView,
                                      child: Expanded(
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () => onView(element),
                                          icon: HeroIcon(
                                            HeroIcons.eye,
                                            // solid: true,
                                            size:
                                                context.deviceWidth() * 0.0125,
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
                                      visible: canView && canUpdate,
                                      child: Expanded(
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () => onEdit(element),
                                          icon: HeroIcon(
                                            HeroIcons.pencil,
                                            // solid: true,
                                            size:
                                                context.deviceWidth() * 0.0125,
                                            color: sccAmber,
                                          ),
                                          tooltip: "Edit",
                                          hoverColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          disabledColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          splashRadius: 10,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: canDelete,
                                      child: Expanded(
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () => onJson(element),
                                          icon: HeroIcon(
                                            HeroIcons.codeBracketSquare,
                                            // solid: true,

                                            size:
                                                context.deviceWidth() * 0.0125,
                                            color: sccWarningText,
                                          ),
                                          tooltip: "View Json Script",
                                          hoverColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          disabledColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          splashRadius: 10,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: canDelete,
                                      child: Expanded(
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () => onDelete(element),
                                          icon: HeroIcon(
                                            HeroIcons.trash,
                                            // solid: true,

                                            size:
                                                context.deviceWidth() * 0.0125,
                                            color: sccWarningText,
                                          ),
                                          tooltip: "Delete",
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
                : [const EmptyData()]),
      ],
    );
  }
}
