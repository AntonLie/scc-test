import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/subs_features.dart';
import 'package:scc_web/screens/register_product/contact_admin_dialog.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';

class FeatureItem extends StatefulWidget {
  final Function() adminContacted;
  final SubsFeatures model;
  final Function(String) onHover;
  final String selectedRow;
  const FeatureItem(
      {required this.selectedRow,
      required this.adminContacted,
      required this.model,
      required this.onHover,
      Key? key})
      : super(key: key);

  @override
  State<FeatureItem> createState() => _FeatureItemState();
}

class _FeatureItemState extends State<FeatureItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceWidth() * 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: ButtonCancel(
                      text: (widget.model.packageName
                                  ?.toLowerCase()
                                  .contains("free") ==
                              true)
                          ? "Free"
                          : "Contact Admin",
                      borderRadius: 8,
                      textsize: 16,
                      padding: 1,
                      color: stringToColor(widget.model.packageColor),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return ContactAdminDialog(
                              selectedRow: '',
                              packageCd: widget.model.packageCd ?? 0,
                              packageColor: widget.model.packageColor,
                              onError: (val) {
                                showTopSnackBar(
                                    context, UpperSnackBar.error(message: val));
                              },
                              onSuccess: () {
                                widget.adminContacted();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: (widget.model.body?.entries.isNotEmpty == true)
                ? widget.model.body!.entries.map((e) {
                    //! onHover & color condition
                    return MouseRegion(
                      onHover: (val) {
                        if (e.value != Constant.IS_PARENT) {
                          widget.onHover(e.key);
                        }
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.selectedRow == e.key
                              ? sccFillField
                              : Colors.transparent,
                          border: Border.all(style: BorderStyle.none),
                        ),
                        alignment: Alignment.center,
                        child: Builder(builder: (context) {
                          if (e.value == true) {
                            return HeroIcon(
                              HeroIcons.check,
                              color: stringToColor(widget.model.packageColor),
                              size: context.scaleFont(18),
                            );
                          } else if (e.value == null ||
                              e.value == Constant.IS_PARENT ||
                              e.value == false) {
                            return const SizedBox();
                          } else {
                            return PackageContent(
                              value: e.value.toString(),
                              color: sccNavText1,
                              fontSize: 16,
                            );
                          }
                        }),
                      ),
                    );
                  }).toList()
                : [],
          ),
        ],
      ),
    );
  }
}

class FeatureItemNew extends StatefulWidget {
  final Function() adminContacted;
  final SubsFeatures model;
  final Function(String) onHover;
  final String selectedRow;
  final Map<String, bool> mapExpansion;
  final Function() onExitHover;
  final Function(String) onExpansionChange;
  const FeatureItemNew({
    required this.selectedRow,
    required this.adminContacted,
    required this.model,
    required this.onHover,
    required this.onExitHover,
    required this.mapExpansion,
    required this.onExpansionChange,
    Key? key,
  }) : super(key: key);

  @override
  State<FeatureItemNew> createState() => _FeatureItemNewState();
}

class _FeatureItemNewState extends State<FeatureItemNew> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceWidth() * 0.15,
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
                    child: ButtonCancel(
                      text: (widget.model.packageName
                                  ?.toLowerCase()
                                  .contains("free") ==
                              true)
                          ? "Free"
                          : "Contact Admin",
                      borderRadius: 8,
                      textsize: 16,
                      padding: 1,
                      color: stringToColor(widget.model.packageColor),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return ContactAdminDialog(
                              selectedRow: '',
                              packageCd: widget.model.packageCd ?? 0,
                              packageColor: widget.model.packageColor,
                              onError: (val) {
                                showTopSnackBar(
                                    context, UpperSnackBar.error(message: val));
                              },
                              onSuccess: () {
                                widget.adminContacted();
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
          MouseRegion(
            onExit: (value) {
              widget.onExitHover();
            },
            child: Column(
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
                            child: MouseRegion(
                              onHover: (val) {
                                widget.onHover(i.key);
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: widget.selectedRow == i.key
                                      ? sccFillField
                                      : Colors.transparent,
                                  border: Border.all(style: BorderStyle.none),
                                ),
                                alignment: Alignment.center,
                                child: const SizedBox(),
                              ),
                            ),
                          ),
                          ExpandableWidget(
                            expand: widget.mapExpansion[i.key] == true,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: i.value.entries.isNotEmpty
                                  ? i.value.entries.map((j) {
                                      return MouseRegion(
                                        onHover: (val) {
                                          widget.onHover(j.key);
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: widget.selectedRow == j.key
                                                ? sccFillField
                                                : Colors.transparent,
                                            border: Border.all(
                                                style: BorderStyle.none),
                                          ),
                                          alignment: Alignment.center,
                                          child: Builder(builder: (context) {
                                            if (j.value == true) {
                                              return HeroIcon(
                                                HeroIcons.check,
                                                color: stringToColor(
                                                    widget.model.packageColor),
                                                size: context.scaleFont(18),
                                              );
                                            } else if (j.value == null ||
                                                j.value == false) {
                                              return const SizedBox();
                                            } else {
                                              return PackageContent(
                                                value: j.value.toString(),
                                                color: sccNavText1,
                                                fontSize: 16,
                                              );
                                            }
                                          }),
                                        ),
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
          ),
        ],
      ),
    );
  }
}
