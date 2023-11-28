import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/package/bloc/package_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';

import 'package:scc_web/screens/register_product/feature_container.dart';
import 'package:scc_web/screens/register_product/plan_container.dart';


import 'package:scc_web/shared_widgets/success_dialog.dart';
import 'package:scc_web/theme/colors.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackageBloc(),
      child: const Scaffold(backgroundColor: sccWhite, body: MainHomeBody()),
    );
  }
}

class MainHomeBody extends StatefulWidget {
  const MainHomeBody({Key? key}) : super(key: key);

  @override
  State<MainHomeBody> createState() => _MainHomeBodyState();
}

class _MainHomeBodyState extends State<MainHomeBody> {
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    adminContacted() {
      showDialog(
        context: context,
        builder: (ctx) {
          return SuccessDialog(
            title: "Success !",
            msg: "Admin successfully contacted",
            buttonText: "OK",
            onTap: () => context.closeDialog(),
          );
        },
      );
    }

    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
          
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "How Supply Chain Connectivity can",
                  style: TextStyle(
                      fontSize: context.scaleFont(48),
                      fontFamily: 'toyota',
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Improve your operational performance",
                  style: TextStyle(
                      color: sccButtonBlue,
                      fontSize: context.scaleFont(48),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'toyota'),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: context.deviceWidth() * 0.5,
                      height: context.deviceHeight() * 0.6,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Constant.bgToch),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        width: context.deviceWidth() * 0.2,
                        height: context.deviceHeight() * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: sccButtonBlue,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Supply Chain Connectivity",
                                style: TextStyle(
                                    color: sccWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: context.scaleFont(18),
                                    fontFamily: 'toyota'),
                              ),
                            ),
                            Text(
                              " Supply Chain Connectivity platform acts as a control tower",
                              maxLines: 5,
                              style: TextStyle(
                                  color: sccWhite,
                                  fontSize: context.scaleFont(14),
                                  fontFamily: 'toyota'),
                            )
                          ],
                        ))
                  ],
                ),
                Container(
                  width: context.deviceWidth(),
                  decoration: BoxDecoration(
                    color: isMobile ? Colors.transparent : sccWhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      isMobile ? EdgeInsets.zero : const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Powerful features for ",
                            style: TextStyle(
                                color: sccBlack,
                                fontSize: context.scaleFont(48),
                                fontFamily: 'toyota'),
                          ),
                          Text(
                            "powerful",
                            style: TextStyle(
                                color: sccButtonBlue,
                                fontSize: context.scaleFont(48),
                                fontFamily: 'toyota'),
                          )
                        ],
                      ),
                      Text(
                        "performance",
                        style: TextStyle(
                            color: sccButtonBlue,
                            fontSize: context.scaleFont(48),
                            fontFamily: 'toyota'),
                      ),
                      Text(
                        "choose a plan that's right for you",
                        style: TextStyle(
                            color: sccBlack,
                            fontSize: context.scaleFont(20),
                            fontFamily: 'toyota'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PricingBody(
                        adminContacted: () {
                          adminContacted();
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: context.deviceWidth() * 0.2,
                        height: context.deviceHeight() * 0.055,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(31),
                          ),
                          color: sccButtonBlue,
                        ),
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                useRootNavigator: false,
                                builder: (context) {
                                  return FeatureContainer(
                                    adminContacted: () {
                                      adminContacted();
                                    },
                                  );
                                },
                              );
                            },
                            child: Text(
                              "View All Comparation",
                              style: TextStyle(
                                color: sccWhite,
                                fontSize: context.scaleFont(18),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
