import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/theme/colors.dart';
// import 'package:vcc_web/model/login.dart';

customWebDateRangePicker(
    BuildContext context, DateTime firstDate, DateTime lastDate,
    {required Function(DateTimeRange?) onSelect, DateTimeRange? initialValue}) {
  return showDateRangePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDateRange: initialValue,
    errorFormatText: 'Input MM/dd/yyyy',
    builder: (context, child) {
      return SizedBox(
        width: 400.0,
        height: 500.0,
        child: Center(
          child: Theme(
            data: ThemeData(
              primaryColor: sccRed,
              // primarySwatch: Colors.red,
            ),
            child: child!,
          ),
        ),
      );
    },
  ).then(onSelect);
}

Future<TimeOfDay?> customTimePicker(
    BuildContext context, TimeOfDay selectedTime,
    {Function(TimeOfDay)? onSelect}) {
  return showTimePicker(
    context: context,
    initialTime: selectedTime,
    initialEntryMode: TimePickerEntryMode.input,
    confirmText: "CONFIRM",
    cancelText: "NOT NOW",
    helpText: "DATE TIME",
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: true),
        child: SizedBox(
          width: 400.0,
          height: 500.0,
          child: Center(
            child: Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                primary: sccButtonBlue, // header background color
                // onPrimary: Colors.black, // header text color
                // onSurface: Colors.green, // body text color
              )),
              child: child!,
            ),
          ),
        ),
      );
    },
  ).then((value) {
    if (onSelect != null && value != null) onSelect(value);
    return value;
  });
}

customWebDatePicker(BuildContext context, DateTime initialDate,
    DateTime firstDate, DateTime lastDate, Function(DateTime?) onSelect) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    fieldHintText: 'Input MM/dd/yyyy',
    errorFormatText: 'Input MM/dd/yyyy',
    builder: (context, child) {
      return SizedBox(
        width: 400.0,
        height: 500.0,
        child: Center(
          child: Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
              primary: sccButtonBlue, // header background color
              // onPrimary: Colors.black, // header text color
              // onSurface: Colors.green, // body text color
            )),
            child: child!,
          ),
        ),
      );
    },
  ).then(onSelect);
}

class DialogSuccess extends StatelessWidget {
  final String bodyText;
  final String buttonText;
  final Function() onTap;

  const DialogSuccess(
      {super.key, required this.bodyText, required this.buttonText, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsetsDirectional.only(
                top: 16,
                start: 17,
                end: 17,
                bottom: 10,
              ),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: sccGreen,
              ),
              child: Icon(
                Icons.check,
                size: context.scaleFont(50),
                color: sccWhite,
              )),
          Container(
            margin: const EdgeInsetsDirectional.only(
              top: 16,
              start: 17,
              end: 17,
              bottom: 16,
            ),
            child: SelectableText(
              bodyText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: context.scaleFont(15),
                  color: const Color(0xFF232020)),
            ),
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(
              start: 17,
              end: 17,
              bottom: 10,
            ),
            child: ButtonConfirm(
              text: buttonText,
              width: MediaQuery.of(context).size.width / 2.1,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String? message;
  final bool isSuccess;
  final List<Widget> btnAction;

  const CustomAlertDialog({
    Key? key,
    required this.btnAction,
    this.message,
    required this.isSuccess,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        margin: const EdgeInsetsDirectional.only(
          top: 20,
          start: 17,
          end: 17,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSuccess
                ? Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: sccGreen,
                    ),
                    child: Icon(
                      Icons.check,
                      size: context.scaleFont(50),
                      color: sccWhite,
                    ))
                : Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: sccDanger,
                    ),
                    child: Icon(
                      Icons.priority_high,
                      size: context.scaleFont(50),
                      color: sccWhite,
                    )),
            Container(
              margin: const EdgeInsetsDirectional.only(
                top: 16,
                bottom: 16,
              ),
              child: SelectableText(
                message ?? '-',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: context.scaleFont(15),
                    color: const Color(0xFF232020)),
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(
                bottom: 10,
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: btnAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

alertDialogLogout(BuildContext context, Function() onLogout) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: context.isDesktop()
            ? EdgeInsets.symmetric(
                horizontal: (context.deviceWidth() * 0.3),
                vertical: (context.deviceHeight() * 0.25),
              )
            : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: SizedBox(
          child: Stack(
            children: [
              Container(
                padding: isMobile
                    ? const EdgeInsets.only(
                        left: 8, right: 8, top: 28, bottom: 12)
                    : const EdgeInsets.all(16),
                margin: isMobile
                    ? const EdgeInsets.symmetric(horizontal: 12)
                    : const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: sccWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: context.deviceWidth() / 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            context.closeDialog();
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            // color: sccRed,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                color: sccWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(
                                      5.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ),
                                ]),
                            child: HeroIcon(
                              HeroIcons.xMark,
                              color: sccButtonPurple,
                              size: context.scaleFont(28),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GradientWidget(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          sccButtonLightBlue,
                          sccButtonBlue,
                        ],
                      ),
                      child: SelectableText(
                        "Log Out?",
                        style: TextStyle(
                          color: sccBlack,
                          fontSize: context.scaleFont(20),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: isMobile ? (context.deviceHeight() * 0.04) : 5,
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.only(
                        top: 10,
                        start: 20,
                        end: 20,
                      ),
                      child: SelectableText(
                        'Are you sure you want to log out from\nSupply Chain Connectivity?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            color: sccBlack,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    // SizedBox(
                    //   height: context.deviceHeight() * 0.05,
                    // ),
                    Container(
                      margin: const EdgeInsetsDirectional.only(
                        top: 40,
                        start: 20,
                        end: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ButtonCancel(
                              text: 'Cancel',
                              onTap: () {
                                context.back();
                                // locator<NavigatorService>().goBack();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ButtonConfirm(
                              text: 'Yes, sign out',
                              onTap: () {
                                context.back();
                                // locator<NavigatorService>().goBack();
                                onLogout();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: isMobile ? 18 : context.deviceHeight() * 0.03,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
