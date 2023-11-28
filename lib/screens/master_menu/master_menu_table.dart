import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/drag_behaviour.dart';
import 'package:scc_web/model/menu_model.dart';

import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class MasterMenuTable extends StatefulWidget {
  final List<MenuModel> listModel;
  final Function(MenuModel) onView, onDelete, onEdit, onSelect;
  final bool canView, canUpdate, canDelete;
  const MasterMenuTable(
      {super.key,
      required this.listModel,
      required this.onView,
      required this.onDelete,
      required this.onEdit,
      required this.onSelect,
      required this.canView,
      required this.canUpdate,
      required this.canDelete});

  @override
  State<MasterMenuTable> createState() => _MasterMenuTableState();
}

class _MasterMenuTableState extends State<MasterMenuTable> {
  Widget headerTabel(String title, {double? width, bool isCenter = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      // width: width ?? context.deviceWidth(),
      child: Text(
        title,
        textAlign: isCenter ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          fontSize: context.scaleFont(14),
          color: sccText3,
          overflow: TextOverflow.clip,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget itemTable(String element) {
    return Container(
      alignment: Alignment.centerLeft,
      // height: context.deviceHeight() * 0.08,
      padding: const EdgeInsets.all(8),
      child: TableContent(value: element),
    );
  }

  Widget dekstopView(MenuModel element) {
    return Container(
      decoration: BoxDecoration(
        // color: sccWhite,
        color: (element.no?.isOdd == true) ? sccChildTrackFilling : sccWhite,
        border: const Border(
          // top: BorderSide(color: VccLightGrayDivider, width: 2),
          bottom: BorderSide(
            color: sccLightGrayDivider,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.all(4),
      // decoration: BoxDecoration(
      //   border: Border.all(color: VccBorder, width: 1.8),
      //   borderRadius: BorderRadius.circular(250),
      // ),
      // padding: const EdgeInsets.all(10),
      // margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(bottom: 8, left: 16, top: 8, right: 8),
            // width: 100,
            width: ((widget.listModel.last.no ?? 0) < 100)
                ? 50
                : ((widget.listModel.last.no ?? 0) < 1000)
                    ? 60
                    : 100,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: SelectableText(
              (element.no ?? "-").toString(),
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
          //   child: Container(padding: const EdgeInsets.symmetric(horizontal: 2), width: context.deviceWidth() * 0.15, child: rowButton(element)),
          // ),
          Expanded(
            child: itemTable(
              element.menuName ?? "-",
            ),
          ),
          Expanded(
            child: itemTable(
              element.parentMenuName ?? "-",
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              // height: context.deviceHeight() * 0.08,
              padding: const EdgeInsets.all(8),
              child:
                  //  Builder(builder: (context) {
                  // if (element.listFeature?.isNotEmpty == true) {
                  //   return Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: element.listFeature!.map((e) {
                  //       return SelectableText(
                  //         e.featureName ?? "[UNKNOWN FEATURE NAME]",
                  //         textAlign: TextAlign.start,
                  //         style: TextStyle(
                  //           fontSize: context.scaleFont(14),
                  //           // fontWeight: FontWeight.bold,
                  //           color: VccBlack,
                  //           overflow: TextOverflow.clip,
                  //         ),
                  //       );
                  //     }).toList(),
                  //   );
                  // } else {
                  // return
                  ButtonConfirm(
                width: context.deviceWidth() * 0.075,
                verticalMargin: 0,
                text: (element.listFeature?.isNotEmpty == true)
                    ? "Detail"
                    : "Add",
                borderRadius: 250,
                onTap: () {
                  widget.onSelect(element);
                },
                // );
                // }
                // }
              ),
            ),
          ),
          // itemTable(
          //   element.createdBy ?? "-",
          //   context.deviceWidth() * 0.1,
          // ),
          // itemTable(
          //   localizeIsoDateStr(element.createdDt),
          //   context.deviceWidth() * 0.1,
          // ),
          // itemTable(
          //   element.changedBy ?? "-",
          //   context.deviceWidth() * 0.1,
          // ),
          // itemTable(
          //   localizeIsoDateStr(element.changedDt),
          //   context.deviceWidth() * 0.1,
          // ),
        ],
      ),
    );
  }

  Widget itemMobileView(String title, String? value) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: context.scaleFont(14),
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.bold,
                  color: sccText3,
                ),
              ),
            ),
            Text(
              " : ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: context.scaleFont(14),
                overflow: TextOverflow.clip,
                fontWeight: FontWeight.bold,
                color: sccBlack,
              ),
            ),
            Expanded(
              child: SelectableText(
                value ?? "-",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: context.scaleFont(14),
                  overflow: TextOverflow.clip,
                  // fontWeight: FontWeight.bold,
                  color: sccText3,
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            color: sccBorder,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget rowButton(MenuModel element) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          // visible: canView,
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
        Visibility(
          // visible: canView && canUpdate,
          child: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => widget.onEdit(element),
            icon: HeroIcon(
              HeroIcons.pencil,
              // solid: true,
              color: sccYellow,
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
        Visibility(
          // visible: canDelete,
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
      ],
    );
  }

  Widget mobileView(MenuModel element) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: context.deviceWidth() * 0.85,
      decoration: const BoxDecoration(
        color: sccWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            itemMobileView('Menu', element.menuName),
            itemMobileView('Menu Type', element.menuTypeName),
            itemMobileView('Parent Menu', element.parentMenuName),
            itemMobileView('Menu Seq', (element.menuSeq ?? "-").toString()),
            itemMobileView('Menu Desc', element.menuDesc),
            // itemMobileView('Created By', element.createdBy),
            // itemMobileView('Created Date', localizeIsoDateStr(element.createdDt)),
            // itemMobileView('Changed By', element.changedBy),
            // itemMobileView('Changed Date', localizeIsoDateStr(element.changedDt)),
            Visibility(
              visible: widget.canView || widget.canUpdate || widget.canDelete,
              child: rowButton(element),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return SizedBox(
      width: context.deviceWidth(),
      child: LayoutBuilder(
        builder: (ctx, ctn) {
          return ScrollConfiguration(
            behavior: DragBehavior(),
            child: Scrollbar(
              // isAlwaysShown: true,
              controller: controller,
              child: SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: !isMobile,
                      child: Container(
                        width: ctn.maxWidth,
                        decoration: const BoxDecoration(
                          color: sccWhite,
                          border: Border(
                            top: BorderSide(
                                color: sccLightGrayDivider, width: 2),
                            bottom: BorderSide(
                                color: sccLightGrayDivider, width: 2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                                left: 16,
                                top: 8,
                                right: 8,
                              ),
                              width: (widget.listModel.isEmpty ||
                                      ((widget.listModel.last.no ?? 0) < 100))
                                  ? 50
                                  : ((widget.listModel.last.no ?? 0) < 1000)
                                      ? 60
                                      : 100,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Text(
                                "NO",
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: context.scaleFont(14),
                                  fontWeight: FontWeight.bold,
                                  color: sccBlack,
                                ),
                              ),
                            ),
                            Expanded(
                              child: headerTabel(
                                'MENU',
                                // context.deviceWidth() * 0.15,
                              ),
                            ),
                            Expanded(
                              child: headerTabel(
                                'PARENT MENU',
                                // context.deviceWidth() * 0.15,
                              ),
                            ),
                            Expanded(
                              child: headerTabel(
                                'FEATURE',
                                // context.deviceWidth() * 0.15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: !isMobile ? ctn.maxWidth : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.listModel.map((element) {
                          return isMobile
                              ? mobileView(element)
                              : dekstopView(element);
                        }).toList(),
                      ),
                    ),
                    Visibility(
                      visible: !isMobile,
                      child: const SizedBox(height: 12),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
