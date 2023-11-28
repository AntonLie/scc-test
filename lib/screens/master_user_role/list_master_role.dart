// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/user_role.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/theme/colors.dart';

class ListMasterRole extends StatefulWidget {
  final List<MasterRole> model;
  final Function(MasterRole val) onEdit, onView, onDelete;
  final bool canView, canUpdate, canDelete;
  const ListMasterRole({
    Key? key,
    required this.model,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
    required this.canView,
    required this.canUpdate,
    required this.canDelete,
  }) : super(key: key);

  @override
  _ListMasterRoleState createState() => _ListMasterRoleState();
}

class _ListMasterRoleState extends State<ListMasterRole> {
  Widget rowButton(MasterRole element) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.canView,
          child: Expanded(
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () => widget.onView(element),
              icon: HeroIcon(
                HeroIcons.eye,
                // solid: true,
                color: sccButtonBlue,
                size: context.deviceWidth() * 0.0125,
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
              onPressed: () => widget.onEdit(element),
              icon: HeroIcon(
                HeroIcons.pencil,
                // solid: true,
                color: sccButtonBlue,
                size: context.deviceWidth() * 0.0125,
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
              onPressed: () => widget.onDelete(element),
              icon: HeroIcon(
                HeroIcons.trash,
                // solid: true,
                color: sccRed,
                size: context.deviceWidth() * 0.0125,
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
    );
  }

  Widget dekstopView(MasterRole element) {
    return Container(
      decoration: BoxDecoration(
        color: (element.seq?.isOdd == true) ? sccChildTrackFilling : sccWhite,
        border: const Border(
          // top: BorderSide(color: sccLightGrayDivider, width: 2),
          bottom: BorderSide(color: sccLightGrayDivider, width: 1),
        ),
      ),
      padding: const EdgeInsets.all(4),
      // margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.only(bottom: 8, left: 16, top: 8, right: 8),
            width: ((widget.model.last.seq ?? 0) < 100)
                ? 50
                : ((widget.model.last.seq ?? 0) < 1000)
                    ? 60
                    : 100,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Text(
              (element.seq ?? "-").toString(),
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: context.scaleFont(14),
                // fontWeight: FontWeight.bold,
                color: sccBlack,
              ),
            ),
          ),
          // Visibility(
          //   visible: widget.canView || widget.canUpdate || widget.canDelete,
          //   child:

          // ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              // height: context.deviceHeight() * 0.08,
              padding: const EdgeInsets.all(8),
              child: Tooltip(
                message: element.username ?? "-",
                decoration: BoxDecoration(
                  color: sccBlack.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                textStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: sccWhite,
                  fontSize: context.scaleFont(14),
                ),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    element.username ?? "-",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                    ),
                  ),
                ),
              ),
              //TableContent(value: element.username),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.centerLeft,
                // height: context.deviceHeight() * 0.08,
                padding: const EdgeInsets.all(8),
                child: Tooltip(
                  message: element.brand ?? "-",
                  decoration: BoxDecoration(
                    color: sccBlack.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  textStyle: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: sccWhite,
                    fontSize: context.scaleFont(14),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      element.brand ?? "-",
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: context.scaleFont(14),
                      ),
                    ),
                  ),
                )
                //TableContent(value: element.brand),
                ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              // height: context.deviceHeight() * 0.08,
              padding: const EdgeInsets.all(8),
              child: Tooltip(
                message: element.companyName ?? "-",
                decoration: BoxDecoration(
                  color: sccBlack.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                textStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: sccWhite,
                  fontSize: context.scaleFont(14),
                ),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    element.companyName ?? "-",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                    ),
                  ),
                ),
              ),
              //TableContent(value: element.company),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              // height: context.deviceHeight() * 0.08,
              padding: const EdgeInsets.all(8),
              child: Tooltip(
                message: element.email ?? "-",
                decoration: BoxDecoration(
                  color: sccBlack.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                textStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: sccWhite,
                  fontSize: context.scaleFont(14),
                ),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    element.email ?? "-",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(14),
                    ),
                  ),
                ),
              ),
              //TableContent(value: element.email),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              // height: context.deviceHeight() * 0.08,
              padding: const EdgeInsets.all(8),
              child: Builder(builder: (context) {
                if (element.roleList?.isNotEmpty == true) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: element.roleList!.map((e) {
                      return Tooltip(
                        message: e.roleName ?? "-",
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
                            e.roleName ?? "-",
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: context.scaleFont(14),
                            ),
                          ),
                        ),
                      );
                      //TableContent(value: e.roleName);
                    }).toList(),
                  );
                } else {
                  return Container();
                }
              }),
            ),
          ),
          Expanded(child: rowButton(element)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final controller = ScrollController();
    return
        // widget.model.isNotEmpty
        //     ?
        //   ScrollConfiguration(
        // behavior: DragBehavior(),
        // child: Scrollbar(
        //   isAlwaysShown: true,
        //   controller: controller,
        //   child: SingleChildScrollView(
        //     controller: controller,
        //     scrollDirection: Axis.horizontal,
        //     child:
        SizedBox(
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      bottom: 8, left: 16, top: 8, right: 8),
                  width: (widget.model.isEmpty ||
                          ((widget.model.last.seq ?? 0) < 100))
                      ? 50
                      : ((widget.model.last.seq ?? 0) < 1000)
                          ? 60
                          : 100,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(
                    "No".toUpperCase(),
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: context.scaleFont(12),
                      fontWeight: FontWeight.bold,
                      color: sccBlack,
                    ),
                  ),
                ),
                // Visibility(
                //   visible: widget.canView || widget.canUpdate || widget.canDelete,
                //   child:

                // ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Username".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: context.scaleFont(12),
                          color: sccText3,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Brand".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: context.scaleFont(12),
                          color: sccText3,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Company".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: context.scaleFont(12),
                          color: sccText3,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Email".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: context.scaleFont(12),
                          color: sccText3,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Role".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: context.scaleFont(12),
                          color: sccText3,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Action".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: context.scaleFont(12),
                          color: sccText3,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.model.isNotEmpty
                  ? widget.model.map((e) => dekstopView(e)).toList()
                  //  widget.model.map((element) {
                  //     return dekstopView(element);
                  //   }).toList()
                  : [const EmptyData()]),
          SizedBox(
            height: 8.wh,
          ),
        ],
      ),
      //     ),
      //   ),
      // ),
    )
        // : EmptyContainer()
        ;
  }
}
