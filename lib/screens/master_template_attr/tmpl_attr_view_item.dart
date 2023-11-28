import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/temp_attr.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/theme/colors.dart';

class TmplAttrChildren extends StatelessWidget {
  final List<TempAttDetail>? listDetail;

  const TmplAttrChildren({super.key, this.listDetail});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: !isMobile,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        child: SelectableText(
                          "SEQUENCE",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: context.scaleFont(11),
                            fontWeight: FontWeight.w600,
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
                        child: SelectableText(
                          "ATTRIBUTE CODE",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: context.scaleFont(12),
                            fontWeight: FontWeight.w600,
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
                        child: SelectableText(
                          "ATTRIBUTE NAME",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: context.scaleFont(12),
                            fontWeight: FontWeight.w600,
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
                        child: SelectableText(
                          "API KEY",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: context.scaleFont(12),
                            fontWeight: FontWeight.w600,
                            color: sccBlack,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        child: SelectableText(
                          "DATA TYPE",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: context.scaleFont(12),
                            fontWeight: FontWeight.w600,
                            color: sccBlack,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            child: SelectableText(
                              "MANDATORY FLAG",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: context.scaleFont(12),
                                fontWeight: FontWeight.w600,
                                color: sccBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
                mainAxisSize: MainAxisSize.min,
                children: listDetail != null && listDetail!.isNotEmpty
                    ? listDetail!.map((element) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          margin: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  // height: context.deviceHeight() * 0.08,
                                  padding: const EdgeInsets.all(8),
                                  child: SelectableText(
                                    (element.seq ?? "-").toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: context.scaleFont(12),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  // height: context.deviceHeight() * 0.08,
                                  padding: const EdgeInsets.all(8),
                                  child: SelectableText(
                                    (element.attributeCd ?? "-").toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: context.scaleFont(12),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  // height: context.deviceHeight() * 0.08,
                                  padding: const EdgeInsets.all(8),
                                  child: SelectableText(
                                    (element.attributeName ?? "-").toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: context.scaleFont(12),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  // height: context.deviceHeight() * 0.08,
                                  padding: const EdgeInsets.all(8),
                                  child: SelectableText(
                                    (element.attrApiKey ?? "-").toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: context.scaleFont(12),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  // height: context.deviceHeight() * 0.08,
                                  padding: const EdgeInsets.all(8),
                                  child: SelectableText(
                                    (element.dataType ?? "-").toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: context.scaleFont(12),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: (element.mandatoryFlag)
                                                      .toString() ==
                                                  Constant.statusTrue
                                              ? sccButtonGreen
                                              : (element.mandatoryFlag)
                                                          .toString() ==
                                                      Constant.statusFalse
                                                  ? sccRed
                                                  : sccInfoGrey,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(25)),
                                        ),
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              context.deviceWidth() * 0.045,
                                        ),
                                        child: SelectableText(
                                          (element.mandatoryFlag).toString() ==
                                                  Constant.statusTrue
                                              ? 'True'
                                              : (element.mandatoryFlag)
                                                          .toString() ==
                                                      Constant.statusFalse
                                                  ? 'False'
                                                  : (element.mandatoryFlag ??
                                                          "-")
                                                      .toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: context.scaleFont(12),
                                              color: sccWhite),
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
                    : [const EmptyContainer()]),
          ],
        ),
      ),
    );
  }
}
