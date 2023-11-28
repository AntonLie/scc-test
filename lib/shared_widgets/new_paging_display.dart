import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/scc_icons.dart';
import 'package:scc_web/shared_widgets/ta_dropdown.dart';
import 'package:scc_web/theme/colors.dart';

class PagingDisplayNew extends StatefulWidget {
  final int pageToDisplay, pageNo;
  final int? totalPages, totalRows;
  final Function() onClickNext,
      onClickLastPage,
      onClickPrevious,
      onClickFirstPage;
  final Function(int) onClick, onChangeTotalData;
  const PagingDisplayNew(
      {super.key,
      required this.pageToDisplay,
      required this.pageNo,
      this.totalPages,
      this.totalRows,
      required this.onClickNext,
      required this.onClickLastPage,
      required this.onClickPrevious,
      required this.onClickFirstPage,
      required this.onClick,
      required this.onChangeTotalData});

  @override
  State<PagingDisplayNew> createState() => _PagingDisplayNewState();
}

class _PagingDisplayNewState extends State<PagingDisplayNew> {
  List<int> pagesDisplay = [];
  List<String> totalDataOpt = [];
  String? selectedTotalDataStr;
  late int startPageDisplay;
  late int totalPages;
  bool showOpt = false;
  Timer? timer;

  @override
  void initState() {
    totalDataOpt.add("5");
    totalDataOpt.add("10");
    totalDataOpt.add("20");
    totalDataOpt.add("50");
    totalDataOpt.add("100");
    selectedTotalDataStr = (widget.totalRows ?? totalDataOpt[0]).toString();
    super.initState();
  }

  onChangeHandler(String? val) {
    const duration = Duration(seconds: 2);
    if (timer != null) setState(() => timer!.cancel());
    setState(() => timer = Timer(duration,
        () => widget.onChangeTotalData(int.tryParse(val ?? "0") ?? 0)));
  }

  @override
  Widget build(BuildContext context) {
    startPageDisplay = (widget.totalPages ?? 1) > widget.pageToDisplay
        ? widget.pageNo >=
                (widget.totalPages ?? 1) -
                    ((widget.pageToDisplay / 2).floor() + 1)
            ? (widget.totalPages ?? 1) - (widget.pageToDisplay - 1)
            : widget.pageNo > ((widget.pageToDisplay / 2).floor() + 1)
                ? (widget.pageNo - (widget.pageToDisplay / 2).floor())
                : 1
        : 1;
    pagesDisplay.clear();
    totalPages = widget.pageToDisplay < widget.totalPages!
        ? widget.pageToDisplay
        : widget.totalPages!;
    for (var i = 0; i < totalPages; i++) {
      pagesDisplay.add(startPageDisplay);
      startPageDisplay++;
    }
    return Container(
      height: 35,
      // color: Colors.blue,
      //context.deviceHeight() * 0.05,
      margin: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
            visible: !isMobile ||
                (widget.totalRows != null && widget.totalRows! < 5),
            child: Container(
              // height: 30,
              // padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                // border: Border.all(color: sccInfoGrey, width: 0.5),
                borderRadius: BorderRadius.circular(12),
                color: sccWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.9),
                    spreadRadius: 0.1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Total Rows : ",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: context.scaleFont(16),
                      color: sccText1,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: TAPagingDropdown(
                      selectedTotalDataStr,
                      totalDataOpt,
                      fontSize: context.scaleFont(16),
                      onChange: (value) {
                        selectedTotalDataStr = value;
                        onChangeHandler(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.totalPages != null && widget.totalPages! > 1,
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Visibility(
                  //   visible: widget.pageNo > 1,
                  //   child:
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        color: sccWhite,
                        boxShadow: [
                          BoxShadow(
                            // 0.5 -> 0.7
                            color: Colors.grey.withOpacity(0.9),
                            spreadRadius: 0.1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      // 4 ->
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          if (widget.pageNo > 1) widget.onClickFirstPage();
                        },
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(
                            SccIcon.lastpage,
                            color: widget.pageNo > 1 ? sccBlack : sccInfoGrey,
                            size: context.scaleFont(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ),
                  // Visibility(
                  //   visible: widget.pageNo > 1,
                  //   child:
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        color: sccWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.9),
                            spreadRadius: 0.1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          if (widget.pageNo > 1) widget.onClickPrevious();
                        },
                        child: FittedBox(
                            child: HeroIcon(
                          HeroIcons.chevronLeft,
                          color: widget.pageNo > 1 ? sccBlack : sccInfoGrey,
                        )
                            //  Icon(
                            //   Icons.chevron_left,
                            //   color: widget.pageNo > 1 ? sccBlack : sccInfoGrey,
                            // ),
                            ),
                      ),
                    ),
                  ),
                  // ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: pagesDisplay.map((e) {
                      return AspectRatio(
                        aspectRatio: 1.2,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 0.1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            color:
                                widget.pageNo == e ? sccNavText2 : sccWhite,
                            // gradient: LinearGradient(
                            //   begin: Alignment.topCenter,
                            //   end: Alignment.bottomCenter,
                            //   colors: widget.pageNo == e
                            //       ? [
                            //           sccButtonLightBlue,
                            //           sccButtonBlue,
                            //         ]
                            //       : [
                            //           sccWhite,
                            //           sccWhite,
                            //         ],
                            // ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () {
                              widget.onClick(e);
                            },
                            child: Center(
                              child: Text(
                                e.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: widget.pageNo == e
                                        ? sccWhite
                                        : sccBlack,
                                    fontSize: context.scaleFont(16)),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // Visibility(
                  //   visible: widget.pageNo < (widget.totalPages ?? 1),
                  //   child:
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.9),
                            spreadRadius: 0.1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        color: sccWhite,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          if (widget.pageNo < (widget.totalPages ?? 1)) {
                            widget.onClickNext();
                          }
                        },
                        child: FittedBox(
                            child: HeroIcon(
                          HeroIcons.chevronRight,
                          color: widget.pageNo < (widget.totalPages ?? 1)
                              ? sccBlack
                              : sccInfoGrey,
                        )
                            // Icon(
                            //   Icons.chevron_right,
                            //   color: widget.pageNo < (widget.totalPages ?? 1) ? sccBlack : sccInfoGrey,
                            // ),
                            ),
                      ),
                    ),
                  ),
                  // ),
                  // Visibility(
                  //   visible: widget.pageNo < (widget.totalPages ?? 1),
                  //   child:
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        color: sccWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.9),
                            spreadRadius: 0.1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          if (widget.pageNo < (widget.totalPages ?? 1)) {
                            widget.onClickLastPage();
                          }
                        },
                        child: Icon(
                          SccIcon.lastpage,
                          color: widget.pageNo < (widget.totalPages ?? 1)
                              ? sccBlack
                              : sccInfoGrey,
                          size: context.scaleFont(14),
                        ),
                      ),
                    ),
                  ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
