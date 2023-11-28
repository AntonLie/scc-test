import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/locator.dart';

import 'package:scc_web/theme/colors.dart';

void main() async {
  await dotenv.load(fileName: "assets/web.env");
  setupLocator();
  debugRepaintRainbowEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Constant(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = locator<AppRouter>();

    return Portal(
      child: MaterialApp.router(
        routeInformationParser: route.defaultRouteParser(),
        routerDelegate: AutoRouterDelegate(route),
        debugShowCheckedModeBanner: false,
        title: 'SCC WEB',
        theme: ThemeData(
          fontFamily: 'toyota',
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hintColor: sccText4,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id'),
        ],
      ),
    );
  }
}
