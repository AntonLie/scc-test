import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/theme/colors.dart';

class ResetNewPassScreen extends StatefulWidget {
  const ResetNewPassScreen({Key? key}) : super(key: key);

  @override
  _ResetNewPassScreenState createState() => _ResetNewPassScreenState();
}

class _ResetNewPassScreenState extends State<ResetNewPassScreen> {
  Map<String, dynamic> queryParam = {};
  @override
  void initState() {
    queryParam.addAll(Uri.dataFromString(Uri.base.toString()).queryParameters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sccWhite,
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            // BlocProvider(
            //   create: (context) => PasswordBloc(),
            // ),
          ],
          child: ResetNewPassBody(
            param: queryParam,
          ),
        ),
      ),
    );
  }
}

class ResetNewPassBody extends StatefulWidget {
  final Map<String, dynamic> param;
  const ResetNewPassBody({required this.param, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ResetNewPassBodyState createState() => _ResetNewPassBodyState();
}

class _ResetNewPassBodyState extends State<ResetNewPassBody> {
  final resetPassCo = ScrollController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  Map<String, dynamic> param = {};
  String token = "";
  String actionType = "";
  String newPassword = "";
  String confirmPassword = "";

  bool newPassObscure = true;
  bool confirmPassObscure = true;

  late TextEditingController newPassCo;
  late TextEditingController confirmPassCo;

  // late FocusNode focusNewPass;
  // late FocusNode focusConfirmPass;

  @override
  void initState() {
    param.addAll(widget.param);
    token = param['token'] ?? "";
    actionType = param['actionType'] ?? "";
    newPassCo = TextEditingController();
    confirmPassCo = TextEditingController();

    // focusNewPass = FocusNode();
    // focusConfirmPass = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bloc(PasswordEvent event) {
    //   BlocProvider.of<PasswordBloc>(context).add(event);
    // }

    return SizedBox(
      width: context.deviceWidth(),
      child: Scrollbar(
        controller: resetPassCo,
        child: SingleChildScrollView(
          controller: resetPassCo,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 24.wh,
              ),
              CircleAvatar(
                maxRadius:
                    context.deviceWidth() * (context.isDesktop() ? 0.04 : 0.08),
                backgroundColor: sccBackground,
                child: HeroIcon(
                  HeroIcons.key,
                  color: sccAmber,
                  size: context.deviceWidth() *
                      (context.isDesktop() ? 0.03 : 0.07),
                ),
              ),
              SizedBox(
                height: 12.wh,
              ),
              SelectableText(
                "Create a Password",
                maxLines: 1,
                style: TextStyle(
                  fontSize: context.scaleFont(20),
                  color: sccBlue,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.clip,
                ),
              ),
              SizedBox(
                height: 12.wh,
              ),
              Container(
                width: context.deviceWidth() / (context.isDesktop() ? 3 : 1),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Form(
                  key: key,
                  child: FocusTraversalGroup(
                    descendantsAreFocusable: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          "Password",
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              Constant.regExp, // Hanya huruf, angka, _, -, spasi, @, +, dan .
                            ),
                          ],
                          style: TextStyle(
                            fontSize: context.scaleFont(12),
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            suffixIcon: IconButton(
                              splashRadius: 20,
                              onPressed: () {
                                setState(() {
                                  newPassObscure = !newPassObscure;
                                });
                              },
                              icon: Icon(
                                newPassObscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: sccHintText,
                                size: context.scaleFont(20),
                              ),
                              color: sccHintText,
                            ),
                            hintText: 'Input Text',
                            hintStyle: const TextStyle(color: sccHintText),
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: sccHintText),
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: sccHintText,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          obscureText: newPassObscure,
                          controller: newPassCo,
                          // focusNode: focusNewPass,
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Please fill your password"
                              : null,
                          onChanged: (value) {
                            newPassword = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        SelectableText(
                          "Confirm Password",
                          style: TextStyle(
                            fontSize: context.scaleFont(16),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          style: TextStyle(
                            fontSize: context.scaleFont(12),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              Constant.regExp, // Hanya huruf, angka, _, -, spasi, @, +, dan .
                            ),
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            // suffixIcon: IconButton(
                            //   splashRadius: 20,
                            //   onPressed: () {
                            //     setState(() {
                            //       confirmPassObscure = !confirmPassObscure;
                            //     });
                            //   },
                            //   icon: Icon(
                            //     confirmPassObscure
                            //         ? Icons.visibility_outlined
                            //         : Icons.visibility_off_outlined,
                            //     color: sccHintText,
                            //     size: context.scaleFont(20),
                            //   ),
                            //   color: sccHintText,
                            // ),
                            hintText: 'Input Text',
                            hintStyle: const TextStyle(color: sccHintText),
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: sccHintText),
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: sccHintText,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          obscureText: confirmPassObscure,
                          controller: confirmPassCo,
                          // focusNode: focusConfirmPass,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            } else if (value != newPassword) {
                              return "Password didn't match";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            confirmPassword = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24.wh,
              ),
              // BlocBuilder<PasswordBloc, PasswordState>(
              //   builder: (context, state) {
              //     if (state is PasswordLoading) {
              //       return Align(
              //         alignment: Alignment.center,
              //         child: CircularProgressIndicator(),
              //       );
              //     } else {
              //       return Container(
              //         width: context.deviceWidth() /
              //             (context.isDesktop() ? 3 : 1.6),
              //         padding: const EdgeInsets.symmetric(horizontal: 4),
              //         child: TextButton(
              //           onPressed: () {
              //             if (key.currentState!.validate() &&
              //                 token.isNotEmpty &&
              //                 actionType.isNotEmpty) {
              //               // bloc(ResetPasswordSubmit(
              //               //     actionType: actionType,
              //               //     confirmPassword: confirmPassword,
              //               //     newPassword: newPassword,
              //               //     token: token));
              //             }
              //           },
              //           child: Container(
              //             margin: const EdgeInsets.symmetric(vertical: 13),
              //             child: FittedBox(
              //               child: SelectableText(
              //                 "Sign In",
              //                 style: TextStyle(
              //                     fontSize: context.scaleFont(16),
              //                     color: sccWhite,
              //                     fontWeight: FontWeight.bold),
              //                 maxLines: 1,
              //               ),
              //             ),
              //           ),
              //           style: TextButton.styleFrom(
              //             backgroundColor: sccPrimary,
              //             shape: RoundedRectangleBorder(
              //                 side: BorderSide(color: sccPrimary, width: 1.8),
              //                 borderRadius: BorderRadius.circular(8)),
              //           ),
              //         ),
              //         decoration: BoxDecoration(
              //           boxShadow: [
              //             BoxShadow(
              //               color: sccLightGray.withOpacity(0.5),
              //               blurRadius: 8,
              //               offset: Offset(4, 4), // Shadow position
              //             ),
              //           ],
              //         ),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
