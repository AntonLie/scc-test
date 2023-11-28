import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/system/bloc/system_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';

class PagingRows extends StatefulWidget {
  final Function() onClickNext,
      onClickLastPage,
      onClickPrevious,
      onClickFirstPage;
  final String? selected;
  final Function() onClick, onSelect;
  final int pageToDisplay, pageNo;
  final int? totalPages, totalDataInPage, pageSize, totalData;
  final double? borderRadius;
  const PagingRows(
      {super.key,
      required this.onClickNext,
      required this.onClickLastPage,
      required this.onClickPrevious,
      required this.onClickFirstPage,
      required this.selected,
      required this.onClick,
      required this.onSelect,
      required this.pageToDisplay,
      required this.pageNo,
      required this.totalPages,
      required this.totalDataInPage,
      required this.pageSize,
      required this.totalData,
      this.borderRadius});

  @override
  State<PagingRows> createState() => _PagingRowsState();
}

class _PagingRowsState extends State<PagingRows> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => SystemBloc()..add(GetOption('PAGING'))),
        ],
        child: PagingRowsBody(
          selected: widget.selected,
          onClick: widget.onClick(),
          onSelect:  widget.onSelect(),
          onClickNext: widget.onClickNext,
          onClickLastPage: widget.onClickLastPage,
          onClickPrevious: widget.onClickPrevious,
          onClickFirstPage: widget.onClickFirstPage,
          pageNo: widget.pageNo,
          pageSize: widget.pageSize,
          pageToDisplay: widget.pageToDisplay,
          totalData: widget.totalData,
          totalPages: widget.totalPages,
          totalDataInPage: widget.totalDataInPage,
        ));
  }
}

class PagingRowsBody extends StatefulWidget {
  final Function() onClickNext,
      onClickLastPage,
      onClickPrevious,
      onClickFirstPage;
  final String? selected;
  final Function(int) onClick, onSelect;
  final int pageToDisplay, pageNo;
  final int? totalPages, totalDataInPage, pageSize, totalData;
  final double? borderRadius;
  const PagingRowsBody(
      {super.key,
      required this.onClickNext,
      required this.onClickLastPage,
      required this.onClickPrevious,
      required this.onClickFirstPage,
      required this.selected,
      required this.onClick,
      required this.onSelect,
      required this.pageToDisplay,
      required this.pageNo,
      required this.totalPages,
      required this.totalDataInPage,
      required this.pageSize,
      required this.totalData,
      this.borderRadius});

  @override
  State<PagingRowsBody> createState() => _PagingRowsBodyState();
}

class _PagingRowsBodyState extends State<PagingRowsBody> {
  String? selected;
  List<KeyVal> opt = [];
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
    return MultiBlocListener(
      listeners: [
        BlocListener<SystemBloc, SystemState>(
          listener: (context, state) {
            if (state is SystemError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.error));
            }
            if (state is OptionLoaded) {
              opt.clear();
              for (var element in state.listData) {
                if (element.systemValue != null) {
                  opt.add(KeyVal(element.systemValue!, element.systemValue!));
                }
              }
              if (opt.isNotEmpty && (selected == null || selected == "0")) {
                selected = opt.first.value;
                widget.onSelect(int.tryParse(selected.number) ?? 0);
              }
            }
            if (state is OnLogoutSystem) {
              context.push(const LoginRoute());
            }
          },
        ),
      ],
      child: Container(
        width: context.deviceWidth(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible:
                  widget.totalDataInPage != null && widget.totalData != null,
              child: Row(
                children: [
                  Text(
                    'Showing $startDataIndex - ',
                    style: TextStyle(
                      fontSize: context.scaleFont(14),
                      color: const Color(0xff2C323F),
                    ),
                  ),
                  SizedBox(
                    width: context.deviceWidth() * 0.05,
                    child: BlocBuilder<SystemBloc, SystemState>(
                      builder: (context, state) {
                        return CommonShimmer(
                          isLoading: state is SystemLoading,
                          child: PortalFormDropdown(
                            selected,
                            opt,
                            portalWidth: context.deviceWidth() * 0.1,
                            isPopToTop: true,
                            borderRadius: 8,
                            borderColour: Colors.transparent,
                            fillColour: sccWhite,
                            hintText: 'Paging',
                            enabled: opt.length > 1,
                            onChange: (val) {
                              setState(() {
                                selected = val;
                              });
                              widget
                                  .onSelect(int.tryParse(selected.number) ?? 0);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    ' of ${widget.totalData} data',
                    style: TextStyle(
                      fontSize: context.scaleFont(14),
                      color: const Color(0xff2C323F),
                    ),
                  ),
                ],
              ),
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
                            color:
                                widget.pageNo > 1 ? Colors.black : defaultGrey,
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
                            color:
                                widget.pageNo > 1 ? Colors.black : defaultGrey,
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
      ),
    );
  }
}
