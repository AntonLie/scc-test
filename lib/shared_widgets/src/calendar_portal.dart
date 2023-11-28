// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/src/custom_calendar.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/form_dialog.dart';

class CalendarPortal extends StatefulWidget {
  // final bool visible;
  final String? startDtStr, endDtStr;
  final double? height, width;
  final DateTime endDtSelected, startDtSelected;
  final bool isPopToTop;
  final Color? fillColor;
  // final Function(bool) onVisibilityChanged;
  // final Function(String) onStartDtStrChanged, onEndDtStrChanged;
  final Function(DateTime?)? onStartDtChanged, onEndDtChanged;
  final Function(DateTimeRange)? onDtRangeSelected;

  const CalendarPortal({
    Key? key,
    // required this.visible,
    required this.startDtStr,
    required this.endDtStr,
    required this.startDtSelected,
    required this.endDtSelected,
    this.height,
    this.width,
    // required this.onVisibilityChanged,
    this.onDtRangeSelected,
    this.onEndDtChanged,
    this.onStartDtChanged,
    // required this.onEndDtStrChanged,
    // required this.onStartDtStrChanged,
    this.isPopToTop = false,
    this.fillColor,
  }) : super(key: key);

  @override
  _CalendarPortalState createState() => _CalendarPortalState();
}

