import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';

import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/subs_features.dart';
import 'package:scc_web/screens/register_product/contact_admin_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/success_dialog.dart';

import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class FeatureItemNew extends StatefulWidget {
  final Function() adminContacted;
  final SubsFeatures model;
  // final Function(String) onHover;
  final String selectedRow;
  final Map<String, bool> mapExpansion;
  // final Function() onExitHover;
  final Function(String) onExpansionChange;
  const FeatureItemNew({
    required this.selectedRow,
    required this.adminContacted,
    required this.model,
    // required this.onHover,
    // required this.onExitHover,
    required this.mapExpansion,
    required this.onExpansionChange,
    Key? key,
  }) : super(key: key);

  @override
  State<FeatureItemNew> createState() => _FeatureItemNewState();
}

class _FeatureItemNewState extends State<FeatureItemNew> {
  adminContacted() {
    showDialog(
      context: context,
      builder: (ctx) {
        return SuccessDialog(
          title: "Success !",
          msg: "Admin successfully contacted",
          buttonText: "OK",
          onTap: () => context.closeDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.deviceWidth() * 0.12,
      decoration: BoxDecoration(
        border: Border.all(width: 0.1, color: sccButtonBlue),
        borderRadius:
            (widget.model.packageName?.toLowerCase().contains("enterprise") ==
                    true)
                ? const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8))
                : const BorderRadius.all(Radius.circular(0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.model.packageName ?? "[UNIDENTIFIED]",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold,
                          color: sccBlack,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ButtonConfirm(
                      text: (widget.model.packageName
                                  ?.toLowerCase()
                                  .contains("free") ==
                              true)
                          ? "Free"
                          : "Contact Admin",
                      textColour: sccWhite,
                      colour: stringToColor(widget.model.packageColor),
                      onTap: () {
                        return showDialog(
                          context: context,
                          useRootNavigator: false,
                          builder: (context) {
                            return ContactAdminDialog(
                              selectedRow: widget.selectedRow,
                              packageCd: widget.model.packageCd ?? 0,
                              packageColor: widget.model.packageColor,
                              onError: (val) {
                                showTopSnackBar(
                                    context, UpperSnackBar.error(message: val));
                              },
                              onSuccess: () {
                                adminContacted();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: (widget.model.rawBody?.entries.isNotEmpty == true)
                ? widget.model.rawBody!.entries.map((i) {
                    //! onHover & color condition
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => widget.onExpansionChange(i.key),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: widget.selectedRow == i.key
                                  ? sccFillField
                                  : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: const SizedBox(),
                          ),
                        ),
                        ExpandableWidget(
                          expand: widget.mapExpansion[i.key] == true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: i.value.entries.isNotEmpty
                                ? i.value.entries.map((j) {
                                    return Container(
                                      height: 40,
                                      padding: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          color: widget.selectedRow == j.key
                                              ? sccFillField
                                              : Colors.transparent,
                                          border: const Border(
                                              left: BorderSide(
                                                  width: 0.1,
                                                  color: sccButtonBlue))),
                                      alignment: Alignment.center,
                                      child: Builder(builder: (context) {
                                        if (j.value == true) {
                                          return Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: sccDisabled),
                                            child: HeroIcon(
                                              HeroIcons.check,
                                              color: stringToColor(
                                                  widget.model.packageColor),
                                              size: context.scaleFont(18),
                                            ),
                                          );
                                        } else if (j.value == null ||
                                            j.value == false) {
                                          return Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: sccDisabled),
                                            child: HeroIcon(
                                              HeroIcons.xMark,
                                              color: stringToColor(
                                                  widget.model.packageColor),
                                              size: context.scaleFont(18),
                                            ),
                                          );
                                        } else {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: PackageContent(
                                              value: j.value.toString(),
                                              color: sccNavText1,
                                              fontSize: 16,
                                            ),
                                          );
                                        }
                                      }),
                                    );
                                  }).toList()
                                : [],
                          ),
                        ),
                      ],
                    );
                  }).toList()
                : [],
          ),
        ],
      ),
    );
  }
}
