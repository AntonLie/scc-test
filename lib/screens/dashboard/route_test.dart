import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_route.gr.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/shared_widgets/buttons.dart';

class RouteTestScreen extends StatelessWidget {
  const RouteTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Route Test"),
            ButtonConfirm(
              text: "back",
              width: context.deviceWidth() * 0.25,
              onTap: () {
                context.push(const DashboardRoute());
              },
            )
          ],
        ),
      ),
    );
  }
}
