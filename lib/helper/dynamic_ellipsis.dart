import 'package:flutter/material.dart';

///* returns size taken by the text in the UI
double getTextSize(String text, TextStyle style, BuildContext context) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
    maxLines: 1,
  )..layout();
  return textPainter.width;
}

///* returns text with or without ellipsis which can be fit in the chip/container
String dynamicEllipsis(BuildContext context, double width, String text, TextStyle style) {
  if (getTextSize(
        text,
        style,
        context,
      ) <
      width) {
    return text;
  }
  const ellipsisText = '...';
  final maxWidthThreshold = width -
      getTextSize(
        ellipsisText,
        style,
        context,
      );
  String selectedTrimmedText = '';
  for (var i = 1; i <= text.length; i++) {
    final trimmedText = text.substring(0, i);
    if (getTextSize(
          trimmedText,
          style,
          context,
        ) <
        maxWidthThreshold) {
      selectedTrimmedText = trimmedText;
    } else {
      break;
    }
  }
  return '$selectedTrimmedText$ellipsisText';
}
