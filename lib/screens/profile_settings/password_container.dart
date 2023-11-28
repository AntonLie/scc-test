import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/settings/bloc/settings_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/model/password.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/successcontainer.dart';
import 'package:scc_web/theme/colors.dart';

class ChangePassword extends StatefulWidget {
  final Function(String) onError, onSuccess;

  const ChangePassword(
      {super.key, required this.onError, required this.onSuccess});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  GlobalKey<FormState> passKey = GlobalKey<FormState>();
  late TextEditingController currPassCo;
  late TextEditingController newPassCo;
  late TextEditingController confirmPassCo;

  bool obscureCurr = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  Password model = Password();

  @override
  void initState() {
    currPassCo = TextEditingController();
    newPassCo = TextEditingController();
    confirmPassCo = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc(SettingsEvent event) {
      BlocProvider.of<SettingsBloc>(context).add(event);
    }

    onConfirm(Password val) {
      showDialog(
          context: context,
          builder: (context) {
            return ConfirmSaveDialog(
              allTitle: "Change Password",
              allValue: "Are you sure you want to change the password?",
              textBtn: "Yes, Update",
              onSave: () {
                bloc(SubmitChangePassword(model));
                context.closeDialog();
              },
            );
          });
    }

    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is ChangePassSubmit) {
          widget.onSuccess("Password Changed!");
        }
        if (state is SettingsError) {
          widget.onError(state.error);
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is ChangePassSubmit) {
            return const SuccessContainer(
              msg: "Password Changed Successfully!",
            );
          } else {
            return Container(
              padding: context.isDesktop()
                  ? const EdgeInsets.symmetric(vertical: 10, horizontal: 30)
                  : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Form(
                key: passKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SelectableText(
                        "Current Password",
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400,
                            color: sccText3),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      key: const Key("current_password"),
                      controller: currPassCo,
                      hint: 'Input Current Password',
                      validator: (value) => (value == null || value.isEmpty)
                          ? "This field is mandatory"
                          : null,
                      onChanged: (value) => model.currentPassword = value,
                      obscureText: obscureCurr,
                      maxLine: 1,
                      hoverColor: sccFillField,
                      suffix: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              sccButtonLightBlue,
                              sccButtonBlue,
                            ],
                          ).createShader(bounds);
                        },
                        child: IconButton(
                          // splashRadius: 15,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              obscureCurr = !obscureCurr;
                            });
                          },
                          icon: Icon(
                            obscureCurr
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: context.scaleFont(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SelectableText(
                        "New Password",
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400,
                            color: sccText3),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      key: const Key("new_password"),
                      controller: newPassCo,
                      hint: 'Input Password',
                      validator: (value) => (value == null || value.isEmpty)
                          ? "This field is mandatory"
                          : null,
                      onChanged: (value) => model.password = value,
                      obscureText: obscureNew,
                      maxLine: 1,
                      hoverColor: sccFillField,
                      suffix: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              sccButtonLightBlue,
                              sccButtonBlue,
                            ],
                          ).createShader(bounds);
                        },
                        child: IconButton(
                          // splashRadius: 15,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              obscureNew = !obscureNew;
                            });
                          },
                          icon: Icon(
                            obscureNew
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: context.scaleFont(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SelectableText(
                        "Confirm New Password",
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400,
                            color: sccText3),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      key: const Key("confirm_password"),
                      controller: confirmPassCo,
                      hint: 'Input Confirm Password',
                      validator: (value) => (value == null || value.isEmpty)
                          ? "This field is mandatory"
                          : null,
                      onChanged: (value) => model.confirmPassword = value,
                      obscureText: obscureConfirm,
                      maxLine: 1,
                      hoverColor: sccFillField,
                      suffix: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              sccButtonLightBlue,
                              sccButtonBlue,
                            ],
                          ).createShader(bounds);
                        },
                        child: IconButton(
                          // splashRadius: 15,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              obscureConfirm = !obscureConfirm;
                            });
                          },
                          icon: Icon(
                            obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: context.scaleFont(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 185,
                          child: BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, state) {
                              if (state is ChangePasswordLoading) {
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                );
                              } else {
                                return ButtonConfirm(
                                  text: "Update Password",
                                  borderRadius: 8,
                                  onTap: () {
                                    if (passKey.currentState!.validate()) {
                                      onConfirm(model);
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
