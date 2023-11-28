// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/package/bloc/package_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/contact_admin.dart';
import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_dropdown.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';

import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';
import 'package:styled_text/styled_text.dart';

class ContactAdminDialog extends StatefulWidget {
  final Function(String) onError;
  final Function() onSuccess;
  final int packageCd;
  final String selectedRow;
  final String? packageColor;

  const ContactAdminDialog({
    required this.onError,
    required this.packageCd,
    required this.onSuccess,
    Key? key,
    required this.selectedRow,
    this.packageColor,
  }) : super(key: key);

  @override
  State<ContactAdminDialog> createState() => _ContactAdminDialogState();
}

class _ContactAdminDialogState extends State<ContactAdminDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackageBloc()..add(GetPackageInfo(widget.packageCd)),
      child: ContactAdminDialogBody(
        selectedRow: widget.selectedRow,
        packageCd: widget.packageCd,
        onError: (value) => widget.onError(value),
        onSuccess: () => widget.onSuccess(),
        packageColor: widget.packageColor,
        // listUsecase: (value) => widget.listUsecase(value),
      ),
    );
  }
}

class ContactAdminDialogBody extends StatefulWidget {
  final Function(String) onError;
  final Function() onSuccess;
  final int packageCd;
  final String selectedRow;
  final String? packageColor;
  const ContactAdminDialogBody({
    required this.onError,
    required this.onSuccess,
    required this.packageCd,

    // required this.listUsecase,
    Key? key,
    required this.selectedRow,
    this.packageColor,
  }) : super(key: key);

  @override
  _ContactAdminDialogBodyState createState() => _ContactAdminDialogBodyState();
}

