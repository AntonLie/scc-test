import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
// import 'package:universal_html/js.dart' as js;
import 'package:universal_html/html.dart' as html;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${(this).substring(1).toLowerCase()}";
  }
}

fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

// Future<bool> onBackPressedToHome() async {
//   locator<NavigatorService>().navigateReplaceTo(Constant.MENU_DASHBOARD_TMMIN);
//   return true;
// }

String dateNowyyyyMMddHHmmss() {
  var date = DateTime.now();
  var formatter = DateFormat('yyyyMMddHHmmss');
  String formatted = formatter.format(date);
  // print(formatted);
  return formatted;
}

///* returns bool
bool validateEmails(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return !regex.hasMatch(value);
}

bool validatePhoneNo(String? phoneNo) {
  if (phoneNo == null) return false;
  final regExp = RegExp(r'(^(?:[+0])?[0-9\-])');
  return !regExp.hasMatch(phoneNo);
}

String convertDateToStringFormat(DateTime? date, String format) {
  if (date == null) return "";
  var formatter = DateFormat(format);
  return formatter.format(date);
}

String convertDateToString(DateTime? date) {
  if (date == null) return "";
  var formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(date);
}

DateTime? convertStringToDateFormatOrNull(String? sDate, String format) {
  var formatter = DateFormat(format);
  if (sDate == null) {
    return null;
  }
  try {
    int index = format.indexOf('MMM');
    if (index >= 0) {
      String mon = sDate.substring(index, (index + 3));
      String monC = mon.capitalize();
      sDate = sDate.replaceAll(mon, monC);
    }
    int i = format.indexOf('MMMM');

    if (i >= 0) {
      String mon = sDate.substring(i, (i + 4));
      String monC = mon.capitalize();
      sDate = sDate.replaceAll(mon, monC);
    }
    return formatter.parse(sDate);
  } catch (e) {
    // print(e);
    return null;
    // throw e.toString();
  }
}

DateTime convertStringToDateFormat(String sDate, String format) {
  var formatter = DateFormat(format);
  try {
    int index = format.indexOf('MMM');
    if (index >= 0) {
      String mon = sDate.substring(index, (index + 3));
      String monC = mon.capitalize();
      sDate = sDate.replaceAll(mon, monC);
    }
    int i = format.indexOf('MMMM');

    if (i >= 0) {
      String mon = sDate.substring(i, (i + 4));
      String monC = mon.capitalize();
      sDate = sDate.replaceAll(mon, monC);
    }
    return formatter.parse(sDate);
  } catch (e) {
    // print(e);
    throw e.toString();
  }
}

String localizeIsoDateStr(String? sDate) {
  DateTime? date;
  String output = "-";
  if (sDate != null) {
    date = DateTime.tryParse(sDate);
    output = sDate;
  }
  if (date != null) {
    output = convertDateToStringFormat(date.toLocal(), "dd MMM yyyy");
  }
  return output;
}

String strDateToStr(String? sDate,
    {required String? formatFrom, required String formatTo, bool? utc}) {
  DateTime? date;
  String output = "-";
  try {
    if (sDate != null) {
      date = DateFormat(formatFrom).parse(sDate, utc == true);
      output =
          DateFormat(formatTo).format((utc == true) ? date.toLocal() : date);
    }
  } catch (e) {
    return sDate ?? output;
  }

  return output;
}

DateTime convertStringToDate(String sDate) {
  var formatter = DateFormat('dd MMM yyyy');
  try {
    return formatter.parse(sDate);
  } catch (e) {
    throw e.toString();
  }
}

abstract class NotificationLocalHandler {
  Future<void> onSelectNotification(String json);
  //Future<void> showNotification(Map<String, dynamic> data);
}

String formatHHMMSS(int seconds) {
  int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  if (hours == 0) {
    return "$minutesStr:$secondsStr";
  }

  return "$hoursStr:$minutesStr:$secondsStr";
}

int calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

String dateTimeHhmm(DateTime dateTime) {
  String formattedDate = DateFormat('HH:mm').format(dateTime);
  return formattedDate;
}

String timeOfDayHHmm(TimeOfDay? tod) {
  if (tod == null) {
    return "";
  }
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  return dateTimeHhmm(dt);
}

String dateTimeHhmmss(DateTime dateTime) {
  String formattedDate = DateFormat('HH:mm:ss').format(dateTime);
  return formattedDate;
}

String timeOfDayHHmmss(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  return dateTimeHhmmss(dt);
}

extension NumberExtract on String? {
  String get number {
    String number = "0";
    if (this == null || this!.isEmpty) {
      return number;
    } else {
      number = this!.replaceAll(RegExp(r'[^0-9]'), '');
      return number.isEmpty ? "0" : number;
    }
  }

  String get decimalRpFilter {
    String number = "";

    number = this!.replaceAll(RegExp(r'[^0-9\,]'), '').replaceAll(",", ".");
    return number;
  }

  String get decimalRpFormatter {
    String number = "0";
    if (this == null || this!.isEmpty) {
      return number;
    } else {
      number = this!.replaceAll(RegExp(r'[^0-9\,]'), '');
      return (number.isEmpty ? "0" : number);
    }
  }

