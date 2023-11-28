import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';

class ForgotPasswordCard extends StatefulWidget {
  const ForgotPasswordCard({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordCardState createState() => _ForgotPasswordCardState();
}

class _ForgotPasswordCardState extends State<ForgotPasswordCard> {
  final GlobalKey<FormState> forgotPasswordKey = GlobalKey();
  late TextEditingController usernameCo;
  String username = "";
  bool validateUser = false;
  String validateUserText = "";

  @override
  void initState() {
    usernameCo = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bloc(PasswordEvent event) {
    //   BlocProvider.of<PasswordBloc>(context).add(event);
    // }

    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(horizontal: 1.wh),
      child: Form(
        key: forgotPasswordKey,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SelectableText(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: context.scaleFont(30),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topLeft,
              child: SelectableText(
                "Please enter your username and we will send the password reset instructions to your email",
                // "Please input the email associated to your account and we'll",
                style: TextStyle(
                  fontSize: context.scaleFont(14),
                ),
              ),
            ),
            // SizedBox(height: 10),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: SelectableText(
            //     "send you instructions to reset your password",
            //     style: TextStyle(
            //       fontSize: context.scaleFont(12),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: SelectableText(
                      "Username",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: context.scaleFont(12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                // Visibility(
                //   visible: validateUser,
                //   child: Expanded(
                //     flex: 2,
                //     child: Container(
                //       alignment: Alignment.centerRight,
                //       child: SelectableText(
                //         validateUserText,
                //         style: TextStyle(
                //           fontSize: context.scaleFont(13),
                //           color: sccWarningText,
                //           overflow: TextOverflow.ellipsis,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            CustomFormTextField(
                controller: usernameCo,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: sccFillLoginField),
                ),
                fillColor: sccFillField,
                // inputType: TextInputType.emailAddress,
                onChanged: (value) {
                  username = value ?? "";
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username can't be blank";
                  } else {
                    return null;
                  }
                },
                onAction: (value) {
                  forgotPasswordKey.currentState!.validate();
                }),
            // TextFormField(
            //   controller: usernameCo,
            //   style: TextStyle(
            //     fontSize: context.scaleFont(12),
            //   ),
            //   decoration: InputDecoration(
            //     isDense: true,
            //     hintStyle: TextStyle(
            //       color: sccHintText,
            //     ),
            //     filled: true,
            //     fillColor:
            //         validateUser ? sccValidateField : sccFillLoginField,
            //     border: OutlineInputBorder(
            //       borderSide: validateUser
            //           ? BorderSide(color: Color(0xffF03D3E), width: 1)
            //           : BorderSide.none,
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //         borderSide: validateUser
            //             ? BorderSide(color: Color(0xffF03D3E), width: 1)
            //             : BorderSide.none,
            //         borderRadius: BorderRadius.circular(5)),
            //     enabledBorder: OutlineInputBorder(
            //         borderSide: validateUser
            //             ? BorderSide(color: Color(0xffF03D3E), width: 1)
            //             : BorderSide.none,
            //         borderRadius: BorderRadius.circular(5)),
            //   ),
            //   keyboardType: TextInputType.emailAddress,
            //   // validator: (value) => (value == null || value.isEmpty)
            //   //     ? "Please fill your username"
            //   //     : null,
            //   onChanged: (value) {
            //     username = value;
            //   },
            //   onFieldSubmitted: (value) {
            //     forgotPasswordKey.currentState!.validate();
            //   },
            // ),
            const SizedBox(
              height: 30,
            ),
            ButtonConfirm(
              text: 'Send Reset Instructions',
              verticalMargin: 4,
              height: context.deviceHeight() * 0.065,
              onTap: () {
                if (forgotPasswordKey.currentState!.validate()) {
                  // bloc(SendForgetEmail(username));
                }
              },
              borderRadius: 8,
              width: context.deviceWidth(),
            )
          ],
        ),
      ),
    );
  }
}
