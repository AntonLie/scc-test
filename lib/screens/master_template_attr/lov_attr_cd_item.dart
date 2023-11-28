import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class LovAttributeCodeItem extends StatelessWidget {
  final String? attrCd;
  final String? attrName;
  final int? attrDataTypeLen;
  final int? attrDataTypePrec;
  final String? dataType;
  final String? attrDesc;
  final String? attrApiKey;
  final Function() onPick;
  const LovAttributeCodeItem(
      {super.key,
      this.attrCd,
      this.attrName,
      this.attrDataTypeLen,
      this.attrDataTypePrec,
      this.dataType,
      this.attrDesc,
      this.attrApiKey,
      required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: sccWhite,
        border: Border.all(color: sccUnselect),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: kIsWeb && !isWebMobile
          ? const EdgeInsets.all(20)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isMobile ? 3 : 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: SelectableText(
                          "Code",
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SelectableText(
                      ":",
                      style: TextStyle(
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      flex: isMobile ? 3 : 2,
                      child: SizedBox(
                        child: SelectableText(
                          " ${attrCd ?? '-'}",
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: SelectableText(
                          "Name",
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SelectableText(
                      ":",
                      style: TextStyle(
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      flex: isMobile ? 3 : 2,
                      child: SizedBox(
                        child: SelectableText(
                          " ${attrName ?? '-'}",
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: SelectableText(
                          "Description",
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SelectableText(
                      ":",
                      style: TextStyle(
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      flex: isMobile ? 3 : 2,
                      child: SizedBox(
                        child: SelectableText(
                          " ${attrDesc ?? '-'}",
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: SelectableText(
                          "Data Type",
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SelectableText(
                      ":",
                      style: TextStyle(
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      flex: isMobile ? 3 : 2,
                      child: SizedBox(
                        child: SelectableText(
                          " ${dataType ?? '-'}",
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: SelectableText(
                          "Data Type Length",
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SelectableText(
                      ":",
                      style: TextStyle(
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      flex: isMobile ? 3 : 2,
                      child: SizedBox(
                        child: SelectableText(
                          " ${attrDataTypeLen ?? '-'}",
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: SelectableText(
                          "Data Type Precision",
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SelectableText(
                      ":",
                      style: TextStyle(
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      flex: isMobile ? 3 : 2,
                      child: SizedBox(
                        child: SelectableText(
                          " ${attrDataTypePrec ?? '-'}",
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: SelectableText(
                          "Api Key",
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SelectableText(
                      ":",
                      style: TextStyle(
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      flex: isMobile ? 3 : 2,
                      child: SizedBox(
                        child: SizedBox(
                          child: SelectableText(
                            " ${attrApiKey ?? '-'}",
                            style: TextStyle(
                              fontSize: context.scaleFont(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isMobile
              ? Container()
              : Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: ButtonConfirm(
                      text: "Select",
                      borderRadius: 8,
                      fontWeight: FontWeight.normal,
                      onTap: () => onPick(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
