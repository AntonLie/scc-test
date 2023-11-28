import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/screens/forgot_password/forgot_password_card.dart';
import 'package:scc_web/shared_widgets/mouse_region_span.dart';
import 'package:scc_web/theme/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Constant.landscape_login_blur),
          fit: BoxFit.cover,
        ),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: ForgotPasswordBody(),
      ),
    );
  }
}

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordBodyState createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  Future<bool> onBackPressed() {
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onBackPressed,
      // child: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal:
                context.isDesktop() ? (context.deviceWidth() * 0.2) : 12,
            vertical:
                context.deviceHeight() * (context.isDesktop() ? 0.1 : 0.15)),
        height: deviceSize.height,
        width: deviceSize.width,
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: sccWhite,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: context.isWideScreen(),
              child: Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 24, top: 24, bottom: 24, right: 0),
                  child: Image.asset(
                    Constant.vcc_potrait_bg_login,
                    height: context.deviceHeight(),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: isMobile
                    ? const EdgeInsets.all(8)
                    : const EdgeInsets.symmetric(horizontal: 48, vertical: 5),
                margin: EdgeInsets.zero,
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: context.isDesktop()
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.spaceAround,
                      children: [
                        // Container(
                        //   alignment: Alignment.topLeft,
                        //   width: context.isDesktop()
                        //       ? context.deviceWidth() * 0.1
                        //       : 130,
                        //   height: context.isDesktop()
                        //       ? context.deviceWidth() * 0.05
                        //       : 60,
                        //   child: Image.asset(
                        //     'assets/TMMIN.png',
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                children: [
                                  MouseRegionSpan(
                                    mouseCursor: SystemMouseCursors.basic,
                                    inlineSpan: TextSpan(
                                      text: 'Back to ',
                                      style: TextStyle(
                                        fontSize: context.scaleFont(16),
                                        // color: sccBlue,
                                      ),
                                    ),
                                  ),
                                  // TextSpan(
                                  //   text: 'Back to ',
                                  //   style: TextStyle(
                                  //     fontSize: context.scaleFont(16),
                                  //   ),
                                  // ),
                                  MouseRegionSpan(
                                    mouseCursor: SystemMouseCursors.click,
                                    inlineSpan: TextSpan(
                                      text: 'Sign In',
                                      style: TextStyle(
                                        fontSize: context.scaleFont(16),
                                        color: sccBlue,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          context.push(const LoginRoute());
                                        },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   flex: 7,
                        //   child: Container(
                        //     padding: EdgeInsets.only(left: 30.wh),
                        //     child: Text(
                        //       "Back to",
                        //       style: TextStyle(fontSize: context.scaleFont(16)),
                        //     ),
                        //   ),
                        // ),
                        // Expanded(
                        //   flex: 5,
                        //   child: Container(
                        //     padding: EdgeInsets.only(left: 5.wh),
                        //     child: InkWell(
                        //       onTap: () {
                        //         context.push(LoginRoute());
                        //       },
                        //       child: Text(
                        //         "Sign In",
                        //         style: TextStyle(
                        //           fontSize: context.scaleFont(16),
                        //           // fontStyle: n,
                        //           color: sccBlue,
                        //           // decoration: TextDecoration.underline,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const ForgotPasswordCard(),
                      // child: BlocProvider(
                      //   create: (context) => PasswordBloc(),
                      //   child: ForgotPasswordCard(),
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
