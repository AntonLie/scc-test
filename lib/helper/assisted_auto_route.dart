import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension Routers on BuildContext {
  dynamic replaceNamed(String path) => AutoRouter.of(this).replaceNamed(path);
  Future pushNamed(String route) => AutoRouter.of(this).pushNamed(route);
  Future push(PageRouteInfo<dynamic> route) async {
    if (kIsWeb) {
      (this).replaceRoute(route);
    } else {
      (this).pushRoute(route);
    }
  }

  Future back([dynamic val]) => AutoRouter.of(this).pop(val);
  closeDialog([dynamic val]) => Navigator.of(this).pop(val);
  dynamic pushNamedWithParam(String route, Map<String, String> map) {
    String url = route.fillParam(map);
    AutoRouter.of(this).pushNamed(url);
  }
}

extension Param on String {
  String fillParam(Map<String, String> param) {
    String url = this;
    int count = 0;
    if (!url.endsWith('?')) {
      url = '$url?';
    }
    param.forEach((key, value) {
      if (count == 0) {
        url = '$url$key=$value';
        count++;
      } else {
        url = '$url&$key=$value';
      }
    });
    return url;
  }
}
