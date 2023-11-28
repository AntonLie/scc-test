// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/login/bloc/login_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/route_generator.dart';

import 'package:scc_web/model/login.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';

import 'package:scc_web/theme/colors.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({
    Key? key,
  }) : super(key: key);

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final GlobalKey<FormState> loginKey = GlobalKey();
  late TextEditingController usernameCo, passwordCo;
  FocusNode focusUsername = FocusNode();
  FocusNode focusPassword = FocusNode();
  String encode = '';
  bool isLogin = false;
  bool obscure = true;
  bool validateUser = false;
  // bool userFocus = false;
  Color userColor = sccContainerTraceFIll;
  Color passColor = sccContainerTraceFIll;
  String validateUserText = '';
  bool validatePassword = false;
  // bool passFocus = false;
  String validatePasswordText = '';
  String superAdmin = "";

  Login model = Login();

  @override
  void initState() {
    usernameCo = TextEditingController();
    passwordCo = TextEditingController();
    focusUsername.addListener(() {
      if (focusUsername.hasFocus) {
        setState(() {
          userColor = sccWhite;
        });
      } else {
        setState(() {
          userColor = sccFillLoginField;
        });
      }
    });

    focusPassword.addListener(() {
      if (focusPassword.hasFocus) {
        setState(() {
          passColor = sccWhite;
        });
      } else {
        setState(() {
          passColor = sccFillLoginField;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc(LoginEvent event) {
      BlocProvider.of<LoginBloc>(context).add(event);
    }

    onSubmit() {
      setState(() {
        if (usernameCo.text.isEmpty) {
          validateUser = true;
          // validateUserText = "Username can't be blank";
        } else {
          validateUser = false;
          // validateUserText = "";
        }
        if (passwordCo.text.isEmpty) {
          validatePassword = true;
          // validatePasswordText = "Password can't be blank";
        } else {
          validatePassword = false;
          // validatePasswordText = "";
        }
      });
      if (loginKey.currentState!.validate()) {
        //(!validateUser && !validatePassword) {
        bloc(SubmitLogin(model));
      }
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccess) {
              String menuCd = "";
              if (state.listMenu.isNotEmpty) {
                Menu menu = state.listMenu.first;
                if (!(menu.menuTypeCd ?? "").toUpperCase().contains("PARENT")) {
                  menuCd = menu.menuCd ?? "";
                } else if ((menu.menuTypeCd ?? "")
                        .toUpperCase()
                        .contains("PARENT") &&
                    (menu.childs?.isNotEmpty == true)) {
                  menuCd = menu.childs?.first.menuCd ?? "";
                }
              }
              if (state.listSysMaster.isNotEmpty) {
                for (var e in state.listSysMaster) {
                  if (e.systemCd != null) {
                    superAdmin = e.systemValue ?? "UNKNOWN";
                  }
                }
              }
              if (usernameCo.text == superAdmin) {
                context.push(const SubscribersRoute());
              } else {
                // context.push(const TraceabilityRoute());
                // context.push(const MasterItemRoute());
                context.generateRoute(menuCd);
              }
            }
            if (state is LoginError) {
              showTopSnackBar(context, UpperSnackBar.error(message: state.msg));
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedIn) {
              if (!isLogin) {
                isLogin = true;
                context.push(const LoginRoute());
              }
            }
          },
        ),
      ],
      child: Form(
        key: loginKey,
        child: Container(
          color: const Color(0xffF8F9FE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width:
                      context.isDesktop() ? context.deviceWidth() * 0.1 : 130,
                  height:
                      context.isDesktop() ? context.deviceWidth() * 0.05 : 60,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: context.deviceHeight() * 0.65,
                padding: const EdgeInsets.all(25),
                margin: EdgeInsets.symmetric(
                    horizontal: context.deviceWidth() * 0.075),
                decoration: BoxDecoration(
                  color: sccWhite,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          "Sign in to account",
                          style: TextStyle(
                              fontSize: context.scaleFont(24),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          "Enter your username & password to login",
                          style: TextStyle(
                              fontSize: context.scaleFont(14), color: sccBlack),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: SelectableText(
                                  "Username",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                Constant
                                    .regExp, // Hanya huruf, angka, _, -, spasi, @, +, dan .
                              ),
                            ],
                            key: const Key("login_username"),
                            controller: usernameCo,
                            style: TextStyle(
                              fontSize: context.scaleFont(14),
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter username",
                              hintStyle: const TextStyle(color: sccHintText),
                              hoverColor: sccFillField,
                              filled: true,
                              fillColor:
                                  validateUser ? sccValidateField : userColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: sccButtonPurple, width: 1)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: sccDanger)),
                            ),
                            cursorColor: sccButtonPurple,
                            focusNode: focusUsername,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Username can't be blank";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              model.username = value;
                            },
                            onFieldSubmitted: (value) => onSubmit(),
                          ),
                        ),
                        // SizedBox(height: validatePassword ? 0 : 12),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: SelectableText(
                                  "Password",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: context.scaleFont(14),
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          child: TextFormField(
                            key: const Key("login_password"),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                Constant
                                    .regExp, // Hanya huruf, angka, _, -, spasi, @, +, dan .
                              ),
                            ],
                            style: TextStyle(
                              fontSize: context.scaleFont(14),
                            ),
                            onFieldSubmitted: (value) => onSubmit(),
                            decoration: InputDecoration(
                              hintText: "********",
                              suffixIcon: model.password?.isNotEmpty == true
                                  ? SizedBox(
                                      width: 50,
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            obscure = !obscure;
                                          });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 16),
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            obscure ? "Show" : "Hide",
                                            style: TextStyle(
                                              fontSize: context.scaleFont(12),
                                              fontWeight: FontWeight.w100,
                                              color: sccButtonPurple,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                              hintStyle: const TextStyle(color: sccHintText),
                              filled: true,
                              hoverColor: sccFillField,
                              fillColor: validatePassword
                                  ? sccValidateField
                                  : passColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: sccButtonPurple, width: 1)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: sccDanger)),
                            ),
                            cursorColor: sccButtonPurple,
                            obscureText: obscure,
                            controller: passwordCo,
                            focusNode: focusPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password can't be blank";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                model.password = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: validateUser && validatePassword ? 0 : 8,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              context.push(ForgotPasswordRoute());
                              // context.push(ForgotPasswordRoute());
                            },
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontSize: context.scaleFont(12),
                                fontWeight: FontWeight.w600,
                                color: sccNavText2,
                              ),
                            ),
                            // child: ShaderMask(
                            //   blendMode: BlendMode.srcIn,
                            //   shaderCallback: (Rect bounds) {
                            //     return LinearGradient(
                            //       begin: Alignment.topCenter,
                            //       end: Alignment.bottomCenter,
                            //       colors: [
                            //         sccNavText2,
                            //         sccNavText2,
                            //       ],
                            //     ).createShader(bounds);
                            //   },
                            //   child: Text(
                            //     "Forgot Password",
                            //     style: TextStyle(
                            //       fontSize: context.scaleFont(14),
                            //       fontWeight: FontWeight.w800,
                            //     ),
                            //   ),
                            // ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 20),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            if (state is LoginLoading) {
                              return const Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => onSubmit(),
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    height: context.deviceHeight() *
                                        0.065, //MediaQuery.of(context).size.height * 0.07,
                                    decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //   begin: Alignment.topCenter,
                                      //   end: Alignment.bottomCenter,
                                      //   colors: [
                                      //     sccButtonLightBlue,
                                      //     sccButtonBlue,
                                      //   ],
                                      // ),
                                      color: sccButtonPurple,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: sccLightGray.withOpacity(0.5),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                          offset: const Offset(
                                              4, 4), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                            fontSize: context.scaleFont(16),
                                            color: sccWhite,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        // SizedBox(height: 12),
                        // Row(
                        //   children: [
                        //     SelectableText(
                        //       "Don't have account?",
                        //       style: TextStyle(fontSize: context.scaleFont(14), color: sccText2),
                        //     ),
                        //     SizedBox(width: 4),
                        //     SelectableText(
                        //       "Create Account",
                        //       style: TextStyle(fontSize: context.scaleFont(14), color: sccNavText2, fontWeight: FontWeight.w600),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
