import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/colors.dart';

class SimplePaging extends StatefulWidget {
  final String? selected;
  final Function(int)? onSelect;
  final Function() onClickNext,
      onClickLastPage,
      onClickPrevious,
      onClickFirstPage;
  final Function(int) onClick;
  final int pageToDisplay, pageNo;
  final bool? shadow, withPagingDropdown;
  final int? totalPages, totalDataInPage, pageSize, totalData;
  final double? borderRadius;
  const SimplePaging(
      {Key? key,
      required this.onClick,
      required this.onClickNext,
      required this.onClickLastPage,
      required this.onClickPrevious,
      required this.onClickFirstPage,
      required this.pageNo,
      required this.pageSize,
      required this.totalPages,
      required this.totalDataInPage,
      required this.pageToDisplay,
      required this.totalData,
      this.borderRadius,
      this.shadow = true,
      this.selected,
      this.withPagingDropdown,
      this.onSelect})
      : super(key: key);

  @override
  State<SimplePaging> createState() => _SimplePagingState();
}

class _SimplePagingState extends State<SimplePaging> {
  List<int> pagesDisplay = [];
  late int startPageDisplay;
  late int totalPages;
  late int startDataIndex;
  late int endDataIndex;

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
    startDataIndex = ((widget.pageNo - 1) * (widget.pageSize ?? 0)) + 1;
    endDataIndex =
        ((widget.pageNo * (widget.pageSize ?? 0)) > (widget.totalData ?? 0))
            ? (widget.totalData ?? 0)
            : (widget.pageNo * (widget.pageSize ?? 0));
    for (var i = 0; i < totalPages; i++) {
      pagesDisplay.add(startPageDisplay);
      startPageDisplay++;
    }
    return Container(
      width: context.deviceWidth(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        boxShadow: widget.shadow != true
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Visibility(
                visible: widget.withPagingDropdown != null
                    ? widget.withPagingDropdown!
                    : false,
                child: PagingDropdown(
                  onSelect:
                      widget.onSelect != null ? widget.onSelect! : (val) => {},
                  selected: widget.selected != null ? widget.selected! : '',
                ),
              ),
              Visibility(
                visible:
                    widget.totalDataInPage != null && widget.totalData != null,
                child: Text(
                  'Showing $startDataIndex-$endDataIndex of ${widget.totalData} data',
                  style: TextStyle(
                    fontSize: context.scaleFont(14),
                    color: const Color(0xff2C323F),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: (widget.totalPages ?? 0) > 1,
            replacement: const SizedBox(),
            child: Container(
              height: 35,
              margin: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          if (widget.pageNo > 1) widget.onClickFirstPage();
                        },
                        child: HeroIcon(
                          HeroIcons.chevronDoubleLeft,
                          color: widget.pageNo > 1 ? Colors.black : defaultGrey,
                          size: context.scaleFont(14),
                        ),
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          if (widget.pageNo > 1) widget.onClickPrevious();
                        },
                        child: HeroIcon(
                          HeroIcons.chevronLeft,
                          color: widget.pageNo > 1 ? Colors.black : defaultGrey,
                          size: context.scaleFont(14),
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
                            borderRadius: BorderRadius.circular(8),
                            color: widget.pageNo == e
                                ? pagingHighlight
                                : Colors.white,
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () {
                              widget.onClick(e);
                            },
                            child: Text(
                              e.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                color: widget.pageNo == e
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: context.scaleFont(14),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          if (widget.pageNo < (widget.totalPages ?? 1)) {
                            widget.onClickNext();
                          }
                        },
                        child: HeroIcon(
                          HeroIcons.chevronRight,
                          color: widget.pageNo < (widget.totalPages ?? 1)
                              ? Colors.black
                              : defaultGrey,
                          size: context.scaleFont(14),
                        ),
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          if (widget.pageNo < (widget.totalPages ?? 1)) {
                            widget.onClickLastPage();
                          }
                        },
                        child: HeroIcon(
                          HeroIcons.chevronDoubleRight,
                          color: widget.pageNo < (widget.totalPages ?? 1)
                              ? Colors.black
                              : defaultGrey,
                          size: context.scaleFont(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
