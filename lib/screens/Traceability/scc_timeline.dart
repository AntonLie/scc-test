// ignore_for_file: unrelated_type_equality_checks

import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/traceability/bloc/tracebility_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/traceability_model.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/theme/colors.dart';

class TimelineTp extends StatefulWidget {
  final TpList model;
  final Function(String?) onSelectionChange;
  final String? selected;
  final String? itemIdTp;
  final ListTraceability? trace;
  // final int index;
  // final bool isActive, isPassed, isParent;
  const TimelineTp({
    required this.model,
    // required this.isParent,
    // required this.isActive,
    // required this.isPassed,
    Key? key,
    required this.onSelectionChange,
    this.selected,
    this.itemIdTp,
    this.trace,
    // required this.index,
  }) : super(key: key);

  @override
  State<TimelineTp> createState() => _TimelineTpState();
}

class _TimelineTpState extends State<TimelineTp>
    with SingleTickerProviderStateMixin {
  bool expand = false;
  bool isHovered = false;
  // bool visible = false;
  late AnimationController _controller;
  TpList model = TpList();
  bool? isExpanded = false;
  late String? selected;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    expand = widget.model.lastPointFlag == true;
    selected = widget.selected;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bloc(TracebilityEvent event) {
    BlocProvider.of<TracebilityBloc>(context).add(event);
  }

  @override
  Widget build(BuildContext context) {
    Widget tpDetail(String keyStr, dynamic valueStr) {
      List<String> bcStatus = [];
      if (valueStr is List) {
        valueStr.forEach((element) {
          if (element is String) {
            bcStatus.add(element);
          }
        });
        // Blockchain Status
      }

      Widget blockchainPortal(String keyStr, List<String> bcStatus) {
        for (int i = 0; i < bcStatus.length;) {
          return Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.verified,
                    size: context.scaleFont(12),
                    color: (bcStatus.isNotEmpty)
                        ? const Color(0xff51BB25)
                        : const Color.fromARGB(255, 84, 111, 73),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    bcStatus[i],
                    style: TextStyle(
                      fontSize: context.scaleFont(12),
                      color: (keyStr == "Track Hash")
                          ? ((bcStatus.isNotEmpty)
                              ? const Color(0xff51BB25)
                              : const Color.fromARGB(255, 84, 111, 73))
                          : sccText3,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
            ],
          );
        }
        return const EmptyContainer();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: SelectableText(
                  keyStr,
                  style: TextStyle(
                    fontSize: context.scaleFont(14),
                    color: sccText1,
                    overflow: TextOverflow.fade,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: SelectableText(
                    (valueStr ?? "-").toString(),
                    style: TextStyle(
                      fontSize: context.scaleFont(14),
                      color: (keyStr == "Track Hash")
                          ? ((bcStatus.isNotEmpty)
                              ? const Color(0xff51BB25)
                              : const Color.fromARGB(255, 84, 111, 73))
                          : sccText3,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.fade,
                    ),
                    textAlign: TextAlign.left,
                  )),
            ),
          ],
        ),
      );
    }

    return BlocListener<TracebilityBloc, TracebilityState>(
      listener: (context, state) {
        if (state is TraceDetailListTp) {
          setState(() {
            model.tpAttribute = state.detail;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8, top: 8, bottom: 12),
        alignment: Alignment.centerLeft,
        // color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selected = widget.model.pointName;
                  widget.onSelectionChange(selected);
                  selected == widget.model.pointName ? expand = true : !expand;

                  if (expand) {
                    isExpanded =
                        true; // Mengatur ekspansi menjadi benar ketika widget ini diperluas
                    _controller.forward(from: 0.0);
                    if (widget.model.passed != null &&
                        widget.model.tpAttribute!.isEmpty) {
                      bloc(TraceDetailList(
                        widget.model.itemCd,
                        widget.model.itemId,
                        widget.model.pointCd,
                        widget.trace!.itemId,
                        widget.trace!.itemCd,
                      ));
                    }
                  } else {
                    isExpanded =
                        false; // Mengatur ekspansi menjadi salah ketika widget ini ditutup
                    _controller.reverse(from: 0.5);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Text(
                        (widget.model.pointName ?? "[UNIDENTIFIED WORKFLOW]"),
                        style: TextStyle(
                          height: 0.77,
                          color: ((widget.model.passed != null))
                              ? sccNavText2
                              : sccText3,
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Visibility(
                      visible: (widget.model.passed != null),
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                        child: HeroIcon(
                          HeroIcons.chevronDown,
                          color: (widget.model.passed != null)
                              ? sccButtonPurple
                              : sccText3,
                          size: context.scaleFont(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.selected == widget.model.pointName
                ? ExpandableWidget(
                    expand: expand,
                    child: expand
                        ?
                        // Column(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        BlocBuilder<TracebilityBloc, TracebilityState>(
                            builder: (context, state) {
                            if (state is TraceDetailListTp) {
                              return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: widget.model.lastPointFlag == true
                                      ? widget.model.tpAttribute!.map((e) {
                                          return tpDetail(
                                              e.attrName ?? "", e.attrValue ?? "");
                                        }).toList()
                                      : state.detail.isNotEmpty == true
                                          ? state.detail.map((e) {
                                              return tpDetail(e.attrName ?? "",
                                                  e.attrValue ?? "");
                                            }).toList()
                                          : [
                                              Visibility(
                                                visible: expand,
                                                child: const SelectableText(
                                                    "There is no data in this entry"),
                                              ),
                                            ]);
                            } else {
                              return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      widget.model.tpAttribute?.isNotEmpty ==
                                              true
                                          ? widget.model.tpAttribute!.map((e) {
                                              return tpDetail(e.attrName ?? "",
                                                  e.attrValue ?? "");
                                            }).toList()
                                          : [
                                              Visibility(
                                                visible: expand,
                                                child: const SelectableText(
                                                    "There is no data in this entry"),
                                              ),
                                            ]);
                            }
                          })
                        : const SizedBox(),
                  )
                : const Expanded(child: SizedBox())
            // _InnerTimeline(messages: processes[index].messages),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
