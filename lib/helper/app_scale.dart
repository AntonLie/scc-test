import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'constant.dart' as cons;

extension Scaler on BuildContext {
  double scaleFont(double initialFontSize) {
    return isDesktop()
        ? initialFontSize
        : (MediaQuery.of(this).size.width * 0.0027) * scaler(initialFontSize);
  }

  double dynamicFont(double initialFontSize) {
    return (MediaQuery.of(this).size.width * 0.0027) * scaler(initialFontSize);
  }

  double scaleHeight(double initialHeight) {
    return (MediaQuery.of(this).size.height * 0.0011) * scaler(initialHeight);
  }

  double deviceWidth() {
    return (MediaQuery.of(this).size.width);
  }

  double deviceHeight() {
    return (MediaQuery.of(this).size.height);
  }

  bool isMobile() {
    return cons.isMobile ||
        cons.isWebMobile ||
        MediaQuery.of(this).size.width < 650;
  }

  bool isTablet() {
    return MediaQuery.of(this).size.width < 900 &&
        MediaQuery.of(this).size.width >= 650;
  }

  bool isWideScreen() {
    return MediaQuery.of(this).size.width >= 900;
  }

  bool isFullScreen() {
    return MediaQuery.of(this).size.width >= 1200;
  }

  bool isDesktop() {
    return (kIsWeb && !(cons.isWebMobile)) ||
        MediaQuery.of(this).size.width >= 900;
  }
}

double scaler(double x) {
  if (kIsWeb &&
      !(defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android)) {
    return x * 0.25;
  } else {
    return x;
  }
}

extension Modifier on num {
  double get wh {
    if (kIsWeb &&
        !(defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)) {
      return this * 2.5;
    } else {
      return (this).toDouble();
    }
  }
}
