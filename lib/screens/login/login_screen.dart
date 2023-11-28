import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/login/bloc/login_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/screens/login/login_card.dart';
import 'package:scc_web/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      // resizeToAvoidBottomInset: false,

      body: LoginBody(),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => SizedBox(
            height: context.deviceHeight(),
            width: context.deviceWidth(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: (context.deviceHeight() * 0.125)),
                          child: Column(
                            children: [
                              Text(
                                "Welcome to Supplychain Connectivity",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: context.scaleFont(24),
                                  color: sccButtonPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Build a safety culture for sustainable supply chain",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: context.scaleFont(14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => LoginBloc(),
                        ),
                        BlocProvider(
                            create: (context) => AuthBloc()..add(AuthLogin()))
                      ],
                      child: const LoginCard(
                        key: Key("login_card"),
                      )),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
