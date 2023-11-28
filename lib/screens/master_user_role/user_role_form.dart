import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/mst_usr_role/bloc/mst_usr_role_bloc.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/countries.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/model/user_role.dart';
import 'package:scc_web/screens/master_package/role_field.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_dropdown.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:styled_text/styled_text.dart';

import '../../theme/colors.dart';

class AdminFormScreen extends StatefulWidget {
  final MasterRoleSubmit? model;
  final String formMode;
  final List<String> listBrand;
  final List<DataCompany> listCompany;
  final List<DataDivision> listDivision;
  final List<Countries> listCountry;
  final Function onClose;
  final Function(MasterRoleSubmit) onSubmit;
  const AdminFormScreen({
    super.key,
    required this.formMode,
    required this.listBrand,
    required this.listCompany,
    required this.listDivision,
    this.model,
    required this.onClose,
    required this.onSubmit,
    required Paging paging,
    required this.listCountry,
  });

  @override
  State<AdminFormScreen> createState() => _AdminFormScreenState();
}

class _AdminFormScreenState extends State<AdminFormScreen> {
  GlobalKey<FormState> key = GlobalKey<FormState>();

  List<KeyVal> role = [];
  List<KeyVal> brand = [];
  List<KeyVal> company = [];
  List<KeyVal> division = [];
  List<KeyVal> selectedItems = [];
  double? rowWidth;
  String? selectedRole;
  MasterRole submitModel = MasterRole();
  final scroll = ScrollController();
  late ScrollController vController;
  RoleUser? selectedMenuList;
  MasterRoleSubmit submit = MasterRoleSubmit();

  late TextEditingController brandNameCo;
  late TextEditingController companyNameCo;
  late TextEditingController userNameCo;
  late TextEditingController emailCo;
  late TextEditingController passwordCo;
  late TextEditingController confirmPasswordCo;
  late TextEditingController fullNameCo;
  late TextEditingController divisionNameCo;
  late TextEditingController phoneNumCo;
  String? negara;
  KeyVal? roleSelected;
  String? brandSelected;
  String? companySelected;
  String? divisionSelected;
  List<KeyVal> nodeSelected = [];
  List<Role> listRole = [];
  List<String> roleSt = [];
  List<KeyVal> country = [];
  FocusNode focusPassword = FocusNode();
  String substringToRemove = "+62";
  String? phone;

  bool obscure = true;

