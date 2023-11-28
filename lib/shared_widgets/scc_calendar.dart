// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:styled_text/styled_text.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/shared_widgets/src/custom_calendar.dart';
import 'package:scc_web/theme/colors.dart';

class SccPeriodPicker extends StatefulWidget {
  final bool? reset;
  final double? height;
  final bool? isRTL;
  final bool? defaultToday;
  final Function(DateTime) onStartDateChanged, onEndDateChanged;
  final Function(DateTimeRange?) onRangeDateSelected;
  final Function()? onFinishedBuild;
  const SccPeriodPicker({
    required this.onRangeDateSelected,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    this.reset,
    this.isRTL,
    this.defaultToday,
    this.onFinishedBuild,
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  State<SccPeriodPicker> createState() => _SccPeriodPickerState();
}

class _SccPeriodPickerState extends State<SccPeriodPicker> {
  bool openPicker = false;
  bool periodChosen = false;

  List<KeyVal> listPeriod = [];
  List<KeyVal> listCustomPeriod = [];
  late DateTime lastWeekDate;
  late DateTime lastMonthsDay;
  late DateTime thisMonth;
  DateTime? customStartDate;
  DateTime? customEndDate;
  DateTime? fixedStartDate;
  DateTime? fixedEndDate;
  DateTime now = DateTime.now();
  KeyVal? selectedPeriod;
  KeyVal? selectedFixedPeriod;

  @override
  void initState() {
    lastMonthsDay = DateTime(now.year, now.month, now.day - 30);
    thisMonth = DateTime(now.year, now.month, 1);
    lastWeekDate = DateTime(now.year, now.month, now.day - 7);
    listCustomPeriod.add(KeyVal("Select Date", Constant.SELECT_DATE));
    listCustomPeriod.add(KeyVal("Select Week", Constant.SELECT_WEEK));
    listPeriod.add(KeyVal("All Time", Constant.ALL_TIME));
    listPeriod.add(KeyVal(
        "Today: ${convertDateToStringFormat(now, "MMM dd, yyyy")}",
        Constant.TODAY));
    listPeriod.add(
      KeyVal(
          "Last Week: ${(lastWeekDate.year == now.year) ? convertDateToStringFormat(lastWeekDate, "MMM dd") : convertDateToStringFormat(lastWeekDate, "MMM dd, yyyy")} - ${(lastWeekDate.month != now.month || (lastWeekDate.month != now.month && lastWeekDate.year != now.year)) ? convertDateToStringFormat(now, "MMM dd, yyyy") : convertDateToStringFormat(now, "dd, yyyy")}",
          Constant.LASTWEEK),
    );
    listPeriod.add(
      KeyVal(
          "Last 30 Days: ${(lastMonthsDay.year == now.year) ? convertDateToStringFormat(lastMonthsDay, "MMM dd") : convertDateToStringFormat(lastMonthsDay, "MMM dd, yyyy")} - ${(lastMonthsDay.month != now.month || (lastMonthsDay.month != now.month && lastMonthsDay.year != now.year)) ? convertDateToStringFormat(now, "MMM dd, yyyy") : convertDateToStringFormat(now, "dd, yyyy")}",
          Constant.LASTMONTHSDAY),
    );
    listPeriod.add(
      KeyVal(
          "This month: ${(thisMonth.year == now.year) ? convertDateToStringFormat(thisMonth, "MMM dd") : convertDateToStringFormat(thisMonth, "MMM dd, yyyy")} - ${(thisMonth.month != now.month || (thisMonth.month != now.month && thisMonth.year != now.year)) ? convertDateToStringFormat(now, "MMM dd, yyyy") : convertDateToStringFormat(now, "dd, yyyy")}",
          Constant.THISMONTH),
    );

    if (widget.defaultToday != null && widget.defaultToday == true) {
      selectedPeriod = listPeriod.elementAt(1);
      selectedFixedPeriod = listPeriod.elementAt(1);
    } else {
      selectedPeriod = listPeriod.first;
      selectedFixedPeriod = listPeriod.first;
    }

    if (widget.onFinishedBuild != null) {
      widget.onFinishedBuild!();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(SccPeriodPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.reset == true) {
        setState(() {
          selectedPeriod = listPeriod.first;
          selectedFixedPeriod = listPeriod.first;
        });
        if (widget.onFinishedBuild != null) {
          widget.onFinishedBuild!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTimeRange? fixedPeriodMap() {
      switch (selectedFixedPeriod?.value) {
        // case Constant.ALL_TIME:
        //   return null;
        case Constant.TODAY:
          return DateTimeRange(start: now, end: now);
        case Constant.LASTWEEK:
          return DateTimeRange(start: lastWeekDate, end: now);
        case Constant.LASTMONTHSDAY:
          return DateTimeRange(start: lastMonthsDay, end: now);
        case Constant.THISMONTH:
          return DateTimeRange(start: thisMonth, end: now);
        default:
          return null;
      }
    }

    Widget fixedPeriod(KeyVal element) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          hoverColor: sccFillField,
          onTap: () {
            setState(() {
              customStartDate = null;
              customEndDate = null;
              selectedPeriod = element;
              selectedFixedPeriod = element;
              openPicker = false;
              periodChosen = true;
            });
            DateTimeRange? range = fixedPeriodMap();
            // if (range != null) {
            widget.onRangeDateSelected(range);
            // }
          },
          child: SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: element.value == selectedPeriod?.value,
                  replacement: const SizedBox(width: 4),
                  child: Container(
                    width: 4,
                    // height: 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                      color: sccButtonPurple,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (selectedPeriod?.value == element.value)
                          ? sccDisabled
                          : Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (element.value == Constant.TODAY)
                              ? "Today (Real Time)"
                              : (element.value == Constant.LASTWEEK)
                                  ? "Last 7 days"
                                  : (element.value == Constant.LASTMONTHSDAY)
                                      ? "Last 30 days"
                                      : (element.value == Constant.THISMONTH)
                                          ? "This month"
                                          : element.label,
                          style: TextStyle(
                            fontSize: context.scaleFont(14),
                            color: selectedPeriod?.value == element.value
                                ? const Color(0xff7366FF)
                                : sccText1,
                            fontWeight: selectedPeriod?.value == element.value
                                ? FontWeight.w600
                                : null,
                          ),
                        ),
                        Visibility(
                          visible: ((element.value == Constant.TODAY) ||
                                  (element.value == Constant.LASTWEEK) ||
                                  (element.value == Constant.LASTMONTHSDAY) ||
                                  (element.value == Constant.THISMONTH)) &&
                              //  selectedPeriod?.value == Constant.INITIAL_PORTAL ||
                              listPeriod.firstWhereOrNull((e) =>
                                      e.value == selectedPeriod?.value) !=
                                  null,
                          replacement: const SizedBox(),
                          child: Text(
                            element.label,
                            style: TextStyle(
                              fontSize: context.scaleFont(14),
                              color: selectedPeriod?.value == element.value
                                  ? const Color(0xff7366FF)
                                  : sccText1,
                              fontWeight: selectedPeriod?.value == element.value
                                  ? FontWeight.w600
                                  : null,
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
        ),
      );
    }

    Widget customPickDateOpt(KeyVal element) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          hoverColor: sccFillField,
          onTap: () {
            setState(() {
              selectedPeriod = element;
              // openPicker = false;
            });
          },
          child: SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: element.value == selectedPeriod?.value,
                  replacement: const SizedBox(width: 4),
                  child: Container(
                    width: 4,
                    // height: 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                      color: sccButtonPurple,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    alignment: Alignment.centerLeft,
                    // width: context.deviceWidth(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (selectedPeriod?.value == element.value)
                          ? sccDisabled
                          : Colors.transparent,
                    ),
                    child: Text(
                      element.label,
                      style: TextStyle(
                        fontSize: context.scaleFont(14),
                        color: (selectedPeriod?.value == element.value)
                            ? const Color(0xff7366FF)
                            : sccText1,
                        fontWeight: (selectedPeriod?.value == element.value)
                            ? FontWeight.w600
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PortalTarget(
      visible: openPicker,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            openPicker = !openPicker;
          });
        },
      ),
      child: PortalTarget(
        visible: openPicker,
        anchor: Aligned(
          follower:
              (widget.isRTL ?? false) ? Alignment.topRight : Alignment.topLeft,
          target: (widget.isRTL ?? false)
              ? Alignment.bottomRight
              : Alignment.bottomLeft,
        ),
        portalFollower: Container(
          margin: const EdgeInsets.only(top: 8),
          width: 520,
          decoration: BoxDecoration(
            color: sccWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(14),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        "Period of Time",
                        style: TextStyle(
                          fontSize: context.scaleFont(14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: listPeriod.map((element) {
                        return fixedPeriod(element);
                      }).toList(),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 16,
                        color: sccButtonGrey,
                        thickness: 1,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: listCustomPeriod.map((element) {
                        return customPickDateOpt(element);
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Visibility(
                visible: listCustomPeriod.firstWhereOrNull(
                        (e) => e.value == selectedPeriod?.value) !=
                    null,
                replacement: const SizedBox(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 410,
                      width: 350,
                      child: CustomCalendar(
                        isRange: selectedPeriod?.value == Constant.SELECT_DATE,
                        focusStartDay: customStartDate,
                        focusEndDay: customEndDate,
                        onStartDaySelected: (value) {
                          if (value != null) {
                            widget.onStartDateChanged(value);
                            setState(() {
                              periodChosen = true;
                              customStartDate = value;
                            });
                          }
                        },
                        onEndDaySelected: (value) {
                          if (value != null) {
                            widget.onEndDateChanged(value);
                            setState(() {
                              periodChosen = true;
                              customEndDate = value;
                              openPicker = false;
                            });
                          }
                        },
                        onDaySelected: (value) {
                          if (value != null) {
                            setState(() {
                              // if (selectedPeriod?.value == Constant.SELECT_DATE) {
                              //   customStartDate = value;
                              //   customEndDate = value;
                              // } else
                              if (selectedPeriod?.value ==
                                  Constant.SELECT_WEEK) {
                                customStartDate = value.getMonday;
                                customEndDate = (DateTime.now()
                                        .difference(value.getSunday)
                                        .inDays
                                        .isNegative)
                                    ? DateTime.now()
                                    : value.getSunday;
                              }
                              openPicker = false;
                            });
                            if (customStartDate != null &&
                                customEndDate != null) {
                              widget.onRangeDateSelected(DateTimeRange(
                                  start: customStartDate!,
                                  end: customEndDate!));
                            }
                          }
                        },
                        selectableFirst: DateTime(1800),
                        selectableLast: DateTime.now(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        (customStartDate == null && customEndDate == null)
                            ? "You Haven't Chosen a date yet"
                            : ("${(customStartDate != null) ? convertDateToStringFormat(customStartDate, "MMM dd, yyyy") : ""} - ${(customEndDate != null) ? convertDateToStringFormat(customEndDate, "MMM dd, yyyy") : "Choose end date"}"),
                        style: TextStyle(
                          fontSize: context.scaleFont(14),
                          color: sccText2,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              openPicker = !openPicker;
              // overlayData = false;
              // clickedID = -1;
            });
          },
          child: Container(
            height: widget.height ?? 45,
            constraints: const BoxConstraints(minWidth: 170),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
              color: sccWhite,
            ),
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HeroIcon(
                  HeroIcons.calendar,
                  color: Color(0xff7366FF),
                  size: 24,
                ),
                const SizedBox(
                  width: 8,
                ),
                StyledText(
                  text: showLabel(),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: context.scaleFont(14),
                    color:
                        // (periodChosen
                        // selectedPeriod?.value != Constant.INITIAL_PORTAL || selectedFixedPeriod?.value != Constant.INITIAL_PORTAL
                        // ) ?
                        sccText3
                    // :
                    // sccHintText
                    ,
                    // fontWeight: FontWeight.bold,
                  ),
                  tags: {
                    'b': StyledTextTag(
                      style: TextStyle(
                        fontSize: context.scaleFont(14),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  },
                ),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String showLabel() {
    if ((customStartDate == null && customEndDate == null)) {
      return " ${((selectedFixedPeriod?.label ?? (listCustomPeriod.firstWhereOrNull((e) => e.value == selectedPeriod?.value))?.label ?? " "))} ";
    } else if ((customStartDate?.month == customEndDate?.month &&
        customStartDate?.year == customEndDate?.year &&
        customStartDate?.day == customEndDate?.day)) {
      return convertDateToStringFormat(customStartDate, "MMM dd, yyyy");
    } else {
      return ((customStartDate?.year == customEndDate?.year)
              ? convertDateToStringFormat(customStartDate, "MMM dd")
              : convertDateToStringFormat(customStartDate, "MMM dd, yyyy")) +
          ((customEndDate != null)
              ? (" - ${(customStartDate?.month != customEndDate?.month || (customStartDate?.month != customEndDate?.month && customStartDate?.year != customEndDate?.year)) ? convertDateToStringFormat(customEndDate, "MMM dd, yyyy") : convertDateToStringFormat(customEndDate, "dd, yyyy")}")
              : "");
    }
  }
}
