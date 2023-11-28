import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/temp_attr.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class TmplAttrTable extends StatelessWidget {
  final List<TempAttr> listModel;
  final Function(TempAttr) onView, onDelete, onEdit;
  final Function(String?) onError;
  final TempAttr model;
  final TempAttr modelSubmit;
  final Color? color;
  final bool canView, canUpdate, canDelete;
  const TmplAttrTable(
      {super.key,
      required this.listModel,
      required this.onView,
      required this.onDelete,
      required this.onEdit,
      required this.onError,
      required this.model,
      required this.modelSubmit,
      this.color,
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
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: SelectableText(
                    "TEMPLATE ATTRIBUTE CODE",
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
                  child: SelectableText(
                    "TEMPLATE ATTRIBUTE NAME",
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
                  padding: const EdgeInsets.all(8),
                  child: SelectableText(
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
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    // color: sccAmber,
                    child: SelectableText(
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
                            padding: const EdgeInsets.all(8),
                            child: TableContent(value: element.tempAttrCd),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(value: element.tempAttrName),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(value: element.createdBy),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: TableContent(value: element.updateDt),
                          ),
                        ),
                        Visibility(
                          visible: canView || canUpdate || canDelete,
                          child: Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              // height: context.deviceHeight() * 0.08,
                              // color: sccAmber,
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
                  const SimpleEmptyContainer(),
                ],
        ),
        SizedBox(
          height: 4.wh,
        ),
      ],
    );
  }
}
