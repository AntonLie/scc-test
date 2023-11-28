// import 'package:custom_table_calendar/custom_calendar_builders.dart';
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/src/customization/calendar_builders.dart';
import 'package:scc_web/shared_widgets/src/customization/calendar_style.dart';
import 'package:scc_web/shared_widgets/src/customization/header_style.dart';
import 'package:scc_web/shared_widgets/src/shared/utils.dart';
import 'package:scc_web/shared_widgets/src/table_calendar.dart';
import 'package:scc_web/theme/colors.dart';
// import 'package:table_calendar/table_calendar.dart';


class CustomCalendar extends StatefulWidget {
  final bool isRange;
  final Function(DateTime?)? onDaySelected, onStartDaySelected, onEndDaySelected;
  final DateTime? focusStartDay, focusEndDay, selectedDt, selectableFirst, selectableLast;

  const CustomCalendar(
      {Key? key,
      this.focusStartDay,
      this.focusEndDay,
      this.selectedDt,
      this.onDaySelected,
      required this.isRange,
      this.onStartDaySelected,
      this.onEndDaySelected,
      this.selectableFirst,
      this.selectableLast})
      : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime? startDay;
  DateTime? selectedDay;
  DateTime? endDay;

  DateTime now = DateTime.now();
  @override
  void initState() {
    startDay = widget.focusStartDay;
    endDay = widget.focusEndDay;
    selectedDay = widget.selectedDt;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomCalendar oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          startDay = widget.focusStartDay;
          endDay = widget.focusEndDay;
          selectedDay = widget.selectedDt;
        }));

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 320,
      // width: 280,
      child: VccCalendar(
        focusedDay: (widget.selectableFirst != null && !(widget.selectableFirst!.difference(now).inDays.isNegative))
            ? widget.selectableFirst!
            : (widget.selectableLast != null && (widget.selectableLast!.difference(now).inDays.isNegative))
                ? widget.selectableLast!
                : (selectedDay ?? now),
        firstDay: widget.selectableFirst ?? DateTime(1800, 1, 1),
        lastDay: widget.selectableLast ?? DateTime(2101, 1, 0),
        selectedDayPredicate: !widget.isRange ? (day) => isSameDay(selectedDay, day) : null,
        locale: Localizations.localeOf(context).languageCode,
        rowHeight: 50,
        daysOfWeekHeight: 20,
        sixWeekMonthsEnforced: true,
        // headerText: ,
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronVisible: true,
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.black,
          ),
          rightChevronVisible: true,
        ),
        calendarStyle: CalendarStyle(
          isTodayHighlighted: !(startDay != null && now.isAfter(startDay!) && endDay != null && now.isBefore(endDay!)),
        ),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: !widget.isRange
              ? (context, day, focusedDay) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(
                        top: 6,
                        left: 4,
                        right: 4,
                      ),
                      duration: const Duration(milliseconds: 250),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //   begin: Alignment.topCenter,
                        //   end: Alignment.bottomCenter,
                        //   colors: [
                        //     Colors.blue.shade200,
                        //     Colors.blue,
                        //   ],
                        // ),
                        color: sccButtonPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        focusedDay.day.toString(),
                        style: TextStyle(fontSize: context.scaleFont(16), color: Colors.white),
                      ),
                    ),
                  );
                }
              : null,
          todayBuilder: (context, day, focusedDay) {
            return AspectRatio(
              aspectRatio: 1,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  margin: const EdgeInsets.only(
                    top: 6,
                    left: 4,
                    right: 4,
                  ),
                  duration: const Duration(milliseconds: 250),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [
                    //     Colors.blue.shade200,
                    //     Colors.blue,
                    //   ],
                    // ),
                    color: sccButtonPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    // margin: const EdgeInsets.all(1),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(fontSize: context.scaleFont(16)),
                    ),
                  ),
                ),
              ),
            );
          },
          dowBuilder: (context, day) {
            return Center(
              child: Text(
                DateFormat.E(Localizations.localeOf(context).languageCode).format(day),
                style: TextStyle(
                  color: sccText2, // _textColor(day),
                  fontSize: context.scaleFont(16),
                ),
              ),
            );
          },
          defaultBuilder: (context, day, focusedDay) {
            return AspectRatio(
              aspectRatio: 1,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CalendarCellTemplate(
                  dayText: day.day.toString(),
                  dayTextColor: sccBlack, //_textColor(day),
                  borderColor: Colors.green[600],
                ),
              ),
            );
          },
          outsideBuilder: (context, day, focusedDay) {
            return AspectRatio(
              aspectRatio: 1,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CalendarCellTemplate(
                  dayText: day.day.toString(),
                  dayTextColor: Colors.grey,
                  borderColor: Colors.green[600],
                ),
              ),
            );
          },
          disabledBuilder: (context, day, focusedDay) {
            return AspectRatio(
              aspectRatio: 1,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CalendarCellTemplate(
                  dayText: day.day.toString(),
                  dayTextColor: Colors.grey,
                  borderColor: Colors.green[600],
                ),
              ),
            );
          },
          rangeEndBuilder: (context, day, focusedDay) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                margin: const EdgeInsets.only(top: 6, right: 4),
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  // gradient: LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: [
                  //     Colors.blue.shade200,
                  //     Colors.blue,
                  //   ],
                  // ),
                  color: sccButtonPurple,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                padding: const EdgeInsets.all(2),
                child: Text(
                  day.day.toString(),
                  style: TextStyle(fontSize: context.scaleFont(16), color: Colors.white),
                ),
              ),
            );
          },
          rangeStartBuilder: (context, day, focusedDay) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                margin: const EdgeInsets.only(top: 6, left: 4),
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: [
                  //     Colors.blue.shade200,
                  //     Colors.blue,
                  //   ],
                  // ),
                  color: sccButtonPurple,
                  borderRadius: (endDay == null || (startDay != null && endDay != null && startDay == endDay))
                      ? BorderRadius.circular(8)
                      : const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                ),
                padding: const EdgeInsets.all(2),
                child: Text(
                  day.day.toString(),
                  style: TextStyle(fontSize: context.scaleFont(16), color: Colors.white),
                ),
              ),
            );
          },
          withinRangeBuilder: (context, day, focusedDay) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                margin: const EdgeInsets.only(top: 6),
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xffCEC9FF),
                  //  Colors.blue.shade200,
                ),
                padding: const EdgeInsets.all(2),
                child: Text(
                  day.day.toString(),
                  style: TextStyle(fontSize: context.scaleFont(16)),
                ),
              ),
            );
          },
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        weekendDays: const [
          DateTime.saturday,
          DateTime.sunday,
        ],
        rangeStartDay: startDay,
        rangeEndDay: endDay,
        rangeSelectionMode: widget.isRange ? RangeSelectionMode.enforced : RangeSelectionMode.disabled,
        pageJumpingEnabled: true,
        onDaySelected: (selectedDay, focusedDay) {
          // loginc end & start
          if (!(selectedDay.difference(widget.selectableFirst ?? DateTime(1800, 1, 1)).inDays.isNegative) &&
              (selectedDay.difference(widget.selectableLast ?? DateTime(2101, 1, 0)).inDays.isNegative)) {
            setState(() {
              this.selectedDay = focusedDay;
            });
            if (widget.onDaySelected != null) widget.onDaySelected!(this.selectedDay);
          }
        },
        onRangeSelected: (start, end, focusedDay) {
          setState(() {
            selectedDay = focusedDay;
            startDay = start;
            // if (end == null) {
            //   selectedDay = focusedDay;
            // } else {
            //   selectedDay = null;
            // }
            endDay = end;
          });
          if (widget.onStartDaySelected != null) widget.onStartDaySelected!(startDay);
          if (widget.onEndDaySelected != null) widget.onEndDaySelected!(endDay);
        },
      ),
    );
  }

  // Color _textColor(DateTime day) {
  //   const _defaultTextColor = Colors.black87;

  //   if (day.weekday == DateTime.sunday) {
  //     return Colors.red;
  //   }
  //   if (day.weekday == DateTime.saturday) {
  //     return Colors.blue[600]!;
  //   }
  //   return _defaultTextColor;
  // }
}

class CalendarCellTemplate extends StatelessWidget {
  const CalendarCellTemplate({
    Key? key,
    String? dayText,
    Duration? duration,
    Alignment? textAlign,
    Color? dayTextColor,
    Color? borderColor,
    double? borderWidth,
  })  : dayText = dayText ?? '',
        duration = duration ?? const Duration(milliseconds: 250),
        textAlign = textAlign ?? Alignment.center,
        dayTextColor = dayTextColor ?? Colors.black87,
        borderColor = borderColor ?? Colors.black87,
        borderWidth = borderWidth ?? 0.5,
        super(key: key);

  final String dayText;
  final Color? dayTextColor;
  final Duration duration;
  final Alignment? textAlign;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // margin: const EdgeInsets.only(top:4, left:4, right:4,),
      duration: duration,
      margin: EdgeInsets.zero,
      alignment: textAlign,
      child: Text(
        dayText,
        style: TextStyle(
          color: dayTextColor,
          fontSize: context.scaleFont(16),
        ),
      ),
    );
  }
}
