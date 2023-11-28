import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/master_supplier.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class MasterSupplierTable extends StatelessWidget {
  final bool canView, canUpdate, canDelete;
  final List<Supplier> listSupplier;
  final Function(Supplier) onView, onDelete, onEdit;
  const MasterSupplierTable(
      {super.key,
      required this.canView,
      required this.canUpdate,
      required this.canDelete,
      required this.listSupplier,
      required this.onView,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceWidth(),
      child: Column(
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
            // padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 16, right: 8),
                  // width: 50,
                  width: (listSupplier.isEmpty ||
                          ((listSupplier.last.no ?? 0) < 100))
                      ? 50
                      : ((listSupplier.last.no ?? 0) < 1000)
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    // width: context.deviceWidth() * 0.2,
                    // color: sccRed,
                    child: Text(
                      "SUPPLIER CODE & NAME",
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
                  flex: 1,
                  child: Container(
                    // color: sccBlue,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.2,
                    child: Text(
                      "TYPE OF SUPPLIER",
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
                  flex: 1,
                  child: Container(
                    // color: sccGreen,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.1,
                    child: Text(
                      "COUNTRY - CITY",
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
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.1,
                    // color: sccInfoGrey,
                    child: Text(
                      "PHONE NUMBER",
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
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    // width: context.deviceWidth() * 0.1,
                    // color: sccButtonCancel,
                    child: Text(
                      "TOTAL ACCOUNT",
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
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      // color: sccAmber,
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
              children: listSupplier.isNotEmpty
                  ? listSupplier
                      .map((e) => Container(
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
                                  width: (listSupplier.isEmpty ||
                                          ((listSupplier.last.no ?? 0) < 100))
                                      ? 50
                                      : ((listSupplier.last.no ?? 0) < 1000)
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
                                    // color: sccRed,
                                    alignment: Alignment.centerLeft,
                                    // padding: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 4),
                                    child: TableContent(
                                        value:
                                            '${e.supplierCd!} - ${e.supplierName!}'),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    // color: sccBlue,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(8),
                                    child:
                                        TableContent(value: e.supplierTypeName),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    // color: sccGreen,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(8),
                                    child: TableContent(value: e.countryCity),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    // color: sccInfoGrey,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(8),
                                    child: TableContent(value: e.contactNumber),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    // color: sccButtonCancel,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8),
                                    child: TableContent(
                                        value: e.totalAccount.toString()),
                                  ),
                                ),
                                Visibility(
                                  visible: canView || canUpdate || canDelete,
                                  child: Expanded(
                                    child: Container(
                                      // color: sccAmber,
                                      alignment: Alignment.center,
                                      // width: context.deviceWidth() * 0.08,
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: canView,
                                            child: Expanded(
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                onPressed: () => onView(e),
                                                icon: HeroIcon(
                                                  HeroIcons.eye,
                                                  // solid: true,
                                                  size: context.deviceWidth() *
                                                      0.0125,
                                                  color: sccButtonBlue,
                                                ),
                                                tooltip: "View",
                                                hoverColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                disabledColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                splashRadius: 10,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: canUpdate && canView,
                                            child: Expanded(
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                onPressed: () => onEdit(e),
                                                icon: HeroIcon(
                                                  HeroIcons.pencil,
                                                  // solid: true,
                                                  size: context.deviceWidth() *
                                                      0.0125,
                                                  color: sccButtonBlue,
                                                ),
                                                tooltip: "Edit",
                                                hoverColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                disabledColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                splashRadius: 10,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: canDelete,
                                            child: Expanded(
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                onPressed: () => onDelete(e),
                                                // constraints: BoxConstraints(
                                                // maxWidth: context.deviceWidth() * 0.04,
                                                // ),
                                                icon: HeroIcon(
                                                  HeroIcons.trash,
                                                  // solid: true,
                                                  size: context.deviceWidth() *
                                                      0.0125,
                                                  color: sccWarningText,
                                                ),
                                                tooltip: "Delete",
                                                hoverColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                disabledColor:
                                                    Colors.transparent,
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
                          ))
                      .toList()
                  : [const EmptyData()]),
          SizedBox(
            height: 4.wh,
          ),
        ],
      ),
    );
  }
}
