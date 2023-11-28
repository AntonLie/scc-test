import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scc_web/bloc/traceability/bloc/tracebility_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/traceability_model.dart';
import 'package:scc_web/screens/Traceability/table_consume.dart';
import 'package:scc_web/screens/Traceability/table_traceability.dart';
import 'package:scc_web/screens/Traceability/trace_detail.dart';
import 'package:scc_web/screens/Traceability/traceability_card.dart';
import 'package:scc_web/screens/Traceability/traceability_consume.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';

import '../../shared_widgets/common_shimmer.dart';

class TraceabilityTrace extends StatefulWidget {
  final ListTraceability trace;
  final List<ListId>? listTrace;
  final String? supplierCd;
  final String? consume;

  final Function(String) onChanged;

  const TraceabilityTrace(
      {super.key,
      required this.trace,
      this.listTrace,
      this.supplierCd,
      this.consume,
      required this.onChanged});

  @override
  State<TraceabilityTrace> createState() => _TraceabilityTraceState();
}

class _TraceabilityTraceState extends State<TraceabilityTrace> {
  late TextEditingController searchCo;
  bool hover = false;
  String selectedTrace = '';
  String? itemId;
  List<ListId> listTrace = [];
  List<ListTraceability> listConsume = [];
  Paging paging = Paging(pageNo: 1, pageSize: 10);
  String? consume;
  String? formMode = "";
  String? searchVal;
  String? itemIdTp;

  @override
  void initState() {
    searchCo = TextEditingController();
    if (widget.listTrace != null && widget.listTrace!.isNotEmpty) {
      listTrace = widget.listTrace!;
    }
    consume = widget.consume;
    widget.trace.attrTop ??= [];
    widget.trace.attrBottom ??= [];
    super.initState();
  }