class _CalendarPortalState extends State<CalendarPortal> {
  String start = "";
  String end = "";
  DateTime? startDtSelected;
  DateTime? endDtSelected;
  bool visible = false;
  @override
  void initState() {
    startDtSelected = widget.startDtSelected;
    endDtSelected = widget.endDtSelected;
    start = widget.startDtStr ?? "";
    end = widget.endDtStr ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (startDtSelected != null && endDtSelected != null) {
            if (widget.onDtRangeSelected != null) {
              widget.onDtRangeSelected!(
                  DateTimeRange(start: startDtSelected!, end: endDtSelected!));
            }
            setState(() {
              visible = !visible;
            });
          }
        },
      ),
      child: PortalTarget(
        visible: visible,
        anchor: Aligned(
          follower: widget.isPopToTop == true
              ? Alignment.bottomLeft
              : Alignment.topLeft,
          target: widget.isPopToTop == true
              ? Alignment.topLeft
              : Alignment.bottomLeft,
        ),
        portalFollower: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 8),
          height: 420,
          width: 470,
          decoration: BoxDecoration(
            border: Border.all(color: sccText4, width: 0.5),
            borderRadius: BorderRadius.circular(12),
            color: sccWhite,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Time Period",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: sccBlack,
                        ),
                      ),
                      Visibility(
                        visible: start.isNotEmpty,
                        child: const SizedBox(
                          height: 8,
                        ),
                      ),
                      Visibility(
                        visible: start.isNotEmpty,
                        child: GradientWidget(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              sccButtonLightBlue,
                              sccButtonBlue,
                            ],
                          ),
                          child: Text(
                            '${DateFormat.E(Localizations.localeOf(context).languageCode).format(widget.startDtSelected)}, $start',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: start.isNotEmpty,
                        child: const SizedBox(
                          height: 8,
                        ),
                      ),
                      Visibility(
                        visible: start.isNotEmpty,
                        child: const Text(
                          "To",
                          style: TextStyle(
                            fontSize: 12,
                            color: sccBlack,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: start.isNotEmpty,
                        child: const SizedBox(
                          height: 8,
                        ),
                      ),
                      Visibility(
                        visible: start.isNotEmpty,
                        child: GradientWidget(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              sccButtonLightBlue,
                              sccButtonBlue,
                            ],
                          ),
                          child: Text(
                            '${DateFormat.E(Localizations.localeOf(context).languageCode).format(widget.endDtSelected)}, $end',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomCalendar(
                  focusStartDay: widget.startDtSelected,
                  focusEndDay: widget.endDtSelected,
                  isRange: true,
                  // onDaySelected: (value){},
                  onStartDaySelected: (value) {
                    if (value != null) {
                      startDtSelected = value;
                      setState(() {
                        start = convertDateToStringFormat(value, "dd MMM yyyy");
                        // startDtSelected = value;
                      });
                      if (widget.onStartDtChanged != null) {
                        widget.onStartDtChanged!(startDtSelected);
                      }
                    }
                  },
                  onEndDaySelected: (value) {
                    if (value != null) {
                      setState(() {
                        endDtSelected = value;
                        end = convertDateToStringFormat(value, "dd MMM yyyy");
                        if (widget.onDtRangeSelected != null) {
                          widget.onDtRangeSelected!(DateTimeRange(
                              start: startDtSelected!, end: endDtSelected!));
                        }
                        visible = !visible;
                        // endDtSelected = value;
                      });
                      if (widget.onEndDtChanged != null) {
                        widget.onEndDtChanged!(endDtSelected);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            setState(() {
              visible = !visible;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.fillColor ?? sccWhite,
            ),
            height: widget.height ?? 40,
            width: widget.width ?? context.deviceWidth() * 0.21,
            // origin 6
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 6),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const GradientWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      sccButtonLightBlue,
                      sccButtonBlue,
                    ],
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    // 8-Mar-2022 WOT - Patrick
                    // Changes on size from 14 - 22
                    size: 22,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Row(
                    children: [
                      // Added Padding WOT - Patrick 8/3/2022
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 8, right: 6),
                        child: Text(
                          "Period : ",
                          style: TextStyle(
                            // Change Font Size from 12 -> 14 To Match with other text widget
                            fontSize: context.scaleFont(16),
                            color: sccText3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.startDtSelected.year ==
                                      widget.endDtSelected.year &&
                                  widget.startDtSelected.month ==
                                      widget.endDtSelected.month &&
                                  widget.startDtSelected.day ==
                                      widget.endDtSelected.day
                              ? convertDateToStringFormat(widget.startDtSelected, "dd MMM yyyy")
                              : '${(widget.startDtSelected.month == widget.endDtSelected.month && widget.startDtSelected.year == widget.endDtSelected.year) ? convertDateToStringFormat(widget.startDtSelected, "dd") : (widget.startDtSelected.year == widget.endDtSelected.year) ? convertDateToStringFormat(widget.startDtSelected, "dd MMM") : convertDateToStringFormat(widget.startDtSelected, "dd MMM yyyy")} - $end',
                          maxLines: 1,
                          style: TextStyle(
                            // Change Font Size from 12 -> 14 To Match with other text widget
                            fontSize: context.scaleFont(16),
                            color: sccText3,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const GradientWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      sccButtonLightBlue,
                      sccButtonBlue,
                    ],
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SingleDateCalendarPortal extends StatefulWidget {
  // final bool visible;
  // final String? startDtStr, endDtStr;
  final double? height, width;
  // final DateTime endDtSelected, startDtSelected;
  // final String? selectedDtStr;
  final DateTime? selectedDt;
  final bool isPopToTop;
  final Color? fillColor;
  // final Function(bool) onVisibilityChanged;
  // final Function(String) onStartDtStrChanged, onEndDtStrChanged;
  // final Function(DateTime?)? onStartDtChanged, onEndDtChanged;
  final Function(DateTime?)? onChanged;
  // final Widget? child;
  // final Function(DateTimeRange)? onDtRangeSelected;

  const SingleDateCalendarPortal({
    Key? key,
    this.height,
    this.width,
    // this.child,
    required this.onChanged,
    required this.selectedDt,
    this.isPopToTop = false,
    this.fillColor,
  }) : super(key: key);

  @override
  _SingleDateCalendarPortalState createState() =>
      _SingleDateCalendarPortalState();
}

class _SingleDateCalendarPortalState extends State<SingleDateCalendarPortal> {
  DateTime? selectedDt;
  bool visible = false;
  @override
  void initState() {
    selectedDt = widget.selectedDt;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // if (selectedDt != null && widget.onChanged != null) {
          //   widget.onChanged!(selectedDt);
          setState(() {
            visible = !visible;
          });
          // }
        },
      ),
      child: PortalTarget(
        visible: visible,
        anchor: Aligned(
          follower: widget.isPopToTop == true
              ? Alignment.bottomLeft
              : Alignment.topLeft,
          target: widget.isPopToTop == true
              ? Alignment.topLeft
              : Alignment.bottomLeft,
        ),
        portalFollower: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 8),
          height: 410,
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(color: sccText4, width: 0.5),
            borderRadius: BorderRadius.circular(12),
            color: sccWhite,
          ),
          child: CustomCalendar(
            selectedDt: selectedDt,
            isRange: false,
            onDaySelected: (value) {
              if (value != null) {
                setState(() {
                  selectedDt = value;
                  // setState(() {
                  visible = !visible;
                  // });
                });
                if (widget.onChanged != null) widget.onChanged!(selectedDt);
              }
            },
          ),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            setState(() {
              visible = !visible;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.fillColor ?? sccWhite,
            ),
            height: widget.height ?? 40,
            width: widget.width ?? context.deviceWidth() * 0.21,
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const GradientWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      sccButtonLightBlue,
                      sccButtonBlue,
                    ],
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 24,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                // Expanded(
                //   child: Row(
                //     children: [
                //       Text(
                //         "Period : ",
                //         style: TextStyle(
                //           fontSize: context.scaleFont(12),
                //           color: sccText3,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                Expanded(
                  child: Text(
                    convertDateToStringFormat(widget.selectedDt, "dd MMM yyyy"),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: context.scaleFont(12),
                      color: sccText3,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  width: 2,
                ),
                const GradientWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      sccButtonLightBlue,
                      sccButtonBlue,
                      sccButtonBlue,
                    ],
                  ),
                  child: HeroIcon(
                    HeroIcons.chevronDown,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SingleDateCalendarForm extends StatefulWidget {
  // final bool visible;
  // final String? startDtStr, endDtStr;
  // final DateTime endDtSelected, startDtSelected;
  // final String? selectedDtStr;
  final DateTime? selectedDt, firstDate, lastDate;
  final String? Function(String?)? validator;
  final bool isPopToTop;
  final bool? enabled;
  // final Color? fillColor;
  // final Function(bool) onVisibilityChanged;
  // final Function(String) onStartDtStrChanged, onEndDtStrChanged;
  // final Function(DateTime?)? onStartDtChanged, onEndDtChanged;
  final Function(DateTime?)? onChanged;

  // final Function(DateTimeRange)? onDtRangeSelected;

  const SingleDateCalendarForm({
    Key? key,
    this.enabled,
    this.validator,
    required this.onChanged,
    required this.selectedDt,
    this.isPopToTop = false,
    this.firstDate,
    this.lastDate,
    // this.fillColor,
  }) : super(key: key);

  @override
  _SingleDateCalendarFormState createState() => _SingleDateCalendarFormState();
}

class _SingleDateCalendarFormState extends State<SingleDateCalendarForm> {
  DateTime? selectedDt;
  bool visible = false;

  late TextEditingController dateCo;

  // void didUpdateWidget(SingleDateCalendarForm oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
  //     selectedDt = widget.selectedDt;
  //         dateCo.value = dateCo.value.copyWith(text: (selectedDt != null) ? convertDateToStringFormat(selectedDt!, "dd MMM yyyy") : "");
  //       }));
  // }

  @override
  void initState() {
    selectedDt = widget.selectedDt;
    dateCo = TextEditingController();
    // selectedItem = widget.selectedItem;
    dateCo.value = dateCo.value.copyWith(
        text: (selectedDt != null)
            ? convertDateToStringFormat(selectedDt!, "dd MMM yyyy")
            : "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // if (selectedDt != null && widget.onChanged != null) {
          //   widget.onChanged!(selectedDt);
          setState(() {
            visible = !visible;
          });
          // }
        },
      ),
      child: PortalTarget(
        visible: visible,
        anchor: Aligned(
          follower: widget.isPopToTop == true
              ? Alignment.bottomLeft
              : Alignment.topLeft,
          target: widget.isPopToTop == true
              ? Alignment.topLeft
              : Alignment.bottomLeft,
        ),
        portalFollower: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 8),
          height: 410,
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(color: sccText4, width: 0.5),
            borderRadius: BorderRadius.circular(12),
            color: sccWhite,
          ),
          child: CustomCalendar(
            selectedDt: selectedDt,
            selectableFirst: widget.firstDate,
            selectableLast: widget.lastDate,
            isRange: false,
            onDaySelected: (value) {
              if (value != null) {
                setState(() {
                  selectedDt = value;
                  // setState(() {
                  dateCo.value = dateCo.value.copyWith(
                      text: (selectedDt != null)
                          ? convertDateToStringFormat(
                              selectedDt!, "dd MMM yyyy")
                          : "");
                  visible = !visible;
                  // });
                });
                if (widget.onChanged != null) widget.onChanged!(selectedDt);
              }
            },
          ),
        ),
        child: CustomFormTextField(
          controller: dateCo,
          hint: 'Select Date',
          readOnly: true,
          // focusNode: focusValidTo,
          enabled: widget.enabled,

          onTap: () {
            setState(() {
              visible = !visible;
            });
          },
          validator: widget.validator,
        ),
      ),
    );
  }
}

class SingleDateCalendarLov extends StatefulWidget {
  final DateTime? selectedDt, firstDate, lastDate;
  final String? Function(DateTime?)? validator;
  final bool isPopToTop;
  final bool? enabled;
  final Function(DateTime?)? onChanged;

  const SingleDateCalendarLov({
    Key? key,
    this.enabled,
    this.validator,
    required this.onChanged,
    required this.selectedDt,
    this.isPopToTop = false,
    this.firstDate,
    this.lastDate,
    // this.fillColor,
  }) : super(key: key);

  @override
  _SingleDateCalendarLovState createState() => _SingleDateCalendarLovState();
}

class _SingleDateCalendarLovState extends State<SingleDateCalendarLov> {
  DateTime? selectedDt;
  bool visible = false;
  late TextEditingController dateCo;

  @override
  void initState() {
    selectedDt = widget.selectedDt;
    dateCo = TextEditingController();
    dateCo.value = dateCo.value.copyWith(
        text: (selectedDt != null)
            ? convertDateToStringFormat(selectedDt!, "dd MMM yyyy")
            : "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            visible = !visible;
          });
        },
      ),
      child: PortalTarget(
        visible: visible,
        anchor: Aligned(
          follower: widget.isPopToTop == true
              ? Alignment.bottomLeft
              : Alignment.topLeft,
          target: widget.isPopToTop == true
              ? Alignment.topLeft
              : Alignment.bottomLeft,
        ),
        portalFollower: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 8),
          height: 410,
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(color: sccText4, width: 0.5),
            borderRadius: BorderRadius.circular(12),
            color: sccWhite,
          ),
          child: CustomCalendar(
            selectedDt: selectedDt,
            selectableFirst: widget.firstDate,
            selectableLast: widget.lastDate,
            isRange: false,
            onDaySelected: (value) {
              if (value != null) {
                setState(() {
                  selectedDt = value;
                  dateCo.value = dateCo.value.copyWith(
                      text: (selectedDt != null)
                          ? convertDateToStringFormat(
                              selectedDt!, "dd MMM yyyy")
                          : "");
                  visible = !visible;
                });
                if (widget.onChanged != null) widget.onChanged!(selectedDt);
              }
            },
          ),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              visible = !visible;
            });
          },
          child: Container(
            height: 48,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: sccLightGray,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dateCo.text,
                    style: TextStyle(
                      fontSize: context.scaleFont(16),
                    ),
                  ),
                  HeroIcon(
                    HeroIcons.chevronDown,
                    size: context.scaleFont(24),
                    color: sccText4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SingleDateCalendarPortalForm extends StatefulWidget {
  // final bool visible;
  // final String? startDtStr, endDtStr;
  final double? height, width;
  // final DateTime endDtSelected, startDtSelected;
  // final String? selectedDtStr;
  final DateTime? selectedDt, firstDate, lastDate;
  final bool? isPopToTop, enabled, prefixVisible, withTime;
  final Color? fillColour;
  // final Function(bool) onVisibilityChanged;
  // final Function(String) onStartDtStrChanged, onEndDtStrChanged;
  // final Function(DateTime?)? onStartDtChanged, onEndDtChanged;
  final Function(DateTime?)? onChanged;
  final String? Function(DateTime?)? validator;
  final Widget? suffix, prefix;
  final String? hintText;

  // final Widget? child;
  // final Function(DateTimeRange)? onDtRangeSelected;

  const SingleDateCalendarPortalForm({
    Key? key,
    this.height,
    this.width,
    // this.child,
    this.enabled,
    this.withTime,
    this.prefixVisible,
    required this.onChanged,
    required this.selectedDt,
    this.hintText,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.isPopToTop,
    this.fillColour,
    this.suffix,
    this.prefix,
  }) : super(key: key);

  @override
  _SingleDateCalendarPortalFormState createState() =>
      _SingleDateCalendarPortalFormState();
}

class _SingleDateCalendarPortalFormState
    extends State<SingleDateCalendarPortalForm> {
  DateTime? selectedDt;
  TimeOfDay? sysTimeSelected;

  bool visible = false;
  bool onHovered = false;
  @override
  void initState() {
    selectedDt = widget.selectedDt;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime?>(
      initialValue: selectedDt,
      key: widget.key,
      enabled: (widget.enabled ?? true),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            PortalTarget(
              visible: visible,
              portalFollower: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // if (selectedDt != null && widget.onChanged != null) {
                  //   widget.onChanged!(selectedDt);
                  setState(() {
                    visible = !visible;
                  });
                  // }
                },
              ),
              child: PortalTarget(
                visible: visible,
                anchor: Aligned(
                  follower: widget.isPopToTop == true
                      ? Alignment.bottomLeft
                      : Alignment.topLeft,
                  target: widget.isPopToTop == true
                      ? Alignment.topLeft
                      : Alignment.bottomLeft,
                ),
                portalFollower: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 8),
                  height: 410,
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border.all(color: sccText4, width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    color: sccWhite,
                  ),
                  child: CustomCalendar(
                    selectedDt: selectedDt,
                    isRange: false,
                    selectableFirst: widget.firstDate,
                    selectableLast: widget.lastDate,
                    onDaySelected: (value) async {
                      if (value != null) {
                        setState(() {
                          visible = !visible;
                        });
                        if (widget.withTime == true) {
                          sysTimeSelected = await customTimePicker(
                            context,
                            sysTimeSelected ?? TimeOfDay.now(),
                            // onSelect: (val) {
                            //   sysTimeSelected = val;
                            // setState(() {
                            //   if (selectedDt != null) {
                            //     selectedDt!.hour = sysTimeSelected.hour;
                            //     selectedDt!.minute = sysTimeSelected.minute;
                            //   }
                            // });
                            // sysTimeCo.value = sysTimeCo.value.copyWith(text: timeOfDayHHmm(sysTimeSelected));
                            // },
                          );
                        }
                        setState(() {
                          DateTime dtTemp = value;
                          selectedDt = DateTime(
                              dtTemp.year,
                              dtTemp.month,
                              dtTemp.day,
                              sysTimeSelected?.hour ?? 0,
                              sysTimeSelected?.minute ?? 0);
                          state.didChange(selectedDt);
                        });

                        if (widget.onChanged != null) {
                          widget.onChanged!(selectedDt);
                        }
                      }
                    },
                  ),
                ),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  // hoverColor: sccFillField,
                  onHover: (value) {
                    if (widget.enabled != false) {
                      setState(() {
                        onHovered = value;
                      });
                    }
                  },
                  onTap: () {
                    if (widget.enabled != false) {
                      setState(() {
                        visible = !visible;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              // (widget.borderColour != null)
                              //     ? widget.borderColour!
                              //     : (widget.fillColour != null)
                              //         ? widget.fillColour!
                              //         :
                              (widget.enabled == false)
                                  ? sccDisabledTextField
                                  : (state.hasError)
                                      ? sccDanger
                                      :
                                      // (visible)
                                      //     ? sccButtonBlue
                                      //     :
                                      sccLightGray,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: (widget.fillColour != null)
                            ? widget.fillColour!
                            : (widget.enabled == false)
                                ? sccDisabledTextField
                                : onHovered
                                    ? sccFillField
                                    : (state.hasError)
                                        ? sccValidateField
                                        :
                                        // (visible)
                                        //     ?
                                        sccWhite
                        // : sccFillLoginField,
                        ),
                    // height: widget.height ?? 40,
                    width: widget.width ?? context.deviceWidth(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: widget.prefixVisible != false,
                          child: widget.prefix ??
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // GradientWidget(
                                  //   gradient: LinearGradient(
                                  //     begin: Alignment.topCenter,
                                  //     end: Alignment.bottomCenter,
                                  //     colors: [
                                  //       sccButtonLightBlue,
                                  //       sccButtonBlue,
                                  //     ],
                                  //   ),
                                  //   child:
                                  HeroIcon(
                                    HeroIcons.calendar,
                                    size: context.scaleFont(24),
                                    color: sccText4,
                                  ),
                                  // ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                ],
                              ),
                        ),
                        // Expanded(
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         "Period : ",
                        //         style: TextStyle(
                        //           fontSize: context.scaleFont(12),
                        //           color: sccText3,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        Expanded(
                          child: SizedBox(
                            child: Text(
                              widget.selectedDt != null
                                  ? convertDateToStringFormat(widget.selectedDt, (widget.withTime == true) ? "dd MMM yyyy HH:mm" : "dd MMM yyyy")
                                  : (widget.hintText ?? "Select Date"),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: context.scaleFont(16),
                                color: widget.selectedDt != null
                                    ? sccText3
                                    : Theme.of(context).hintColor,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        //     ],
                        //   ),
                        // ),
                        // widget.suffix ??
                        //     GradientWidget(
                        //       gradient: LinearGradient(
                        //         begin: Alignment.topCenter,
                        //         end: Alignment.bottomCenter,
                        //         colors: [
                        //           sccButtonLightBlue,
                        //           sccButtonBlue,
                        //         ],
                        //       ),
                        //       child:
                        widget.suffix ??
                            HeroIcon(
                              HeroIcons.chevronDown,
                              size: context.scaleFont(24),
                              color: sccText4,
                            ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: state.hasError,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  state.errorText ?? '',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: context.scaleFont(12),
                  ),
                ),
              ),
            )
          ],
        );
      },
      validator: widget.validator,
    );
  }
}
