import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/detail_transaction.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class DetailItemTable extends StatefulWidget {
  final List<DetailTransactionModel> list;

  const DetailItemTable({super.key, required this.list});

  @override
  State<DetailItemTable> createState() => _DetailItemTableState();
}

class _DetailItemTableState extends State<DetailItemTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: sccWhite,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: const EdgeInsets.only(
                      right: 8, left: 16, top: 8, bottom: 8),
                  width: (widget.list.isEmpty ||
                          ((widget.list.last.no ?? 0) < 100))
                      ? 50
                      : ((widget.list.last.no ?? 0) < 1000)
                          ? 60
                          : 100,
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(
                    "No",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  )),
              Container(
                width: context.deviceWidth() * 0.15,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Item Name",
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: context.scaleFont(14),
                    fontWeight: FontWeight.w600,
                    color: sccBlack,
                  ),
                ),
              ),
              Container(
                  width: context.deviceWidth() * 0.15,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Item ID",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  )),
              Container(
                  width: context.deviceWidth() * 0.1,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Start Point",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  )),
              Container(
                  width: context.deviceWidth() * 0.1,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Next Point",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  )),
              Container(
                  width: context.deviceWidth() * 0.14,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Touchpoints",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  )),
              Container(
                  width: context.deviceWidth() * 0.07,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Status",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  )),
              Flexible(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: const TableContent(
                    value: "",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.list.isNotEmpty
              ? widget.list
                  .map((e) => Container(
                        decoration: BoxDecoration(
                          color: e.status != null ? sccWhite : sccDeathStock,
                          border: Border(
                            bottom: BorderSide(
                                color: e.status != null
                                    ? sccLightGrayDivider
                                    : Colors.transparent,
                                width: 1),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  right: 8, left: 16, top: 8, bottom: 8),
                              width: (widget.list.isEmpty ||
                                      ((widget.list.last.no ?? 0) < 100))
                                  ? 50
                                  : ((widget.list.last.no ?? 0) < 1000)
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
                              width: context.deviceWidth() * 0.15,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.itemName),
                            ),
                            Container(
                              width: context.deviceWidth() * 0.15,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.itemId),
                            ),
                            Container(
                              width: context.deviceWidth() * 0.1,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.startPoint),
                            ),
                            Container(
                              width: context.deviceWidth() * 0.1,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.nextPoint),
                            ),
                            Container(
                              width: context.deviceWidth() * 0.14,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.touchPoint),
                            ),
                            Container(
                                width: context.deviceWidth() * 0.07,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(8),
                                child: e.status != null
                                    ? Text(
                                        e.status ?? "",
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: context.scaleFont(14),
                                          fontStyle: FontStyle.italic,
                                          color: sccBlack,
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          Icon(Icons.warning,
                                              color: Colors.red,
                                              size: context.scaleFont(12)),
                                          // Text(
                                          //   "Dead Stock Supply",
                                          //   style: TextStyle(
                                          //     overflow: TextOverflow.ellipsis,
                                          //     fontSize: context.scaleFont(14),
                                          //     fontStyle: FontStyle.italic,
                                          //     color: sccBlack,
                                          //   ),
                                          // ),
                                        ],
                                      )),
                            Flexible(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(8),
                                child: const TableContent(
                                  value: "See Detail",
                                  color: sccPrimaryDashboard,
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                  .toList()
              : [
                  SizedBox(
                    width: context.deviceWidth() * 0.75,
                    child: const EmptyContainer(),
                  ),
                ],
        )
      ],
    );
  }
}