  String get numberFilter {
    String number = "";
    if (this == null || this!.isEmpty) {
      return number;
    } else {
      number = this!.replaceAll(RegExp(r'[^0-9]'), '');
      return number;
    }
  }
}

///Alpha-Numeric restrictions
extension AlNumRestrict on String? {
  String get alNum {
    String alNum = "";
    if (this == null || this!.isEmpty) {
      return alNum;
    } else {
      alNum = this!.replaceAll(RegExp(r"[^\s\w]"), '');
      return alNum.isEmpty ? "0" : alNum;
    }
  }
}

String convertToTitleCase(String? text) {
  if (text == null) {
    return "";
  }

  if (text.length <= 1) {
    return text.toUpperCase();
  }

  // Split string into multiple words
  final List<String> words = text.split(' ');

  // Capitalize first letter of each words
  final capitalizedWords = words.map((word) {
    if (word.trim().isNotEmpty) {
      final String firstLetter = word.trim().substring(0, 1).toUpperCase();
      final String remainingLetters = word.trim().substring(1).toLowerCase();

      return '$firstLetter$remainingLetters';
    }
    return '';
  });

  // Join/Merge all words back to one String
  return capitalizedWords.join(' ');
}

extension CapitalizedStringExtension on String {
  String get capitalizeEachWords {
    return convertToTitleCase(this);
  }
}

extension DateUtil on DateTime {
  DateTime get getMonday {
    return DateTime(
        (this).year, (this).month, (this).day - ((this).weekday - 1));
  }

  DateTime get getSunday {
    DateTime monday = (this).getMonday;
    return DateTime(monday.year, monday.month, monday.day + 6);
  }
}

bool validateCode(String? key) {
  if (key == null) return false;
  final regExp = RegExp(r'^[a-zA-Z0-9\-\_]*$');
  return !regExp.hasMatch(key);
}

bool validateApiKey(String? key) {
  if (key == null) return false;
  final regExp = RegExp(r'^[a-zA-Z0-9]*$');
  return !regExp.hasMatch(key);
}

///*Doesn't need to include special chars
///*allowed chars = !,@,#,$,%,^,&,*
bool validatePassword(String? pass) {
  if (pass == null) return false;
  final regExp =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})');
  return !regExp.hasMatch(pass);
}

///*Must include special chars
///*allowed chars = !,@,#,$,&,*,~
validateSpecPassword(String? pass) {
  if (pass == null) return false;
  final regExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  return !regExp.hasMatch(pass);
}

String camelToSentence(String? text) {
  if (text == null || text.isEmpty) return "-";
  var result = text.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), r" ");
  var finalResult = result[0].toUpperCase() + result.substring(1);
  return finalResult;
}

launchUrl({required String? url, bool? isNewTab}) {
  // js.context.callMethod('open', [url ?? "", (isNewTab == true) ? '_blank' : '_self']);
  html.window.open(url ?? "", (isNewTab == true) ? '_blank' : '_self');
}

toggleFullScreen(BuildContext context) {
  if (html.document.documentElement != null &&
      !isFullscreen(context) &&
      !isMobile) {
    html.document.documentElement!.requestFullscreen();
  } else {
    html.document.exitFullscreen();
  }
}

bool isFullscreen(BuildContext context) {
  double windowHeight = context.deviceHeight();
  double windowWidth = context.deviceWidth();
  double screenHeight = html.window.screen?.height?.toDouble() ?? 0;
  double screenWidth = html.window.screen?.width?.toDouble() ?? 0;
  return (screenWidth == windowWidth) && (screenHeight == windowHeight);
}

String fractionNumber(double number) {
  double simpleNumber = number.abs();

  if (simpleNumber > 1000000000000) {
    return "${((number / 1000000000000) % 1 == 0)
            ? (number / 1000000000000).toString()
            : (number / 1000000000000).toStringAsFixed(1)} T";
  }

  if (simpleNumber > 1000000000) {
    return "${((number / 1000000000) % 1 == 0)
            ? (number / 1000000000).toString()
            : (number / 1000000000).toStringAsFixed(1)} B";
  }

  if (simpleNumber > 1000000) {
    return "${((number / 1000000) % 1 == 0)
            ? (number / 1000000).toString()
            : (number / 1000000).toStringAsFixed(1)} M";
  }
  if (simpleNumber > 1000) {
    return "${((number / 1000) % 1 == 0)
            ? (number / 1000).toString()
            : (number / 1000).toStringAsFixed(1)} K";
  }
  // if (simpleNumber < 1000000000000000) return 15;
  return ((number % 1 == 0) ? number.toString() : number.toStringAsFixed(1));
}

Color stringToColor(String? hexString) {
  if (hexString == null) {
    return const Color(0xff000000);
  } else {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return const Color(0xff000000);
    }
  }
}

String mapUrlTail(String? menuCd) {
  switch (menuCd) {
    case Constant.login:
      return '/login';
    // break;
    case Constant.dashboard:
      return '/home';
    // break;
    case Constant.admin:
      return '/master-admin';
    // break;
    case Constant.attributes:
      return '/master-attribute';
    // break;
    case Constant.menu:
      return '/master-menu';

    default:
      return "";
  }
}

