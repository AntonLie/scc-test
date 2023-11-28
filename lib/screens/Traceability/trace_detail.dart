import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/traceability_model.dart';
import 'package:scc_web/screens/Traceability/scc_timeline.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:timelines/timelines.dart';

class TraceDetail extends StatefulWidget {
  final DetailId traceDetail;
  final String itemId;
  final ListTraceability trace;
  const TraceDetail(
      {super.key,
      required this.traceDetail,
      required this.itemId,
      required this.trace});

  @override
  State<TraceDetail> createState() => _TraceDetailState();
}

class _TraceDetailState extends State<TraceDetail> {
  late String? selected = "";
  @override
  void initState() {
    widget.traceDetail.tpList!.forEach((element) {
      if (element.lastPointFlag == true) {
        selected = element.pointName;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.traceDetail.useCaseName ?? "unknown",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: context.scaleFont(18),
              color: sccBlack),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          color: sccLightGrayDivider,
          height: 25,
          thickness: 2,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "UseCase Name",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: context.scaleFont(12),
              color: sccBlack),
        ),
        Text(
          widget.traceDetail.useCaseName ?? "Unknown",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: context.scaleFont(14),
              color: sccBlack),
        ),
        const SizedBox(
          height: 10,
        ),
        DefaultTextStyle(
          style: TextStyle(
            color: Color(0xff9b9b9b),
            fontSize: 12.5,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FixedTimeline.tileBuilder(
              theme: TimelineThemeData(
                nodePosition: 0,
                color: Color(0xff989898),
                indicatorTheme: IndicatorThemeData(
                  position: 0,
                  size: 20.0,
                ),
                connectorTheme: ConnectorThemeData(
                  thickness: 2.5,
                ),
              ),
              builder: TimelineTileBuilder.connected(
                connectionDirection: ConnectionDirection.after,
                itemCount: widget.traceDetail.tpList!.length,
                contentsBuilder: (_, index) {
                  return TimelineTp(
                    onSelectionChange: (val) {
                      setState(() {
                        selected = val;
                      });
                    },
                    itemIdTp: widget.itemId,
                    selected: selected,
                    trace: widget.trace,
                    model: widget.traceDetail.tpList![index],
                  );
                },
                indicatorBuilder: (_, index) {
                  // if (processes[index].isCompleted) {

                  return parentIndicator(
                    isActive: widget.traceDetail.tpList![index].passed != null,
                    icon: widget.traceDetail.tpList![index].iconBase64,
                  );
                },
                connectorBuilder: (_, index, ___) => DashedLineConnector(
                  color: (widget.traceDetail.tpList![index].passed != null)
                      ? sccButtonPurple
                      : (widget.traceDetail.tpList![index].lastPointFlag ==
                              true)
                          ? sccButtonPurple
                          : sccButtonGrey,
                  dash: 3,
                  gap: 2,
                  thickness: 1.5,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  DotIndicator parentIndicator({required bool isActive, String? icon}) {
    Uint8List fileBytes;

    fileBytes = base64Decode(icon ?? Constant.profileBase64Img);
    return DotIndicator(
      size: context.scaleFont(30),
      border: Border.all(color: sccBlue, width: 0.2, style: BorderStyle.solid),
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? sccWhite : sccLightGray,
          ),
          child: SizedBox(
            height: 20,
            width: 20,
            child: Image.memory(fileBytes),
          )),
    );
  }

  // DotIndicator childIndicator(
  //     {required bool isActive, required bool isPassed}) {
  //   return DotIndicator(
  //     size: context.scaleFont(30),
  //     child: Container(
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: (isPassed ? sccLightPurple : sccLightGray).withOpacity(0.2),
  //       ),
  //       child: Container(
  //         height: context.scaleFont(16),
  //         width: context.scaleFont(16),
  //         alignment: Alignment.center,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: isActive
  //               ? sccButtonPurple
  //               : isPassed
  //                   ? sccLightGray
  //                   : sccLightGray,
  //         ),
  //         child: const HeroIcon(
  //           HeroIcons.check,
  //           color: sccWhite,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({required this.tpDetail});

  final List<TpAttribute>? tpDetail;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == tpDetail!.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 1.0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
              !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text(tpDetail![index - 1].attrName ?? ""),
                  SizedBox(
                    width: 10,
                    child: Text(":"),
                  ),
                  Text(tpDetail![index - 1].attrCd ?? ""),
                ],
              ),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: tpDetail!.length + 2,
        ),
      ),
    );
  }
}
