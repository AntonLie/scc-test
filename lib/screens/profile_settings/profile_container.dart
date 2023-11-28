import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/countries.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/profile.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/common_shimmer.dart';
import 'package:scc_web/shared_widgets/custom_dropdown.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class ProfileContainer extends StatefulWidget {
  final Function(String) onError, onSuccess;
  final List<Countries> listCountryDrpdwnForm;
  final String? dialCode, base64;

  const ProfileContainer(
      {super.key,
      required this.onError,
      required this.onSuccess,
      required this.listCountryDrpdwnForm,
      this.dialCode,
      this.base64});

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  Profile profile = Profile();
  Countries country = Countries();

  late TextEditingController fullNameCo;
  late TextEditingController companyNameCo;
  late TextEditingController emailCo;
  late TextEditingController phoneNoCo;
  late TextEditingController divisionCo;
  String? countryFlag;
  int? phoneCodeModel;
  Uint8List? fileBytes;
  String? fileNameIcon;
  String? base64File;
  String? base64FileString;
  List<dynamic> listFiles = [];
  Login? login;

  @override
  void initState() {
    for (var e in widget.listCountryDrpdwnForm) {
      if (e.phoneCode == phoneCodeModel) {
        countryFlag = e.iso;
      }
    }

    fullNameCo = TextEditingController(text: profile.fullName);
    companyNameCo = TextEditingController(text: profile.companyName);
    emailCo = TextEditingController(text: profile.email);
    phoneNoCo = TextEditingController(text: profile.phoneNo);
    divisionCo = TextEditingController(text: profile.division);
    base64FileString = profile.base64;
    if (base64FileString != null) {
      fileBytes = base64Decode(base64FileString!);
    }

    super.initState();
  }

  adjustForm(Profile stateProfile, List<Countries> country) {
    setState(() {
      profile = stateProfile;
      fullNameCo.value = fullNameCo.value.copyWith(text: profile.fullName);
      companyNameCo.value =
          companyNameCo.value.copyWith(text: profile.companyName);
      divisionCo.value = divisionCo.value.copyWith(text: profile.division);
      phoneNoCo.value = phoneNoCo.value.copyWith(text: profile.phoneNo);
      emailCo.value = emailCo.value.copyWith(text: profile.email);
      profile.base64 = profile.base64;
      phoneCodeModel = int.tryParse(profile.dialCode!.replaceAll("+", ""));
      profile.filename = profile.filename;

      for (var e in country) {
        if (e.phoneCode == phoneCodeModel) {
          countryFlag = e.iso;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    bloc(ProfileEvent event) {
      BlocProvider.of<ProfileBloc>(context).add(event);
    }

    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    homeBloc(HomeEvent event) {
      BlocProvider.of<HomeBloc>(context).add(event);
    }

    onConfirm(Profile val) {
      showDialog(
          context: context,
          builder: (context) {
            return ConfirmSaveDialog(
              sTitle: "Profile",
              sValue: val.fullName,
              onSave: () {
                bloc(SubmitUpdateProfile(profile));
                context.closeDialog();
              },
            );
          });
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedOut) {
              context.push(const LoginRoute());
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              ProfileError(state.error);
            }
            if (state is LoadHome) {
              login = state.login;
              if (login == null) {
                homeBloc(DoLogout(login: login));
              }
            }
            if (state is OnLogoutHome) {
              authBloc(AuthLogin());
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is UpdateSuccess) {
              widget.onSuccess(state.message);
            }
            if (state is ProfileError) {
              widget.onError(state.error);
            }
            if (state is ProfileEdit) {
              adjustForm(state.profile, state.listCountry);
            }
            if (state is UpdateSuccess) {
              adjustForm(state.profile, state.listCountry);
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return CommonShimmer(
            isLoading: state == ProfileLoading(),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: context.isDesktop()
                  ? const EdgeInsets.symmetric(vertical: 10, horizontal: 30)
                  : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Portal(
                child: Form(
                  key: key,
                  child: FocusTraversalGroup(
                    descendantsAreFocusable: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              ClipRRect(
                                child: (listFiles.isEmpty &&
                                        profile.base64 == null)
                                    ? SvgPicture.asset(Constant.iconprofile,
                                        width: context.deviceWidth() * 0.125,
                                        height: context.deviceWidth() * 0.125,
                                        fit: BoxFit.cover)
                                    : Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          // color: sccAmber,
                                        ),
                                        child: ClipOval(
                                          // borderRadius:
                                          //     BorderRadius.circular(500),
                                          child: Image.memory(
                                            width: context.scaleFont(200),
                                            height: context.scaleFont(200),
                                            base64Decode(profile.base64!),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                              ),
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: sccText2, width: 0.5),
                                    color: sccWhite,
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      accFileMobile();
                                    },
                                    tooltip: "Change profile picture",
                                    icon: HeroIcon(
                                      HeroIcons.camera,
                                      size: context.deviceWidth() * 0.13,
                                      color: sccText2,
                                      // size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: StyledText(
                            text:
                                '<r>*</r> The uploaded image must be 500px wide and 500px long ',
                            style: TextStyle(
                                fontSize: context.scaleFont(12),
                                fontWeight: FontWeight.w400),
                            tags: {
                              'r': StyledTextTag(
                                  style: TextStyle(
                                      fontSize: context.scaleFont(14),
                                      fontWeight: FontWeight.w400,
                                      color: sccDanger))
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    "Full Name",
                                    style: TextStyle(
                                        fontSize: context.scaleFont(14),
                                        fontWeight: FontWeight.w400,
                                        color: sccText3),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomFormTextField(
                                    controller: fullNameCo,
                                    hint: 'Input Username',
                                    readOnly: true,
                                    enabled: false,
                                    hoverColor: sccFillField,
                                    fillColor: sccDisabled,
                                    onChanged: (value) {
                                      if (value != null) {
                                        profile.fullName = value;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    "Company Name",
                                    style: TextStyle(
                                        fontSize: context.scaleFont(14),
                                        fontWeight: FontWeight.w400,
                                        color: sccText3),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomFormTextField(
                                    controller: companyNameCo,
                                    hint: 'Input Company Name',
                                    enabled: false,
                                    hoverColor: sccFillField,
                                    fillColor: sccDisabled,
                                    onChanged: (value) {
                                      if (value != null) {
                                        profile.companyName = value;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    "Division",
                                    style: TextStyle(
                                        fontSize: context.scaleFont(14),
                                        fontWeight: FontWeight.w400,
                                        color: sccText3),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomFormTextField(
                                    controller: divisionCo,
                                    enabled: false,
                                    hint: 'Input Position',
                                    hoverColor: sccFillField,
                                    fillColor: sccDisabled,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field is mandatory";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {
                                      if (value != null) {
                                        profile.division = value;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  SelectableText(
                                    "Email",
                                    style: TextStyle(
                                        fontSize: context.scaleFont(14),
                                        fontWeight: FontWeight.w400,
                                        color: sccText3),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomFormTextField(
                                    controller: emailCo,
                                    hint: 'Input Email',
                                    hoverColor: sccFillField,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field is mandatory";
                                      } else if (validateEmails(value)) {
                                        return "Please enter a valid email format";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {
                                      if (value != null) {
                                        profile.email = value;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    "Phone Number",
                                    style: TextStyle(
                                        fontSize: context.scaleFont(14),
                                        fontWeight: FontWeight.w400,
                                        color: sccText3),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomDropdown(
                                    style: TextStyle(
                                        fontSize: context.scaleFont(14),
                                        fontWeight: FontWeight.w400),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    initialValue: phoneNoCo.text,
                                    flagsButtonMargin: const EdgeInsets.all(5),
                                    width: context.deviceWidth() * 0.35,
                                    height: context.deviceHeight() * 0.6,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: sccLightGray,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    initialCountryCode: countryFlag ?? 'ID',
                                    onChanged: (phone) {
                                      phoneNoCo.text = phone.number.toString();
                                      profile.phoneNo = phone.number.toString();
                                    },
                                    onCountryChanged: (country) {
                                      profile.dialCode = "+${country.dialCode}";
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 185,
                              child: BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, state) {
                                  // if (state is ProfileLoading) {
                                  //   return Container(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         vertical: 4),
                                  //     child: const CircularProgressIndicator(),
                                  //   );
                                  // } else {
                                  return ButtonConfirm(
                                    text: "Update Profile",
                                    borderRadius: 8,
                                    onTap: () {
                                      if (key.currentState!.validate()) {
                                        profile.base64BE ??=
                                            "${profile.filename},${profile.base64}";
                                        // print(profile.base64BE);
                                        onConfirm(profile);
                                      }
                                    },
                                  );
                                  // }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  accFileMobile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      // withData: true,
      // withReadStream: true

      allowMultiple: false,
    );

    if (result != null) {
      try {
        fileBytes = result.files.first.bytes!;
        base64File = base64Encode(fileBytes!);

        fileNameIcon = result.files.first.name;
        fileBytes = fileBytes;
        // final splitName = fileNameIcon?.split('.');
        // String fileName = splitName![0];

        if (result.files.first.size > 1000000) {
          // ignore: use_build_context_synchronously
          showTopSnackBar(
              context, const UpperSnackBar.error(message: 'File size max 1MB'));
        }

        // print(result);
        setState(() {
          // isHovered = false;

          if (listFiles.isNotEmpty) listFiles.clear();

          listFiles.add(fileBytes);
          profile.base64 = base64File;
          profile.base64BE = "$fileNameIcon,$base64File";
          // submitModel.file = fileBytes;

          // print(listFiles);
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        showTopSnackBar(context, UpperSnackBar.error(message: e.toString()));
      }
    }
    // else {
    //   // ignore: use_build_context_synchronously
    //   showTopSnackBar(
    //       context, const UpperSnackBar.error(message: 'File not supported'));
    // }
  }
}
