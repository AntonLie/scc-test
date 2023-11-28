import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/master_attribute.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class MstAttrTable extends StatelessWidget {
  final List<MstAttribute> listModel;
  final Function(MstAttribute) onView, onDelete, onEdit;
  final bool canView, canUpdate, canDelete;
  const MstAttrTable(
      {super.key,
      required this.listModel,
      required this.onView,
      required this.onDelete,
      required this.onEdit,
      required this.canView,
      required this.canUpdate,
      required this.canDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // width: isMobile ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width * 0.9,
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
                    top: 8, bottom: 8, left: 16, right: 8),
                width: (listModel.isEmpty || ((listModel.last.no ?? 0) < 100))
                    ? 50
                    : ((listModel.last.no ?? 0) < 1000)
                        ? 60
                        : 100,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Text(
                  "NO",
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
                  // color: sccButtonLightBlue,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "ATTRIBUTE CODE",
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
                child: Container(
                  // color: sccButtonGreen,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "ATTRIBUTE NAME",
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
                child: Container(
                  // color: sccButtonPurple,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "TYPE CODE",
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
                child: Container(
                  // color: sccRed,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "ATTRIBUTE DESC",
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
                child: Container(
                  alignment: Alignment.centerLeft,
                  // color: sccAmber,
                  padding: const EdgeInsets.all(8),
                  width: context.deviceWidth() * 0.08,
                  child: Text(
                    "CREATED BY",
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
                child: Container(
                  // color: sccBlue,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: SelectableText(
                    "DATE UPDATED",
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
                visible: canView || canUpdate || canDelete,
                child: Expanded(
                  child: Container(
                    // color: sccDanger,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.08,
                    child: Text(
                      "ACTION",
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
                      // color: sccWhite,
                      border: const Border(
                        bottom:
                            BorderSide(color: sccLightGrayDivider, width: 1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              right: 8, left: 16, top: 8, bottom: 8),

                          width: (listModel.isEmpty ||
                                  ((listModel.last.no ?? 0) < 100))
                              ? 50
                              : ((listModel.last.no ?? 0) < 1000)
                                  ? 60
                                  : 100,
                          //  50,
                          // ((element.no ?? 0) < 100)
                          //     ? 50
                          //     : ((element.no ?? 0) < 1000)
                          //         ? 60
                          //         : 100,
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
                          child: Container(
                            // color: sccButtonLightBlue,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(value: element.attributeCd),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // color: sccButtonGreen,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(value: element.attributeName),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // color: sccButtonPurple,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(value: element.attrTypeCd),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // color: sccRed,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(value: element.attrDesc),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // color: sccAmber,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            // width: context.deviceWidth() * 0.08,
                            child: Text(
                              element.createdBy ?? "-",
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: context.scaleFont(14),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // color: sccBlue,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            // width: context.deviceWidth() * 0.1,
                            child: TableContent(value: element.updateDt),
                          ),
                        ),
                        Visibility(
                          visible: canView || canUpdate || canDelete,
                          child: Expanded(
                            child: Container(
                              // color: sccDanger,
                              alignment: Alignment.center,
                              // width: context.deviceWidth() * 0.08,
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: canView,
                                    child: Expanded(
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () => onView(element),
                                        // constraints: BoxConstraints(
                                        // maxWidth: context.deviceWidth() * 0.04,
                                        // ),
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
                                  ),
                                  Visibility(
                                    visible: canView && canUpdate,
                                    child: Expanded(
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () => onEdit(element),
                                        // constraints: BoxConstraints(
                                        // maxWidth: context.deviceWidth() * 0.04,
                                        // ),
                                        icon: HeroIcon(
                                          HeroIcons.pencil,
                                          // solid: true,
                                          size: context.deviceWidth() * 0.0125,
                                          color: sccButtonBlue,
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
                                        onPressed: () => onDelete(element),
                                        // constraints: BoxConstraints(
                                        // maxWidth: context.deviceWidth() * 0.04,
                                        // ),
                                        icon: HeroIcon(
                                          HeroIcons.trash,
                                          // solid: true,
                                          size: context.deviceWidth() * 0.0125,
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
              : [
                  const EmptyData()
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 24, vertical: 12),
                  //   child: Center(
                  //     child: SelectableText(
                  //       'There is no data',
                  //       style: TextStyle(
                  //         fontSize: context.scaleFont(30),
                  //         fontWeight: FontWeight.bold,
                  //         color: sccBlack,
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
        ),
        SizedBox(
          height: 4.wh,
        ),
      ],
    );
  }
}