  bloc(TracebilityEvent event) {
    BlocProvider.of<TracebilityBloc>(context).add(event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TracebilityBloc, TracebilityState>(
      listener: (context, state) {
        if (state is DataTracebilityForm) {
          setState(() {
            listTrace = state.listItemId;
            paging = state.paging!;
          });
        }
        if (state is TracebilityConsumeForm) {
          setState(() {
            listConsume = state.listTrace;
            paging = state.paging!;
          });
        }
      },
      child: Column(
        children: [
          Visibility(
            visible: formMode == "Traceability Consume Item",
            child: BlocBuilder<TracebilityBloc, TracebilityState>(
              builder: (context, state) {
                if (state is TracebilityDetailConsume) {
                  state.trace.attrBottom ??= [];
                  state.trace.attrTop ??= [];
                  return Container(
                    decoration: BoxDecoration(
                      color: isMobile ? sccBackground : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: isMobile
                        ? EdgeInsets.zero
                        : const EdgeInsets.symmetric(
                            vertical: 16,
                            // horizontal: 24,
                          ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(Constant.iconTrace),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                state.trace.itemName ?? "Unknown",
                                style: TextStyle(
                                    fontSize: context.scaleFont(20),
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          const Divider(
                            color: sccLightGrayDivider,
                            height: 25,
                            thickness: 2,
                          ),
                          Row(
                              mainAxisAlignment:
                                  state.trace.attrTop!.length <= 2
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.start,
                              children: state.trace.attrTop!
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ContainerCard(
                                        text1: e.title,
                                        title1: e.value,
                                        icon1: e.icon,
                                      ),
                                    ),
                                  )
                                  .toList()),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment:
                                  state.trace.attrBottom!.length <= 2
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.start,
                              children: state.trace.attrBottom!
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ContainerCard(
                                        bottom: true,
                                        text1: e.title,
                                        title1: e.value,
                                        icon1: e.icon,
                                      ),
                                    ),
                                  )
                                  .toList()),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
          Visibility(
            visible: formMode != "Traceability Consume Item",
            child: Container(
              decoration: BoxDecoration(
                color: isMobile ? sccBackground : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: isMobile
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(
                      vertical: 16,
                      // horizontal: 24,
                    ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(Constant.iconTrace),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.trace.itemName ?? "Unknown",
                          style: TextStyle(
                              fontSize: context.scaleFont(20),
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    const Divider(
                      color: sccLightGrayDivider,
                      height: 25,
                      thickness: 2,
                    ),
                    Row(
                        mainAxisAlignment: widget.trace.attrTop!.length <= 2
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,
                        children: widget.trace.attrTop!
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(10),
                                child: ContainerCard(
                                  text1: e.title,
                                  title1: e.value,
                                  icon1: e.icon,
                                ),
                              ),
                            )
                            .toList()),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisAlignment: widget.trace.attrBottom!.length <= 2
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,
                        children: widget.trace.attrBottom!
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(10),
                                child: ContainerCard(
                                  bottom: true,
                                  text1: e.title,
                                  title1: e.value,
                                  icon1: e.icon,
                                ),
                              ),
                            )
                            .toList()),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
              visible: consume == "CONSUME",
              child: Container(
                decoration: BoxDecoration(
                  color: sccWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: isMobile
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(
                        vertical: 10,
                        // horizontal: 24,
                      ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TableConsume(
                      listConsume: listConsume,
                      onClick: (val) {
                        bloc(LoadTraceabilityDetailConsume(
                            val.itemCd, val.itemId));
                        setState(() {
                          consume = "ITEM";
                          formMode = "Traceability Consume Item";
                          widget.onChanged(formMode!);
                        });
                      },
                      onTap: (val) {},
                      onSearch: () {
                        bloc(LoadTraceabilityConsumeForm(
                            widget.trace, paging, "", searchVal));
                      },
                      onChanged: (val) {
                        setState(() {
                          searchVal = val.trim();
                        });
                      },
                      onpress: () {
                        setState(() {
                          searchVal = "";
                        });
                        bloc(LoadTraceabilityConsumeForm(
                            widget.trace, paging, "", searchVal));
                      },
                    ),
                    BlocBuilder<TracebilityBloc, TracebilityState>(
                        builder: (context, state) {
                      return Visibility(
                        visible: !(isMobile) &&
                            (paging.totalPages != null) &&
                            (paging.totalData != null) &&
                            listConsume.isNotEmpty,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SimplePaging(
                              shadow: false,
                              pageNo: paging.pageNo!,
                              pageToDisplay: isMobile ? 3 : 4,
                              totalPages: paging.totalPages,
                              pageSize: paging.pageSize,
                              totalDataInPage: paging.totalDataInPage,
                              totalData: paging.totalData,
                              onClickFirstPage: () {
                                paging.pageNo = 1;
                                bloc(LoadTraceabilityConsumeForm(
                                    widget.trace, paging, "", ""));
                              },
                              onClickPrevious: () {
                                paging.pageNo = paging.pageNo! - 1;
                                bloc(LoadTraceabilityConsumeForm(
                                    widget.trace, paging, "", ""));
                              },
                              onClick: (value) {
                                paging.pageNo = value;
                                bloc(LoadTraceabilityConsumeForm(
                                    widget.trace, paging, "", ""));
                              },
                              onClickNext: () {
                                paging.pageNo = paging.pageNo! + 1;
                                bloc(LoadTraceabilityConsumeForm(
                                    widget.trace, paging, "", ""));
                              },
                              onClickLastPage: () {
                                paging.pageNo = paging.totalPages;
                                bloc(LoadTraceabilityConsumeForm(
                                    widget.trace, paging, "", ""));
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              )),
          Visibility(
            visible: consume != "CONSUME",
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: listTrace.isNotEmpty,
                  child: Column(
                    children: [
                      Container(
                        width: context.deviceWidth() * 0.4,
                        decoration: BoxDecoration(
                          color: isMobile ? sccBackground : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: isMobile
                            ? EdgeInsets.zero
                            : const EdgeInsets.symmetric(
                                vertical: 16,
                                // horizontal: 24,
                              ),
                        child: Column(
                          children: [
                            TableTraceability(
                              onChanged: (val) {
                                setState(() {
                                  itemId = val;
                                });
                              },
                              onSearch: () {
                                bloc(DataTraceabilityForm(
                                    paging,
                                    itemId,
                                    widget.supplierCd ?? "",
                                    widget.trace.itemCd));
                              },
                              listTrace: listTrace,
                              onpress: () {
                                paging.pageNo = 1;
                                bloc(DataTraceabilityForm(
                                  paging,
                                  "",
                                  widget.supplierCd ?? "",
                                  widget.trace.itemCd,
                                ));
                              },
                              onHover: (val) {},
                              onTap: (val) {
                                setState(() {
                                  selectedTrace = val;
                                });
                                bloc(LoadTraceabilityDetail(
                                    widget.trace.itemCd, selectedTrace));
                              },
                              selectedTrace: selectedTrace,
                            ),
                            BlocBuilder<TracebilityBloc, TracebilityState>(
                                builder: (context, state) {
                              return Visibility(
                                visible: !(isMobile) &&
                                    (paging.totalPages != null) &&
                                    (paging.totalData != null) &&
                                    listTrace.isNotEmpty,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SimplePaging(
                                      shadow: false,
                                      pageNo: paging.pageNo!,
                                      pageToDisplay: isMobile ? 3 : 2,
                                      totalPages: paging.totalPages,
                                      pageSize: paging.pageSize,
                                      totalDataInPage: paging.totalDataInPage,
                                      totalData: paging.totalData,
                                      onClickFirstPage: () {
                                        paging.pageNo = 1;
                                        bloc(DataTraceabilityForm(
                                          paging,
                                          "",
                                          widget.supplierCd ?? "",
                                          widget.trace.itemCd,
                                        ));
                                      },
                                      onClickPrevious: () {
                                        paging.pageNo = paging.pageNo! - 1;
                                        bloc(DataTraceabilityForm(
                                          paging,
                                          "",
                                          widget.supplierCd ?? "",
                                          widget.trace.itemCd,
                                        ));
                                      },
                                      onClick: (value) {
                                        paging.pageNo = value;
                                        bloc(DataTraceabilityForm(
                                          paging,
                                          "",
                                          widget.supplierCd ?? "",
                                          widget.trace.itemCd,
                                        ));
                                      },
                                      onClickNext: () {
                                        paging.pageNo = paging.pageNo! + 1;
                                        bloc(DataTraceabilityForm(
                                          paging,
                                          "",
                                          widget.supplierCd ?? "",
                                          widget.trace.itemCd,
                                        ));
                                      },
                                      onClickLastPage: () {
                                        paging.pageNo = paging.totalPages;
                                        bloc(DataTraceabilityForm(
                                          paging,
                                          "",
                                          widget.supplierCd ?? "",
                                          widget.trace.itemCd,
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: listTrace.isNotEmpty,
                  child: const SizedBox(
                    width: 10,
                  ),
                ),
                Container(
                  width: listTrace.isNotEmpty
                      ? context.deviceWidth() * 0.385
                      : context.deviceWidth() * 0.793,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMobile ? sccBackground : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      BlocBuilder<TracebilityBloc, TracebilityState>(
                          builder: (context, state) {
                        if (state is TracebilityDetail) {
                          return BlocProvider(
                            create: (context) => TracebilityBloc(),
                            child: TraceDetail(
                              itemId: widget.trace.itemId!,
                              trace: widget.trace,
                              traceDetail: state.idDetail,
                            ),
                          );
                        } else if (state is TracebilityDetailConsume) {
                          return BlocProvider(
                            create: (context) => TracebilityBloc(),
                            child: TraceDetailConsume(
                              trace: state.trace,
                              traceDetail: state.idDetail,
                            ),
                          );
                        } else {
                          return CommonShimmer(
                            isLoading: state is TracebilityLoading,
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                bottom: 24,
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                Constant.emptyJourney,
                              ),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
