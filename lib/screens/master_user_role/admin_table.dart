import 'package:flutter/material.dart';

import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';


class AdminTable extends StatefulWidget {
  final bool canView, canUpdate, canDelete;
  const AdminTable(
      {super.key,
      required this.canView,
      required this.canUpdate,
      required this.canDelete});

  @override
  State<AdminTable> createState() => _AdminTableState();
}

class _AdminTableState extends State<AdminTable> {
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
                width: 50,
                decoration: const BoxDecoration(
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
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  // width: context.deviceWidth() * 0.2,
                  child: Text(
                    "UserName",
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
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  // width: context.deviceWidth() * 0.2,
                  child: Text(
                    "Brand",
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
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  width: context.deviceWidth() * 0.1,
                  child: Text(
                    "Company",
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
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  width: context.deviceWidth() * 0.1,
                  child: Text(
                    "Email",
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
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  width: context.deviceWidth() * 0.1,
                  child: Text(
                    "Role",
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
                visible: true,
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
          children: [
            Container(
              decoration: const BoxDecoration(
                color: sccWhite,
                border: Border(
                  // top: BorderSide(color: VccLightGrayDivider, width: 2),
                  bottom: BorderSide(color: sccLightGrayDivider, width: 1),
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
                    width: 50,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "1",
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
                      child: const TableContent(
                        value: "element.pointName",
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
                      child: const TableContent(
                        value: 'element.partVehicleTypeCd',
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
                      child: const TableContent(
                        value: "element.templateAttrCd",
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
                      child: const TableContent(
                        value: "element.templateAttrCd",
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
                      child: const TableContent(
                        value: "element.templateAttrCd",
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        widget.canView || widget.canUpdate || widget.canDelete,
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
                              visible: widget.canView,
                              child: Expanded(
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    // context.push(AdminFormRoute(
                                    //     formMode: Constant.viewMode));
                                  },
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
                              visible: widget.canView && widget.canUpdate,
                              child: Expanded(
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    // context.push(AdminFormRoute(
                                    //     formMode: Constant.editMode));
                                  },
                                  icon: HeroIcon(
                                    HeroIcons.pencil,
                                    // solid: true,
                                    size: context.deviceWidth() * 0.0125,
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
                              visible: widget.canDelete,
                              child: Expanded(
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {},
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
            )
          ],
        )
      ],
    );
  }
}
