import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/scc_calendar.dart';

class Period extends StatefulWidget {
  final DateTime? startDtSelected;
  final DateTime? endDtSelected;
  final bool reset;
  final Function(bool) handleResetDate;
  final Function(DateTime?, DateTime?) handleDateSelected;
  final Function(DateTime) handleEndDate;
  const Period(
      {super.key,
      this.startDtSelected,
      this.endDtSelected,
      required this.reset,
      required this.handleResetDate,
      required this.handleDateSelected,
      required this.handleEndDate});

  @override
  State<Period> createState() => _PeriodState();
}

class _PeriodState extends State<Period> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          'Period',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: context.scaleFont(14),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 48,
          // width: context.deviceWidth() * 0.15,
          child: SccPeriodPicker(
            isRTL: true,
            defaultToday: true,
            reset: widget.reset,
            onFinishedBuild: () {
              widget.handleResetDate(false);
            },
            onRangeDateSelected: (val) {
              var startDate = val?.start;
              var endDate = val?.end;

              widget.handleDateSelected(startDate, endDate);
            },
            onStartDateChanged: (val) {
              widget.handleDateSelected(val, val);
            },
            onEndDateChanged: (val) {
              widget.handleEndDate(val);
            },
          ),
        ),
      ],
    );
  }
}