class _ContactAdminDialogBodyState extends State<ContactAdminDialogBody> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  late ScrollController controller;
  late TextEditingController fullNameCo;
  late TextEditingController emailCo;
  late TextEditingController companyName;
  late TextEditingController abbreviationName;
  late TextEditingController phoneCo;
  late TextEditingController companyCo;
  late TextEditingController address;
  late TextEditingController msgCo;
  ContactAdmin model = ContactAdmin();
  String selectedItem = '';
  String selectedCountry = '';
  String selectedTime = '';
  Contacted contact = Contacted();
  List<KeyVal> plants = [];
  List<KeyVal> country = [];
  List<KeyVal> systemDrop = [];

  bloc(dynamic event) {
    BlocProvider.of<PackageBloc>(context).add(event);
  }

  @override
  void initState() {
    bloc(GetPackageTypeDropdown());
    address = TextEditingController();
    controller = ScrollController();
    fullNameCo = TextEditingController();
    emailCo = TextEditingController();
    companyName = TextEditingController();
    phoneCo = TextEditingController();
    abbreviationName = TextEditingController();
    companyCo = TextEditingController();
    msgCo = TextEditingController();
    model.packageCd = widget.packageCd;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PackageBloc, PackageState>(
      listener: (context, state) {
        if (state is PackageTypeLoad) {
          setState(() {
            plants = (state.listPlant);
            country = state.listCountry;
            systemDrop = state.listSystem;
          });
        }
        if (state is ContactAdminSuccrss) {
          context.closeDialog();
          widget.onSuccess();
        }
        if (state is LoadContact) {
          contact = state.contact;
        }
      },
      child: Portal(
        child: Dialog(
          insetPadding: kIsWeb && !isWebMobile
              ? EdgeInsets.symmetric(
                  horizontal: (context.deviceWidth() * 0.15),
                  vertical: (context.deviceHeight() * 0.1),
                )
              : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            decoration: BoxDecoration(
              color: sccWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.only(top: 12),
            child: FocusTraversalGroup(
              child: Form(
                key: key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Contact admin",
                            style: TextStyle(
                              fontSize: context.scaleFont(28),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.selectedRow,
                                style: TextStyle(
                                  color: (widget.packageColor == null)
                                      ? sccYellow
                                      : stringToColor(widget.packageColor),
                                  fontSize: context.scaleFont(16),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  context.closeDialog();
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  // color: sccRed,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      color: sccWhite,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(
                                            5.0,
                                            5.0,
                                          ),
                                          blurRadius: 10.0,
                                          spreadRadius: 2.0,
                                        ),
                                      ]),
                                  child: HeroIcon(
                                    HeroIcons.xMark,
                                    color: sccButtonPurple,
                                    size: context.scaleFont(28),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      color: sccLightGrayDivider,
                      height: 25,
                      thickness: 2,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      padding: sccOutterPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: context.deviceWidth() * 0.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Full Name",
                                        style: TextStyle(
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.w400,
                                        )),
                                    const SizedBox(height: 4),
                                    Text(contact.fullName ?? "",
                                        style: TextStyle(
                                          fontSize: context.scaleFont(16),
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: context.deviceWidth() * 0.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Company Name",
                                        style: TextStyle(
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.w400,
                                        )),
                                    const SizedBox(height: 4),
                                    Text(contact.companyName ?? "",
                                        style: TextStyle(
                                          fontSize: context.scaleFont(16),
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: context.deviceWidth() * 0.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Email",
                                        style: TextStyle(
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.w400,
                                        )),
                                    const SizedBox(height: 4),
                                    Text(contact.email ?? "",
                                        style: TextStyle(
                                          fontSize: context.scaleFont(16),
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          StyledText(
                            text: 'Phone Number <r> *</r>',
                            style: TextStyle(fontSize: context.scaleFont(16)),
                            tags: {
                              'r': StyledTextTag(
                                  style: TextStyle(
                                      fontSize: context.scaleFont(16),
                                      color: sccDanger))
                            },
                          ),
                          const SizedBox(height: 4),
                          CustomDropdown(
                            initialValue: '',
                            flagsButtonMargin: const EdgeInsets.all(5),
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            initialCountryCode: 'ID',
                            width: context.deviceWidth() * 0.6,
                            height: context.deviceHeight() * 0.5,
                            onChanged: (phone) {
                              phoneCo.text = phone.completeNumber.toString();
                              model.phoneNumber = phoneCo.text;
                              model.countryId = int.parse(phone.countryCode);
                            },
                            onCountryChanged: (country) {},
                          ),
                          const SizedBox(height: 12),
                          StyledText(
                            text: 'Package Time <r> *</r>',
                            style: TextStyle(fontSize: context.scaleFont(16)),
                            tags: {
                              'r': StyledTextTag(
                                  style: TextStyle(
                                      fontSize: context.scaleFont(16),
                                      color: sccDanger))
                            },
                          ),
                          const SizedBox(height: 4),
                          PortalFormDropdown(
                            selectedTime,
                            systemDrop,
                            onChange: (val) {
                              setState(() {
                                selectedTime = val;
                                model.packageTime = val;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is mandatory";
                              } else if (value.trim().length > 200) {
                                return "Only 200 characters for maximum allowed";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          StyledText(
                            text: 'Message', // <r> *</r>',
                            style: TextStyle(fontSize: context.scaleFont(16)),
                            tags: {
                              'r': StyledTextTag(
                                  style: TextStyle(
                                      fontSize: context.scaleFont(16),
                                      color: sccDanger))
                            },
                          ),
                          const SizedBox(height: 4),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: CustomFormTextField(
                              hint: 'Input Message',
                              controller: msgCo,
                              minLine: 5,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      width: 1, color: sccFillLoginField)),
                              inputType: TextInputType.multiline,
                              inputAction: TextInputAction.newline,
                              onChanged: (value) {
                                model.msgText = value;
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: isMobile
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.end,
                              children: [
                                ButtonCancel(
                                  text: "Cancel",
                                  width: context.deviceWidth() *
                                      (context.isDesktop() ? 0.11 : 0.35),
                                  onTap: () {
                                    // if (!(state is PackageLoading)) {
                                    context.back();
                                    // }
                                  },
                                ),
                                SizedBox(
                                  width: 8.wh,
                                ),
                                ButtonConfirm(
                                  text: "Submit",
                                  onTap: () {
                                    if ((key.currentState?.validate() ==
                                        true)) {
                                      model.packageCd = widget.packageCd;
                                      model.fullName = contact.fullName;
                                      model.email = contact.email;

                                      bloc(SubmitContactAdmin(model));
                                    }
                                  },
                                  width: context.deviceWidth() *
                                      (context.isDesktop() ? 0.1 : 0.35),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
