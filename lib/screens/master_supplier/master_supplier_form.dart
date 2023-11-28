// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:gap/gap.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/countries.dart';
import 'package:scc_web/model/master_supplier.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/shared_widgets/Tooltip_i.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_dropdown.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/ta_dropdown.dart';
import 'package:styled_text/styled_text.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';

class SupplierFormAddEdit extends StatefulWidget {
  final String formMode;
  final Supplier? model;
  final List<Countries> listCountryDrpdwnForm;
  final List<SystemMaster> listSupplierType;
  final Function() onClose;
  final Function(Supplier) onSuccesSubmit;

  const SupplierFormAddEdit(
      {super.key,
      required this.formMode,
      this.model,
      required this.onClose,
      required this.onSuccesSubmit,
      required this.listCountryDrpdwnForm,
      required this.listSupplierType});

  @override
  State<SupplierFormAddEdit> createState() => _SupplierFormAddEditState();
}

class _SupplierFormAddEditState extends State<SupplierFormAddEdit> {
  late ScrollController controller;

  bool validateList = false;
  List<KeyVal> listCountryDrpdwn = [];
  List<KeyVal> listSupplierType = [];
  String? selectedCountry;
  String? suppTypeSelected;
  Supplier submitModel = Supplier();
  String? countryFlag;
  int? phoneCodeModel;
  // Supplier? submitModel;

  late TextEditingController suppNameCo;
  late TextEditingController suppCodeCo;
  late TextEditingController typeSuppCo;
  late TextEditingController countrySuppCo;
  late TextEditingController citySuppCo;
  late TextEditingController postalSuppCo;
  late TextEditingController addressSuppCo;
  late TextEditingController phoneSuppCo;

