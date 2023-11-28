import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/user_role.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';

class ListRoleMob extends StatelessWidget {
  final List<MasterRole> model;
  final Function(MasterRole val) onEdit, onView, onDelete;
  final bool canView, canUpdate, canDelete;
  const ListRoleMob({
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
  Widget build(BuildContext context) {
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
                    fontSize: context.scaleFont(16),
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
                  fontSize: context.scaleFont(16),
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
                    fontSize: context.scaleFont(16),
                    overflow: TextOverflow.clip,
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

    Widget rowButton(MasterRole element) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: canView,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () => onView(element),
              icon: const GradientWidget(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    sccButtonLightBlue,
                    sccButtonBlue,
                  ],
                ),
                child: HeroIcon(
                  HeroIcons.eye,
                ),
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
            visible: canUpdate,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () => onEdit(element),
              icon: const GradientWidget(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    sccLightAmber,
                    sccAmber,
                  ],
                ),
                child: HeroIcon(
                  HeroIcons.pencil,
                ),
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
            visible: canDelete,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () => onDelete(element),
              icon: const GradientWidget(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    sccLightWarningText,
                    sccWarningText,
                  ],
                ),
                child: HeroIcon(
                  HeroIcons.trash,
                ),
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

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: model.isNotEmpty
            ? model.map((element) {
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
                        itemMobileView('Role Code', element.roleCd),
                        itemMobileView('Role Name', element.roleName),
                        itemMobileView('Role Description', element.roleDesc),
                        itemMobileView(
                            'Super Admin',
                            element.superAdminFlag != null
                                ? element.superAdminFlag.toString()
                                : "false"),
                        itemMobileView('Created By', element.createdBy),
                        itemMobileView('Created Date',
                            localizeIsoDateStr(element.createdDt)),
                        itemMobileView('Changed By', element.changedBy),
                        itemMobileView('Changed Date',
                            localizeIsoDateStr(element.changedDt)),
                        Visibility(
                          visible: canView || canUpdate || canDelete,
                          child: rowButton(element),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList()
            : [const EmptyContainer()]);
  }
}
