import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/traceability_model.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/theme/colors.dart';

class TraceabilityCard extends StatefulWidget {
  final List<ListTraceability> listTrace;
  final bool? trace;
  final Color? colorBg;
  final Function(ListTraceability)? traceTouch;
  const TraceabilityCard(
      {super.key,
      this.trace,
      this.traceTouch,
      required this.listTrace,
      this.colorBg});

  @override
  State<TraceabilityCard> createState() => _TraceabilityCardState();
}

class _TraceabilityCardState extends State<TraceabilityCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.listTrace.isNotEmpty
          ? widget.listTrace.map((element) {
              element.attrTop ??= [];
              element.attrBottom ??= [];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20.0), // Ubah angka sesuai keinginan
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        height: context.deviceHeight() * 0.35,
                        width: context.deviceWidth(),
                        decoration: BoxDecoration(
                            color: widget.colorBg ?? sccWhite,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: element.itemName != null,
                                  child: Row(
                                    children: [
                                      Image.asset(Constant.iconTrace),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      TableContent(
                                          value: element.itemName ?? "Unknown",
                                          fontSize: context.scaleFont(18),
                                          fontWeight: FontWeight.w600)
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                        visible: element.blockChain ?? false,
                                        child: Tooltip(
                                          message: "Blockchain",
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            child: SvgPicture.asset(
                                                Constant.scc_blockchain),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Visibility(
                                      visible: element.status != null,
                                      child: Row(
                                        children: [
                                          Icon(
                                              (element.status ==
                                                      Constant.STATUS_DELIVERED)
                                                  ? Icons.check
                                                  : (element.status ==
                                                          Constant
                                                              .STATUS_PENDING)
                                                      ? Icons
                                                          .watch_later_outlined
                                                      : (element.status ==
                                                              Constant
                                                                  .STATUS_IN_PROCESS)
                                                          ? Icons.timelapse
                                                          : null,
                                              color: sccBlue),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(element.status ?? "")
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Divider(
                              color: sccLightGrayDivider,
                              height: 25,
                              thickness: 2,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        element.attrBottom!.length <= 2
                                            ? MainAxisAlignment.spaceBetween
                                            : element.attrTop!.length <= 2
                                                ? MainAxisAlignment.spaceEvenly
                                                : MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        element.attrBottom!.length <= 2
                                            ? CrossAxisAlignment.end
                                            : element.attrTop!.length <= 2
                                                ? CrossAxisAlignment.center
                                                : CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              element.attrTop!.length <= 2
                                                  ? MainAxisAlignment
                                                      .spaceBetween
                                                  : MainAxisAlignment.start,
                                          children: element.attrTop!.isNotEmpty
                                              ? element.attrTop!
                                                  .map(
                                                    (e) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: ContainerCard(
                                                        text1: e.title,
                                                        title1: e.value,
                                                        icon1: e.icon,
                                                      ),
                                                    ),
                                                  )
                                                  .toList()
                                              : [const SizedBox()]),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              element.attrBottom!.length <= 2
                                                  ? MainAxisAlignment
                                                      .spaceBetween
                                                  : MainAxisAlignment.start,
                                          children: element
                                                  .attrBottom!.isNotEmpty
                                              ? element.attrBottom!
                                                  .map(
                                                    (e) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: ContainerCard(
                                                        bottom: true,
                                                        text1: e.title,
                                                        title1: e.value,
                                                        icon1: e.icon,
                                                      ),
                                                    ),
                                                  )
                                                  .toList()
                                              : [const SizedBox()])
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Visibility(
                                        visible: widget.trace ?? false,
                                        child: InkWell(
                                          onTap: () {
                                            widget.traceTouch!(element);
                                          },
                                          child: Container(
                                            width: context.deviceWidth() * 0.09,
                                            decoration: BoxDecoration(
                                                color: sccNavText2,
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                HeroIcon(
                                                  HeroIcons
                                                      .magnifyingGlassCircle,
                                                  color: sccWhite,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  'Trace',
                                                  style: TextStyle(
                                                      color: sccWhite),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList()
          : [const EmptyData()],
    );
  }
}

class ContainerCard extends StatelessWidget {
  final String? icon1;
  final String? text1, title1;
  final bool? bottom;

  const ContainerCard({
    super.key,
    this.icon1,
    this.text1,
    this.title1,
    this.bottom = false,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List fileBytes;

    fileBytes = base64Decode(icon1!);
    return Container(
      width: context.deviceWidth() * 0.18,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bottom == true ? sccNavText2.withOpacity(0.3) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              (icon1 != null && icon1!.isNotEmpty)
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.memory(fileBytes),
                    )
                  : const HeroIcon(
                      HeroIcons.cube,
                      color: sccNavText2,
                      size: 18,
                    ),
              const SizedBox(
                width: 5,
              ),
              TableContent(
                  value: text1 ?? 'unknown',
                  fontSize: context.scaleFont(12),
                  fontWeight: FontWeight.w600,
                  color: sccNavText2)
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          TableContent(
              value: title1 ?? 'unknown',
              fontSize: context.scaleFont(14),
              fontWeight: FontWeight.w600,
              color: sccBlack)
        ],
      ),
    );
  }
}
