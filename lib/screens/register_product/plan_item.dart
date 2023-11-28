import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/pricing.dart';
import 'package:scc_web/screens/register_product/contact_admin_dialog.dart';

import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';

import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class PricingItem extends StatefulWidget {
  final Pricing model;
  final double? price;
  final bool? isHovered;
  final Function() onExitHover;
  final Function(String) onHover;
  final String plan;
  final Function() adminContacted;

  const PricingItem({
    required this.price,
    required this.adminContacted,
    required this.model,
    Key? key,
    this.isHovered,
    required this.plan,
    required this.onExitHover,
    required this.onHover,
  }) : super(key: key);

  @override
  State<PricingItem> createState() => _PricingItemState();
}

class _PricingItemState extends State<PricingItem> {
  @override
  Widget build(BuildContext context) {
    String number = "";
    String format = "";
    if ((widget.price ?? 0) > 0) {
      String compact = NumberFormat.compact().format(widget.price);
      int? parsed = int.tryParse(compact.substring(compact.length - 1));
      if (parsed == null) {
        number = compact.substring(0, compact.length - 1);
        format = compact[compact.length - 1];
      } else {
        number = compact;
      }
    }

    return Visibility(
      // visible: ,
      child: MouseRegion(
        onExit: (val) {
          widget.onExitHover();
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 12, left: 12),
          child: MouseRegion(
            onHover: (event) {
              widget.onHover(widget.model.packageName!);
            },
            child: InkWell(
              onTap: () {
                if ((widget.model.isCurrentPlant != true)) {
                  showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (context) {
                      return ContactAdminDialog(
                        selectedRow: widget.plan,
                        packageCd: widget.model.packageCd ?? 0,
                        packageColor: widget.model.packageColor,
                        onError: (val) {
                          //showTopSnackBar(context, UpperSnackBar.error(message: val));
                        },
                        onSuccess: () {
                          widget.adminContacted();
                        },
                      );
                    },
                  );
                }
              },
              child: AnimatedContainer(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    widget.plan == widget.model.packageName
                        ? const BoxShadow(
                            color: Colors.grey,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          )
                        : const BoxShadow(offset: Offset.zero, color: sccWhite)
                  ],
                  color: widget.plan == widget.model.packageName
                      ? sccButtonBlue
                      : sccWhite,
                ),
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceInOut,
                child: SizedBox(
                  width: context.deviceWidth() * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: context.deviceWidth() * 0.18,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                widget.model.packageName ??
                                    '[UNIDENTIFIED PACKAGE]',
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: context.scaleFont(24),
                                  fontWeight: FontWeight.bold,
                                  color: widget.plan == widget.model.packageName
                                      ? sccWhite
                                      : sccBlack,
                                  fontFamily: 'toyota',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                widget.model.packageDesc ??
                                    '[UNIDENTIFIED DESC]',
                                maxLines: 4,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: context.scaleFont(12.5),
                                  color: widget.plan == widget.model.packageName
                                      ? sccWhite
                                      : sccBlack,
                                  fontFamily: 'toyota',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Visibility(
                                  visible: (widget.price ?? 0) != 0.0,
                                  child: Text(
                                    "IDR ",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'toyota',
                                      fontSize: context.scaleFont(20),
                                      color: widget.plan ==
                                              widget.model.packageName
                                          ? sccWhite
                                          : navText1,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.price != null
                                      ? (widget.price == 0.0 ? "Free" : number)
                                      : "UNIDENTIFIED PRICE",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'toyota',
                                    fontSize: context.scaleFont(
                                        (widget.price == null) ? 18 : 48),
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.clip,
                                    color:
                                        widget.plan == widget.model.packageName
                                            ? sccWhite
                                            : navText1,
                                  ),
                                ),
                                Visibility(
                                  visible: (widget.price ?? 0) != 0.0 ||
                                      format.isNotEmpty,
                                  child: Text(
                                    format,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'toyota',
                                      fontSize: context.scaleFont(20),
                                      color: widget.plan ==
                                              widget.model.packageName
                                          ? sccWhite
                                          : navText1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: context.deviceHeight() * 0.45,
                        child: Column(
                          children: [
                            if (widget.model.packageFeatures != null)
                              ...widget.model.packageFeatures!.map((e) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: sccDisabled),
                                        child: HeroIcon(
                                          HeroIcons.check,
                                          size: context.scaleFont(17),
                                          style: HeroIconStyle.solid,
                                          color: sccButtonBlue,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: SizedBox(
                                          height: 30,
                                          child: PackageContent(
                                            value: e.toString(),
                                            color: widget.plan ==
                                                    widget.model.packageName
                                                ? sccWhite
                                                : navText1,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                          ],
                        ),
                      ),
                      ButtonConfirm(
                        text: (widget.model.isCurrentPlant == true)
                            ? "Your Current Plant"
                            : "Contact Admin",
                        textColour: (widget.model.isCurrentPlant == true)
                            ? stringToColor(widget.model.packageColor)
                            : sccWhite,
                        colour: (widget.model.isCurrentPlant == true)
                            ? sccDisabled
                            : stringToColor(widget.model.packageColor),
                        onTap: () {
                          if ((widget.model.isCurrentPlant != true)) {
                            return showDialog(
                              context: context,
                              useRootNavigator: false,
                              builder: (context) {
                                return ContactAdminDialog(
                                  selectedRow: widget.plan,
                                  packageCd: widget.model.packageCd ?? 0,
                                  packageColor: widget.model.packageColor,
                                  onError: (val) {
                                    showTopSnackBar(context,
                                        UpperSnackBar.error(message: val));
                                  },
                                  onSuccess: () {
                                    widget.adminContacted();
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
