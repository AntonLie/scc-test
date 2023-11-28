import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/transaction.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class TransactionTableRowItem extends StatefulWidget {
  final List<TransactionModel> list;
  const TransactionTableRowItem({super.key, required this.list});

  @override
  State<TransactionTableRowItem> createState() =>
      _TransactionTableRowItemState();
}

class _TransactionTableRowItemState extends State<TransactionTableRowItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: const BoxDecoration(
              color: sccTransactionTableHead,
            ),
            child: Row(
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
                      color: sccTransactionTableHead,
                    ),
                    child: const Text(
                      "",
                    )),
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
                      color: sccTransactionTableHead,
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
                  width: context.deviceWidth() * 0.1,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: sccTransactionTableHead,
                  ),
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
                  width: context.deviceWidth() * 0.18,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: sccTransactionTableHead,
                  ),
                  child: Text(
                    "Item ID",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  ),
                ),
                Container(
                  width: context.deviceWidth() * 0.1,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: sccTransactionTableHead,
                  ),
                  child: Text(
                    "Item Code",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  ),
                ),
                Container(
                  width: context.deviceWidth() * 0.1,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: sccTransactionTableHead,
                  ),
                  child: Text(
                    "Box ID",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  ),
                ),
                Container(
                  width: context.deviceWidth() * 0.12,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: sccTransactionTableHead,
                  ),
                  child: Text(
                    "Current Touch Point",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: sccBlack,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: sccTransactionTableHead,
                    ),
                    child: const Text(
                      "",
                    ),
                  ),
                )
              ],
            )),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.list.isNotEmpty
              ? widget.list
                  .map((e) => Container(
                        decoration: const BoxDecoration(
                          color: sccWhite,
                          border: Border(
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
                              child: Checkbox(
                                value: false,
                                onChanged: (vale) => {print("test")},
                              ),
                            ),
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
                              child: e.no != null
                                  ? Text(
                                      e.no.toString(),
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: context.scaleFont(14),
                                        color: sccBlack,
                                      ),
                                    )
                                  : Icon(Icons.warning,
                                      color: Colors.red,
                                      size: context.scaleFont(12)),
                            ),
                            Container(
                              width: context.deviceWidth() * 0.1,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.itemName),
                            ),
                            Container(
                              width: context.deviceWidth() * 0.18,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.itemId),
                            ),
                            Container(
                              width: context.deviceWidth() * 0.1,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.itemCode),
                            ),
                            Container(
                              width: context.deviceWidth() * 0.1,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.boxId),
                            ),
                            Container(
                              width: context.deviceWidth() * 0.12,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              child: TableContent(value: e.currentTouchPoint),
                            ),
                            Flexible(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  "track position",
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600,
                                    color: sccPrimaryDashboard,
                                  ),
                                ),
                              ),
                            ),
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
