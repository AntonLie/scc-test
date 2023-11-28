// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:heroicons/heroicons.dart';

import 'package:scc_web/helper/app_scale.dart';

import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class PackageTable extends StatefulWidget {
  final List<PackageList> listModel;
  final Function(PackageList) onDelete, onView, onEdit;
  final bool canView, canUpdate, canDelete;
  const PackageTable(
      {super.key,
      required this.canView,
      required this.canUpdate,
      required this.canDelete,
      required this.listModel,
      required this.onDelete,
      required this.onView,
      required this.onEdit});

  @override
  State<PackageTable> createState() => _PackageTableState();
}

class _PackageTableState extends State<PackageTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
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
                  width: //50,
                      (widget.listModel.isEmpty) ||
                              ((widget.listModel.last.no ?? 0) < 100)
                          ? 50
                          : ((widget.listModel.last.no ?? 0) < 1000)
                              ? 60
                              : 100,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(
                    "No",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(16),
                      fontWeight: FontWeight.bold,
                      color: sccBlack,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Package Name",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: context.scaleFont(16),
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
                    child: Text(
                      "Price Package",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: context.scaleFont(16),
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
                    child: Text(
                      "Subscribers",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: context.scaleFont(16),
                        fontWeight: FontWeight.bold,
                        color: sccBlack,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      widget.canView || widget.canUpdate || widget.canDelete,
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      // 0.11 -> 0.16
                      // width: context.deviceWidth() * 0.11,
                      child: Text(
                        "Actions",
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: context.scaleFont(16),
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
            children: widget.listModel.isNotEmpty
                ? widget.listModel.map((element) {
                    return Container(
                      decoration: BoxDecoration(
                        color: (element.no?.isOdd == true)
                            ? sccChildTrackFilling
                            : sccWhite,
                        border: Border(
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
                            decoration: BoxDecoration(
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
                              alignment: Alignment.centerLeft,
                              // height: context.deviceHeight() * 0.08,
                              padding: const EdgeInsets.all(8),
                              // width: context.deviceWidth() * 0.2,
                              child: TableContent(
                                value: element.packageName,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              // height: context.deviceHeight() * 0.08,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(
                                  value: (element.pricePackage ?? "0")),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              // height: context.deviceHeight() * 0.08,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(
                                value: (element.subscribers ?? 0).toString(),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.canView ||
                                widget.canUpdate ||
                                widget.canDelete,
                            child: Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                // height: context.deviceHeight() * 0.08,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: widget.canView,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () => widget.onView(element),
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
                                      visible:
                                          widget.canView && widget.canUpdate,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () =>
                                            {widget.onEdit(element)},
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
                                    Visibility(
                                      visible: widget.canDelete,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () =>
                                            widget.onDelete(element),
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                : [EmptyData()],
          )
        ]);
  }
}
