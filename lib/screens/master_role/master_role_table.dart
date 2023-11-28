// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/new_edit_role.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/theme/colors.dart';

class MasterRoleTable extends StatelessWidget {
  final List<ListDataNewEditRole> listModel;
  final Function(ListDataNewEditRole) onView, onDelete, onEdit;
  final bool canView, canUpdate, canDelete;
  const MasterRoleTable({
    Key? key,
    required this.canDelete,
    required this.canView,
    required this.canUpdate,
    required this.listModel,
    required this.onView,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

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
          child: Visibility(
            visible: !isMobile,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 16, right: 8),
                  width: //50,
                      (listModel.isEmpty) || ((listModel.last.no ?? 0) < 100)
                          ? 50
                          : ((listModel.last.no ?? 0) < 1000)
                              ? 60
                              : 100,
                  // width: 50,
                  // width: context.deviceWidth() * 0.05,
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
                    child: SelectableText(
                      "ROLE NAME",
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
                    child: SelectableText(
                      "DESCRIPTION",
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
                    width: context.deviceWidth() * 0.1,
                    child: SelectableText(
                      "DATE UPDATED",
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
                  // visible: true,
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      // 0.11 -> 0.16
                      // width: context.deviceWidth() * 0.11,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              right: 8, left: 16, top: 8, bottom: 8),
                          width:
                              //  50,
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
                            width: context.deviceWidth() * 0.2,
                            child: Tooltip(
                              message: element.roleName ?? "-",
                              decoration: BoxDecoration(
                                color: sccBlack.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              textStyle: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: sccWhite,
                                fontSize: context.scaleFont(14),
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  element.roleName ?? "-",
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: context.scaleFont(14),
                                  ),
                                ),
                              ),
                            ),
                            // SelectableText(
                            //   element.roleName ?? "-",
                            //   textAlign: TextAlign.left,
                            //   style: TextStyle(
                            //     overflow: TextOverflow.ellipsis,
                            //     fontSize: context.scaleFont(14),
                            //   ),
                            // ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            // height: context.deviceHeight() * 0.08,
                            padding: const EdgeInsets.all(8),
                            width: context.deviceWidth() * 0.2,
                            child: Tooltip(
                              message: element.roleDesc ?? "-",
                              decoration: BoxDecoration(
                                color: sccBlack.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              textStyle: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: sccWhite,
                                fontSize: context.scaleFont(14),
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  element.roleDesc ?? "-",
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: context.scaleFont(14),
                                  ),
                                ),
                              ),
                            ),
                            // SelectableText(
                            //   element.roleDesc ?? "-",
                            //   textAlign: TextAlign.left,
                            //   style: TextStyle(
                            //     overflow: TextOverflow.ellipsis,
                            //     fontSize: context.scaleFont(14),
                            //   ),
                            // ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            // height: context.deviceHeight() * 0.08,
                            padding: const EdgeInsets.all(8),
                            width: context.deviceWidth() * 0.1,
                            child: SelectableText(
                              element.updatedLatest ?? "-",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: context.scaleFont(14),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          // visible: canView || canUpdate || canDelete,
                          visible: true,
                          child: Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  // visible: canView,
                                  visible: true,
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
                                Visibility(
                                  visible: canView && canUpdate,
                                  // visible: true,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () => onEdit(element),
                                    icon: HeroIcon(
                                      HeroIcons.pencil,
                                      // solid: true,
                                      size: context.deviceWidth() * 0.0125,
                                      color: sccBlue,
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
                                  // visible: canDelete,
                                  visible: true,
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()
              : [
                  isMobile
                      ? const EmptyContainer()
                      : const SimpleEmptyContainer(),
                ],
        ),
        SizedBox(
          height: 12.wh,
        )
      ],
    );
  }
}