  @override
  void initState() {
    submit = widget.model!;

    userNameCo = TextEditingController(text: submit.username ?? "");
    emailCo = TextEditingController(text: submit.email ?? "");
    passwordCo = TextEditingController(text: submit.password ?? "");
    if (widget.formMode != Constant.addMode) {
      confirmPasswordCo = TextEditingController(text: submit.password ?? "");
      submit.confirmPassword = submit.password;
    } else {
      confirmPasswordCo =
          TextEditingController(text: submit.confirmPassword ?? "");
    }
    fullNameCo = TextEditingController(text: submit.fullName ?? "");
    divisionNameCo = TextEditingController(text: submit.division ?? "");
    if (submit.phoneNumber != null) {
      phone = submit.phoneNumber!.replaceAll(substringToRemove, "");
      phoneNumCo = TextEditingController(text: phone ?? "");
    } else {
      phoneNumCo = TextEditingController(text: submit.phoneNumber ?? "");
    }
    if (submit.roleList != null) {
      listRole.addAll(submit.roleList!);

      for (var element in listRole) {
        if (element.roleCd != null) {
          roleSt.add(element.roleCd!);
          nodeSelected
              .add(KeyVal(element.roleCd ?? "[UNIDENTIFIED]", element.roleCd!));
        }
      }
    }

    for (var e in widget.listCompany) {
      company.add(KeyVal(e.companyName ?? "", e.companyCd ?? ""));
    }
    for (var e in widget.listDivision) {
      division.add(KeyVal(e.division ?? "", e.division ?? ""));
    }
    for (var e in widget.listBrand) {
      brand.add(KeyVal(e, e));
    }

    brandSelected = submit.brand;
    companySelected = submit.companyCd;
    divisionSelected = submit.division;

    if (widget.formMode == Constant.addMode) {
      companySelected = submit.companyCd;
      submit.companyCd = company[0].value;

      divisionSelected = submit.division;
      submit.division = division[0].value;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onConfirm(MasterRoleSubmit val) {
      showDialog(
          context: context,
          builder: (context) {
            return ConfirmSaveDialog(
              sTitle: "User Role",
              sValue: val.fullName,
              onSave: () {
                // widget.onSave(val);
                context.closeDialog();
                widget.onSubmit(submit);
              },
            );
          });
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<MstUsrRoleBloc, MstUsrRoleState>(
          listener: (context, state) {
            if (state is LoadMenuList) {
              selectedMenuList = state.model;
              selectedRole = state.model?.roleCd;

              // if(selectedRole?.isNotEmpty==true){}
              // number = 0;
            }
          },
        ),
      ],
      child: Portal(
        child: Form(
          key: key,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: FocusTraversalGroup(
                  descendantsAreFocusable: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.formMode == Constant.addMode
                            ? "Add New"
                            : "Edit",
                        style: TextStyle(
                          fontSize: context.scaleFont(18),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff2B2B2B),
                        ),
                      ),
                      const Divider(
                        color: sccLightGrayDivider,
                        height: 25,
                        thickness: 2,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StyledText(
                                text: 'Brand'
                                    ' <r>*</r>'
                                    '',
                                style: TextStyle(
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w400),
                                tags: {
                                  'r': StyledTextTag(
                                      style: TextStyle(
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.w400,
                                          color: sccDanger))
                                },
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: context.deviceWidth() * 0.35,
                                child: PortalFormDropdown(
                                  brandSelected,
                                  brand,
                                  hintText: 'Choose Brand',

                                  enabled: widget.formMode != Constant.viewMode,

                                  // fontWeight: FontWeight.normal,
                                  borderRadius: 8,
                                  onChange: (value) {
                                    setState(() {
                                      brandSelected = value;
                                      submit.brand = value;
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
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StyledText(
                                text: 'Company'
                                    ' <r>*</r>'
                                    '',
                                style: TextStyle(
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w400),
                                tags: {
                                  'r': StyledTextTag(
                                      style: TextStyle(
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.w400,
                                          color: sccDanger))
                                },
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: context.deviceWidth() * 0.4,
                                child: PortalFormDropdown(
                                  companySelected,
                                  company,
                                  hintText: 'Choose Company',
                                  enabled: widget.formMode != Constant.viewMode,

                                  // fontWeight: FontWeight.normal,
                                  borderRadius: 8,
                                  onChange: (value) {
                                    setState(() {
                                      companySelected = value;
                                      submit.companyCd = value;
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
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      StyledText(
                        text: 'Full Name'
                            ' <r>*</r>'
                            '',
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400),
                        tags: {
                          'r': StyledTextTag(
                              style: TextStyle(
                                  fontSize: context.scaleFont(14),
                                  fontWeight: FontWeight.w400,
                                  color: sccDanger))
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomFormTextField(
                        hint: 'Input Fullname',
                        controller: fullNameCo,
                        enabled: widget.formMode != Constant.viewMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is mandatory";
                          } else if (value.trim().length > 200) {
                            return "Only 200 characters for maximum allowed";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value != null) {
                            submit.fullName = value;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      StyledText(
                        text: 'Email Address'
                            ' <r>*</r>'
                            '',
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400),
                        tags: {
                          'r': StyledTextTag(
                              style: TextStyle(
                                  fontSize: context.scaleFont(14),
                                  fontWeight: FontWeight.w400,
                                  color: sccDanger))
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomFormTextField(
                        hint: "Input Email",
                        controller: emailCo,
                        enabled: widget.formMode != Constant.viewMode,
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
                            submit.email = value;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      StyledText(
                        text: 'Phone Number <r> *</r>',
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400),
                        tags: {
                          'r': StyledTextTag(
                              style: TextStyle(
                                  fontSize: context.scaleFont(14),
                                  fontWeight: FontWeight.w400,
                                  color: sccDanger))
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomDropdown(
                        width: context.deviceWidth() * 0.75,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        flagsButtonMargin: const EdgeInsets.all(5),
                        enabled: widget.formMode != Constant.viewMode,
                        initialValue: phoneNumCo.text,
                        initialCountryCode: 'ID',
                        decoration: InputDecoration(
                          // labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: sccLightGray,
                              width: 0.5,
                            ),
                          ),
                        ),
                        onChanged: (phone) {
                          setState(() {
                            phoneNumCo.text = phone.completeNumber.toString();
                            submit.phoneNumber = phone.number;
                            submit.phoneCode = int.parse(phone.countryCode);
                          });
                        },
                        onCountryChanged: (country) {
                          setState(() {
                            negara = country.name.toUpperCase();
                            submit.dialCode = "+${country.dialCode}";
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "This field is mandatory";
                          } else {
                            return null;
                          }
                        },
                      ),
                      StyledText(
                        text: 'Division'
                            ' <r>*</r>'
                            '',
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400),
                        tags: {
                          'r': StyledTextTag(
                              style: TextStyle(
                                  fontSize: context.scaleFont(14),
                                  fontWeight: FontWeight.w400,
                                  color: sccDanger))
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: context.deviceWidth(),
                        child: PortalFormDropdown(
                          divisionSelected,
                          division,
                          hintText: 'Choose Division',

                          enabled: widget.formMode != Constant.viewMode,
                          // fontWeight: FontWeight.normal,
                          borderRadius: 8,
                          onChange: (value) {
                            setState(() {
                              divisionSelected = value;
                              submit.division = value;
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
                      ),
                      SizedBox(
                        width: context.deviceWidth(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Login",
                      style: TextStyle(
                        fontSize: context.scaleFont(18),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff2B2B2B),
                      ),
                    ),
                    const Divider(
                      color: sccLightGrayDivider,
                      height: 25,
                      thickness: 2,
                    ),
                    const SizedBox(height: 10),
                    StyledText(
                      text: 'Username'
                          ' <r>*</r>'
                          '',
                      style: TextStyle(
                          fontSize: context.scaleFont(14),
                          fontWeight: FontWeight.w400),
                      tags: {
                        'r': StyledTextTag(
                            style: TextStyle(
                                fontSize: context.scaleFont(14),
                                fontWeight: FontWeight.w400,
                                color: sccDanger))
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      hint: 'Input Username',
                      controller: userNameCo,
                      enabled:
                          widget.formMode == Constant.editMode ? false : true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is mandatory";
                        } else if (value.trim().length > 200) {
                          return "Only 200 characters for maximum allowed";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if (value != null) {
                          submit.username = value;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    StyledText(
                      text: widget.formMode == Constant.addMode
                          ? 'Password'
                          : 'New Password'
                              ' <r>*</r>'
                              '',
                      style: TextStyle(
                          fontSize: context.scaleFont(14),
                          fontWeight: FontWeight.w400),
                      tags: {
                        'r': StyledTextTag(
                            style: TextStyle(
                                fontSize: context.scaleFont(14),
                                fontWeight: FontWeight.w400,
                                color: sccDanger))
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                        hint: '********',
                        controller: passwordCo,
                        obscureText: obscure,
                        // focusNode: focusPassword,
                        maxLine: 1,
                        enabled: widget.formMode != Constant.viewMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password can't be blank";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value != null) {
                            submit.password = value;
                          }
                        },
                        suffix: SizedBox(
                          width: 50,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 14),
                              alignment: Alignment.centerRight,
                              child: obscure
                                  ? const HeroIcon(HeroIcons.eye)
                                  : const HeroIcon(HeroIcons.eyeSlash),
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                    StyledText(
                      text: 'Confirm Password'
                          ' <r>*</r>'
                          '',
                      style: TextStyle(
                          fontSize: context.scaleFont(14),
                          fontWeight: FontWeight.w400),
                      tags: {
                        'r': StyledTextTag(
                            style: TextStyle(
                                fontSize: context.scaleFont(14),
                                fontWeight: FontWeight.w400,
                                color: sccDanger))
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      hint: '********',
                      controller: confirmPasswordCo,
                      obscureText: obscure,
                      maxLine: 1,
                      enabled: widget.formMode != Constant.viewMode,
                      // focusNode: focusPassword,
                      validator: (value) {
                        if ((value == null || value.isEmpty) &&
                            widget.formMode != Constant.editMode) {
                          return "Password can't be blank";
                        } else if (value != passwordCo.text &&
                            widget.formMode != Constant.editMode) {
                          return "Passwords do Not match ";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if (value != null) {
                          submit.confirmPassword = value;
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Role",
                          style: TextStyle(
                            fontSize: context.scaleFont(18),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff2B2B2B),
                          ),
                        ),
                        const Divider(
                          color: sccLightGrayDivider,
                          height: 25,
                          thickness: 2,
                        ),
                        const SizedBox(height: 10),
                        StyledText(
                          text: 'Roles'
                              ' <r>*</r>'
                              '',
                          style: TextStyle(
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w400),
                          tags: {
                            'r': StyledTextTag(
                                style: TextStyle(
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w400,
                                    color: sccDanger))
                          },
                        ),
                        const SizedBox(height: 10),
                        RoleField(
                          nodeSelected,
                          hintText: "Select Role",
                          enabled: widget.formMode != Constant.viewMode,
                          onChange: (value) {
                            setState(() {
                              nodeSelected = List.from(value);
                              listRole.clear();
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is mandatory";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ])),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: widget.formMode != Constant.viewMode,
                //&& selectedItems.isNotEmpty

                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: isMobile
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.end,
                    children: [
                      ButtonCancel(
                        text: "Cancel",
                        width: context.deviceWidth() *
                            (context.isDesktop() ? 0.13 : 0.37),
                        borderRadius: 8,
                        onTap: () {
                          // context.push(
                          //     const MasterAdminRoute());
                          widget.onClose();
                        },
                      ),
                      SizedBox(
                        width: 8.wh,
                      ),
                      ButtonConfirm(
                        text: widget.formMode == Constant.editMode
                            ? "Save"
                            : "Submit",
                        onTap: () {
                          if (key.currentState!.validate()) {
                            setState(() {
                              submit.role = [];
                            });

                            for (var element in nodeSelected) {
                              submit.role!.add(element.value);
                            }

                            for (var element in widget.listCountry) {
                              if (negara != null) {
                                if (negara == element.countryName) {
                                  submit.countryId = element.countryId;
                                  submit.dialCode = '+${element.phoneCode}';
                                }
                              } else {
                                negara = 'INDONESIA';
                                if (negara == element.countryName) {
                                  submit.countryId = element.countryId;
                                  submit.dialCode = '+${element.phoneCode}';
                                }
                              }
                            }
                            onConfirm(submit);
                            // showDialog(
                            //     context: context,
                            //     builder: (ctx) {
                            //       return ConfirmSaveDialog(
                            //         sTitle: "User Role",
                            //         sValue: submitModel.roleName,
                            //         onSave: () {
                            //           context.closeDialog();
                            //           widget.onSubmit(submit);
                            //         },
                            //       );
                            //     });
                          }
                        },
                        width: context.deviceWidth() *
                            (context.isDesktop() ? 0.13 : 0.37),
                        borderRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
