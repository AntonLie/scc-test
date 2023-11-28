import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/master_product.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class MasterProductTable extends StatefulWidget {
  final bool canView, canUpdate, canDelete;
  final List<MasterProductModel> listProduct;
  final Function(MasterProductModel) onView, onDelete, onEdit;
  const MasterProductTable(
      {super.key,
      required this.canView,
      required this.canUpdate,
      required this.canDelete,
      required this.listProduct,
      required this.onView,
      required this.onDelete,
      required this.onEdit});

  @override
  State<MasterProductTable> createState() => _MasterProductTableState();
}

class _MasterProductTableState extends State<MasterProductTable> {
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
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 16, right: 8),
                // width: 50,
                width: (widget.listProduct.isEmpty ||
                        ((widget.listProduct.last.no ?? 0) < 100))
                    ? 50
                    : ((widget.listProduct.last.no ?? 0) < 1000)
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
                  // width: context.deviceWidth() * 0.2,
                  child: Text(
                    "PRODUCT NAME",
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
                    "PRODUCT DESCRIPTION",
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
                  child: Text(
                    "TOUCH POINT",
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
                visible: true,
                child: Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    // 0.11 -> 0.16
                    // width: context.deviceWidth() * 0.11,
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
            children: widget.listProduct.isNotEmpty
                ? widget.listProduct
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
                              width: (widget.listProduct.isEmpty ||
                                      ((widget.listProduct.last.no ?? 0) < 100))
                                  ? 50
                                  : ((widget.listProduct.last.no ?? 0) < 1000)
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
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(8),
                                child: TableContent(value: e.productName),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(8),
                                child: TableContent(value: e.description),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(8),
                                child: TableContent(value: e.touchPoint ?? "-"),
                              ),
                            ),
                            Visibility(
                              visible:
                                  true, //canView || canUpdate || canDelete,
                              child: Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  // width: context.deviceWidth() * 0.08,
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible: widget.canView,
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () => widget.onView(e),
                                          icon: HeroIcon(
                                            HeroIcons.eye,
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
                                      Visibility(
                                        visible:
                                            widget.canView && widget.canUpdate,
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () => widget.onEdit(e),
                                          icon: HeroIcon(
                                            HeroIcons.pencil,
                                            size:
                                                context.deviceWidth() * 0.0125,
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
                                          onPressed: () {
                                            widget.onDelete(e);
                                          },
                                          icon: HeroIcon(
                                            HeroIcons.trash,
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
                : [const EmptyContainer()]),
      ],
    );
  }
}
