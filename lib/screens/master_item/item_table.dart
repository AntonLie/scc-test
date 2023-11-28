import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/assign_mst_item.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class ItemTable extends StatefulWidget {
  final bool canAdd, canEdit;
  final List<AssignMstItem> listItem;
  final Function(AssignMstItem) onAdd, onEdit;
  const ItemTable(
      {super.key,
      required this.canAdd,
      required this.canEdit,
      required this.listItem,
      required this.onAdd,
      required this.onEdit});

  @override
  State<ItemTable> createState() => _ItemTableState();
}

class _ItemTableState extends State<ItemTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: sccWhite,
            border: Border(
              top: BorderSide(color: sccLightGrayDivider, width: 2),
              bottom: BorderSide(color: sccLightGrayDivider, width: 2),
            ),
          ),
          // padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 16, right: 8),
                width: (widget.listItem.isEmpty ||
                        ((widget.listItem.last.no ?? 0) < 100))
                    ? 50
                    : ((widget.listItem.last.no ?? 0) < 1000)
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
              Container(
                width: context.deviceWidth() * 0.1,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8),
                // width: context.deviceWidth() * 0.2,
                child: Text(
                  "ITEM CODE",
                  textAlign: TextAlign.center,
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
                width: context.deviceWidth() * 0.18,
                // color: sccGreen,
                child: Text(
                  "ITEM DESCRIPTION",
                  textAlign: TextAlign.center,
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
                width: context.deviceWidth() * 0.12,
                child: Text(
                  "BUSINESS PROCESS",
                  textAlign: TextAlign.center,
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
                padding: const EdgeInsets.all(8),
                width: context.deviceWidth() * 0.1,
                // color: sccBlue,
                child: Text(
                  "STATUS",
                  textAlign: TextAlign.center,
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
                padding: const EdgeInsets.all(8),
                width: context.deviceWidth() * 0.15,
                // color: sccBlue,
                child: Text(
                  "LATEST UPDATED",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: context.scaleFont(12),
                    fontWeight: FontWeight.bold,
                    color: sccBlack,
                  ),
                ),
              ),
              Visibility(
                visible: true,
                child: Expanded(
                  child: Container(
                    // color: sccAmber,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
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
            children: widget.listItem.isNotEmpty
                ? widget.listItem
                    .map(
                      (e) => Container(
                        decoration: BoxDecoration(
                          color: (e.no?.isOdd == true)
                              ? sccChildTrackFilling
                              : sccWhite,
                          // color: sccWhite,
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
                                  right: 8, left: 16, top: 8, bottom: 8),
                              width: (widget.listItem.isEmpty ||
                                      ((widget.listItem.last.no ?? 0) < 100))
                                  ? 50
                                  : ((widget.listItem.last.no ?? 0) < 1000)
                                      ? 60
                                      : 100,
                              alignment: Alignment.centerLeft,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Text(
                                e.no.toString(),
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: context.scaleFont(14),
                                  color: sccBlack,
                                ),
                              ),
                            ),
                            Container(
                              width: context.deviceWidth() * 0.1,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.itemCd),
                            ),
                            Container(
                              // color: sccAmber,
                              width: context.deviceWidth() * 0.18,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.itemDesc),
                            ),
                            Container(
                              // color: sccAmber,
                              width: context.deviceWidth() * 0.12,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.useCaseName),
                            ),
                            SizedBox(
                              // color: sccBlue,
                              width: context.deviceWidth() * 0.1,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                width: context.deviceWidth() * 0.2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: e.statusCd == Constant.rejected
                                        ? sccRed
                                        : e.statusCd == Constant.waiting
                                            ? sccYellow
                                            : e.statusCd == Constant.registered
                                                ? sccDeliveredText
                                                : e.statusCd ==
                                                        Constant.required
                                                    ? sccButtonBlue
                                                    : e.statusCd ==
                                                            Constant
                                                                .unregistered
                                                        ? sccTextGray
                                                        : e.statusCd ==
                                                                Constant.maximum
                                                            ? sccAmber
                                                            : sccBlack,
                                  ),
                                  width: double.infinity,
                                  height: 30,
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 7),
                                  alignment: Alignment.center,
                                  child: Text(
                                    e.statusCd == Constant.rejected
                                        ? "Rejected"
                                        : e.statusCd == Constant.waiting
                                            ? "Waiting"
                                            : e.statusCd == Constant.registered
                                                ? "Registered"
                                                : e.statusCd ==
                                                        Constant.required
                                                    ? "Required"
                                                    : e.statusCd ==
                                                            Constant
                                                                .unregistered
                                                        ? "Unregistered"
                                                        : e.statusCd ==
                                                                Constant.maximum
                                                            ? "Maximum Date"
                                                            : "[UNDEFINED]",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: context.scaleFont(12),
                                      fontWeight: FontWeight.w600,
                                      color: sccWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              width: context.deviceWidth() * 0.15,
                              // color: sccBlue,
                              child: TableContent(value: e.lastUpdated),
                            ),
                            Visibility(
                              visible:
                                  true, //canView || canUpdate || canDelete,
                              child: Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  // color: sccAmber,
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible: widget.canAdd,
                                        child: Expanded(
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              widget.onAdd(e);
                                            },
                                            icon: HeroIcon(
                                              HeroIcons.plus,
                                              size: context.deviceWidth() *
                                                  0.0125,
                                              color: sccButtonBlue,
                                            ),
                                            tooltip: "Add",
                                            hoverColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            disabledColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            splashRadius: 10,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: true, //canView && canUpdate,
                                        child: Expanded(
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              widget.onEdit(e);
                                            },
                                            icon: HeroIcon(
                                              HeroIcons.pencil,
                                              size: context.deviceWidth() *
                                                  0.0125,
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
                : [
                    SizedBox(
                      width: context.deviceWidth() * 0.75,
                      child: const EmptyContainer(),
                    ),
                  ])
      ],
    );
  }
}

class DateTable extends StatefulWidget {
  final AssignMstItem listModel;
  const DateTable({super.key, required this.listModel});

  @override
  State<DateTable> createState() => _DateTableState();
}

class _DateTableState extends State<DateTable> {
  DateTime? tgl;

  @override
  void initState() {
    tgl = convertStringToDate(widget.listModel.lastUpdated ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8),
      child: SelectableText(
        convertDateToStringFormat(tgl, "dd-MMMM-yyyy HH:mm:ss"),
        textAlign: TextAlign.left,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: context.scaleFont(14),
        ),
      ),
    );
  }
}