  @override
  void initState() {
    // listCountryDrpdwn = widget.listCountryDrpdwnForm;

    for (var element in widget.listCountryDrpdwnForm) {
      if (element.countryId != null) {
        listCountryDrpdwn.add(KeyVal(element.countryName ?? "[Undefined]",
            element.countryId!.toString()));
      }
    }

    for (var element in widget.listSupplierType) {
      if (element.systemCd != null) {
        listSupplierType.add(
            KeyVal(element.systemValue ?? "[Undefined]", element.systemCd!));
      }
    }

    if (widget.model != null) {
      submitModel = widget.model!;
      selectedCountry = submitModel.supplierCountryId.toString();
      suppTypeSelected = submitModel.supplierTypeCd!.toUpperCase();
      phoneCodeModel = int.tryParse(submitModel.dialCode!.replaceAll("+", ""));

      for (var element in widget.listCountryDrpdwnForm) {
        if (element.phoneCode == phoneCodeModel) {
          countryFlag = element.iso;
        }
      }
    }
    suppNameCo = TextEditingController(text: submitModel.supplierName ?? "");
    suppCodeCo = TextEditingController(text: submitModel.supplierCd ?? "");
    typeSuppCo = TextEditingController(text: submitModel.supplierTypeCd ?? "");
    citySuppCo = TextEditingController(text: submitModel.supplierCity ?? "");
    postalSuppCo = TextEditingController(text: submitModel.postalCd ?? "");
    addressSuppCo = TextEditingController(text: submitModel.supplierAddr ?? "");
    phoneSuppCo =
        TextEditingController(text: submitModel.supplierContactNo ?? "");

    if (widget.formMode == Constant.addMode) {
      // suppTypeSelected = listSupplierType[0].value;
      // submitModel.supplierTypeCd = suppTypeSelected!.toUpperCase();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();

    onConfirm(Supplier val) {
      showDialog(
          context: context,
          builder: (context) {
            return ConfirmSaveDialog(
              sTitle: "Supplier",
              sValue: val.supplierName,
              onSave: () {
                // widget.onSave(val);
                widget.onSuccesSubmit(val);

                context.closeDialog();
              },
            );
          });
    }

    return Portal(
      child: Form(
        key: key,
        child: FocusTraversalGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isMobile ? Colors.white : sccWhite,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.formMode == Constant.addMode ? "Add New" : "Edit",
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          // height: 80,
                          // width: context.deviceWidth() * 0.3,
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  StyledText(
                                    text: 'Supplier Code '
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
                                            color: sccDanger),
                                      )
                                    },
                                  ),
                                  const Gap(5),
                                  const ToolI(
                                    message:
                                        'A supplier code is a unique code that identifies the supplier of the goods. It is used as the client id (Supplier Code-Agent)',
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              CustomFormTextField(
                                hint: 'Input Supplier Code',
                                controller: suppCodeCo,
                                enabled: widget.formMode == Constant.addMode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is mandatory";
                                  } else if (value.trim().length > 50) {
                                    return "Only 50 characters for maximum allowed";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  if (value != null) {
                                    submitModel.supplierCd = value.trim();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          // height: 80,
                          // width: context.deviceWidth() * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StyledText(
                                text: 'Supplier Name '
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
                                        color: sccDanger),
                                  )
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomFormTextField(
                                hint: 'Input Supplier Name',
                                controller: suppNameCo,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is mandatory";
                                  } else if (value.trim().length > 50) {
                                    return "Only 50 characters for maximum allowed";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  if (value != null) {
                                    submitModel.supplierName = value.trim();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StyledText(
                      text: 'Type of Supplier '
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
                    PortalFormDropdown(
                      suppTypeSelected,
                      listSupplierType,
                      hintText: "Choose Supplier Type",
                      // enabled: widget.formMode == Constant.addMode,
                      onChange: (value) {
                        setState(() {
                          suppTypeSelected = value;
                          submitModel.supplierTypeCd =
                              suppTypeSelected!.toUpperCase();
                        });
                      },
                      validator: (value) {
                        if (suppTypeSelected == null) {
                          return "This field is mandatory";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          // height: 80,
                          // width: context.deviceWidth() * 0.3,
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StyledText(
                                text: 'Country '
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
                                        color: sccDanger),
                                  )
                                },
                              ),
                              const SizedBox(height: 10),
                              TAFormDropdown(
                                selectedCountry,
                                listCountryDrpdwn,
                                hintText: "Choose Countries",
                                enabled: true,
                                hideKeyboard: false,
                                // enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                hoverColor: sccWhite,
                                borderRadius: 8,
                                borderColor: sccBorder,
                                fillColor: sccWhite,
                                onChange: (val) {
                                  setState(() {
                                    selectedCountry = val;
                                    submitModel.supplierCountryId =
                                        int.parse(val!);
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is mandatory";
                                  } else {
                                    return null;
                                  }
                                },
                                onStrChange: (val) {
                                  if (val!.isEmpty) {
                                    setState(() {
                                      selectedCountry = val;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          // height: 80,
                          // width: context.deviceWidth() * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StyledText(
                                text: 'City '
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
                                        color: sccDanger),
                                  )
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomFormTextField(
                                hint: 'Input City',
                                controller: citySuppCo,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is mandatory";
                                  } else if (value.trim().length > 100) {
                                    return "Only 100 characters for maximum allowed";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  if (value != null) {
                                    submitModel.supplierCity = value.trim();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          // height: 80,
                          // width: context.deviceWidth() * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StyledText(
                                text: 'ZIP Code / Postal Code '
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
                                        color: sccDanger),
                                  )
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomFormTextField(
                                hint: 'Input ZIP Code / Postal Code',
                                controller: postalSuppCo,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is mandatory";
                                  } else if (value.trim().length > 25) {
                                    return "Only 25 characters for maximum allowed";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  if (value != null) {
                                    submitModel.postalCd = value.trim();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StyledText(
                      text: 'Phone Number '
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
                    CustomDropdown(
                      style: TextStyle(
                          fontSize: context.scaleFont(14),
                          fontWeight: FontWeight.w400),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      initialValue: phoneSuppCo.text,
                      flagsButtonMargin: const EdgeInsets.all(5),
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
                      initialCountryCode: countryFlag ?? 'ID',
                      width: context.deviceWidth() * 0.6,
                      height: context.deviceHeight() * 0.5,
                      onChanged: (phone) {
                        // phoneSuppCo.text = phone.completeNumber.toString();
                        // submitModel.supplierContactNo = phoneSuppCo.text;
                        phoneSuppCo.text = phone.number.toString();
                        submitModel.supplierContactNo = phoneSuppCo.text;
                        // submitModel.dialCode = phone.countryCode.toString();
                      },
                      onCountryChanged: (country) {
                        submitModel.dialCode = "+${country.dialCode}";
                      },
                    ),
                    const SizedBox(height: 20),
                    StyledText(
                      text: 'Address '
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
                      hint: 'Input Address',
                      maxLine: 5,
                      controller: addressSuppCo,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is mandatory";
                        } else if (value.trim().length > 500) {
                          return "Only 500 characters for maximum allowed";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if (value != null) {
                          submitModel.supplierAddr = value.trim();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Visibility(
                visible: widget.formMode != Constant.viewMode,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonCancel(
                      text: "Cancel",
                      width: context.deviceWidth() *
                          (context.isDesktop() ? 0.13 : 0.37),
                      borderRadius: 8,
                      // marginVertical: !isMobile ? 11 : 8,
                      onTap: () => widget.onClose(),
                    ),
                    SizedBox(
                      width: 8.wh,
                    ),
                    ButtonConfirm(
                      text: widget.formMode == Constant.addMode
                          ? "Submit"
                          : "Save",
                      // verticalMargin: !isMobile ? 11 : 8,
                      width: context.deviceWidth() *
                          (context.isDesktop() ? 0.13 : 0.37),
                      borderRadius: 8,
                      onTap: () {
                        if (key.currentState!.validate()) {
                          if (submitModel.dialCode == null ||
                              submitModel.dialCode == "") {
                            submitModel.dialCode = '+62';
                          }
                          onConfirm(submitModel);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
