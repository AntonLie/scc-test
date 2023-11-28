// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';

import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/screens/master_package/pkg_info.dart';
import 'package:scc_web/screens/master_package/role_field.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_checkbox.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class PackageFormBody extends StatefulWidget {
  final Function(PackageData) onSubmit;
  final Function() onClose;
  final String formMode;
  final List<KeyVal> listBlock;
  final List<KeyVal> colorOpt;
  final PackageData? model;
  const PackageFormBody(
      {super.key,
      required this.formMode,
      this.model,
      required this.colorOpt,
      required this.listBlock,
      required this.onSubmit,
      required this.onClose});

  @override
  State<PackageFormBody> createState() => _PackageFormBodyState();
}

class _PackageFormBodyState extends State<PackageFormBody> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  PackageData submitModel = PackageData();

  late TextEditingController pkgName;
  late TextEditingController packageDesc;
  late TextEditingController noAcc;
  late TextEditingController noSupp;
  late TextEditingController noParts;
  late TextEditingController noPoints;
  late TextEditingController pricePkg;
  late TextEditingController gasFeeCo;
  bool validateList = false;
  bool? boolSelected;
  String? typeSelected;
  KeyVal? colorSelected;
  List<KeyVal> listBlock = [];
  List<KeyVal> colorOpts = [];
  String? inventorySelected;

  List<KeyVal> nodeSelected = [];
  List<PackageInfo> pkgInfo = [];
  // List<PackageDetail> listRole = [];
  List<Role> listRole = [];

  String? templateAttrSelected;
  String? pointTypeCdSelected;
  @override
  void initState() {
    if (widget.model != null) {
      submitModel = widget.model!;

      if (submitModel.role != null) {
        listRole.addAll(submitModel.role!);
        for (var element in listRole) {
          if (element.roleCd != null) {
            nodeSelected.add(
                KeyVal(element.roleCd ?? "[UNIDENTIFIED]", element.roleCd!));
          }
        }
      }
    }

    pkgInfo.addAll(submitModel.packageInfo ??
        [PackageInfo(packageInfo: "", packageInfoDesc: "")]);

    boolSelected = submitModel.statusBlockchain ?? false;

    colorOpts.addAll(widget.colorOpt);
    colorSelected = colorOpts.firstWhere(
        (element) => element.value == submitModel.colorCd,
        orElse: () => KeyVal("", ""));
    listBlock.addAll(widget.listBlock);
    pkgName = TextEditingController(text: submitModel.packageName ?? "");
    noAcc = TextEditingController(
        text: (submitModel.totalAccount ?? "").toString());
    noParts =
        TextEditingController(text: (submitModel.totalPart ?? "").toString());
    pricePkg = TextEditingController(
        text: (submitModel.pricePackage ?? "").toString());
    gasFeeCo =
        TextEditingController(text: (submitModel.gasFee ?? "").toString());
    noSupp = TextEditingController(
        text: (submitModel.totalSupplier ?? "").toString());
    noPoints =
        TextEditingController(text: (submitModel.totalPoint ?? "").toString());
    packageDesc =
        TextEditingController(text: (submitModel.packageDesc ?? "").toString());

    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Column(
        children: [
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
                color: isMobile ? Colors.transparent : Colors.white,
                borderRadius: BorderRadius.circular(8)),
            child: FocusTraversalGroup(
              descendantsAreFocusable: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.formMode == Constant.addMode)
                        ? "New Package Form"
                        : "Edit Package Form",
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
                    text: 'Package Name <r>*</r>',
                    style: TextStyle(fontSize: context.scaleFont(16)),
                    tags: {
                      'r': StyledTextTag(
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              color: sccDanger))
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomFormTextField(
                    controller: pkgName,
                    hint: 'Input Package Name',
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
                        submitModel.packageName = value.trim();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  StyledText(
                    text: ' Package Desc <r>*</r>',
                    style: TextStyle(fontSize: context.scaleFont(16)),
                    tags: {
                      'r': StyledTextTag(
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              color: sccDanger))
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomFormTextField(
                    controller: packageDesc,
                    hint: 'Input Package Desc',
                    maxLine: 5,
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
                        submitModel.packageDesc = value.trim();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  StyledText(
                    text: 'Number of Supplier <r>*</r>',
                    style: TextStyle(fontSize: context.scaleFont(16)),
                    tags: {
                      'r': StyledTextTag(
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              color: sccDanger))
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomFormTextField(
                    controller: noSupp,
                    hint: 'Input Number of Supplier',
                    enabled: widget.formMode != Constant.viewMode,
                    inputType: TextInputType.number,
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
                        submitModel.totalSupplier = int.tryParse(value) ?? 0;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  StyledText(
                    text: 'Number of Accounts <r>*</r>',
                    style: TextStyle(fontSize: context.scaleFont(16)),
                    tags: {
                      'r': StyledTextTag(
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              color: sccDanger))
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomFormTextField(
                    controller: noAcc,
                    hint: 'Input Number of Accounts',
                    enabled: widget.formMode != Constant.viewMode,
                    inputType: TextInputType.number,
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
                        submitModel.totalAccount = int.tryParse(value) ?? 0;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  StyledText(
                    text: 'Number of Points <r>*</r>',
                    style: TextStyle(fontSize: context.scaleFont(16)),
                    tags: {
                      'r': StyledTextTag(
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              color: sccDanger))
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomFormTextField(
                    controller: noPoints,
                    hint: 'Input Number of Points',
                    // focusNode: focusPointCdSuffix,
                    inputType: TextInputType.number,
                    enabled: widget.formMode != Constant.viewMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is mandatory";
                      } else if (value.trim().length > 20) {
                        return "Only 20 characters for maximum allowed";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      if (value != null) {
                        submitModel.totalPoint = int.parse(value);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StyledText(
                    text: 'Number of Items <r>*</r>',
                    style: TextStyle(fontSize: context.scaleFont(16)),
                    tags: {
                      'r': StyledTextTag(
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              color: sccDanger))
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomFormTextField(
                    controller: noParts,
                    hint: 'Input Number of Items',
                    // focusNode: focusPointCdSuffix,
                    inputType: TextInputType.number,
                    enabled: widget.formMode != Constant.viewMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is mandatory";
                      } else if (value.trim().length > 20) {
                        return "Only 20 characters for maximum allowed";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      if (value != null) {
                        submitModel.totalPart = int.parse(value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  StyledText(
                    text: 'Role <r>*</r>',
                    style: TextStyle(fontSize: context.scaleFont(16)),
                    tags: {
                      'r': StyledTextTag(
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              color: sccDanger))
                    },
                  ),
                  const SizedBox(height: 10),
                  RoleField(
                    nodeSelected,
                    hintText: "Select Role",
                    enabled: widget.formMode != Constant.viewMode,
                    nameDialog: 'Bussiness Package',
                    onChange: (value) {
                      setState(() {
                        nodeSelected = List.from(value);
                        listRole.clear();
                        for (var e in nodeSelected) {
                          Role pkgDtl = Role();
                          pkgDtl.roleCd = e.value;
                          listRole.add(pkgDtl);
                        }
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
                  const SizedBox(
                    height: 20,
                  ),
                  StyledText(
                    text: 'BlockChain <r>*</r> ',
                    style: TextStyle(fontSize: context.scaleFont(16)),
                    tags: {
                      'r': StyledTextTag(
                          style: TextStyle(
                              fontSize: context.scaleFont(16),
                              color: sccDanger)),
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          // width: context.deviceWidth() * (isMobile ? 0.5 : 0.2),
                          child: CustomCheckboxListTile(
                            enabled:
                                true, // widget.formMode != Constant.FORM_MODE_VIEW,
                            value: boolSelected,
                            mandatory: false,
                            title: boolSelected == true ? 'Active' : 'inActive',
                            onChanged: (newBool) {
                              setState(() {
                                boolSelected = !boolSelected!;
                              });
                              submitModel.statusBlockchain = boolSelected;
                            },
                          ),
                        ),
                      ),
                    ],
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
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                color: isMobile ? Colors.transparent : Colors.white,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Package Price",
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
                  text: 'Price Package(Yearly)<r>*</r> ',
                  style: TextStyle(fontSize: context.scaleFont(16)),
                  tags: {
                    'r': StyledTextTag(
                        style: TextStyle(
                            fontSize: context.scaleFont(16), color: sccDanger)),
                  },
                ),
                const SizedBox(height: 10),
                CustomFormTextField(
                  controller: pricePkg,
                  hint: 'Input Price Package',
                  prefix: Container(
                    width: context.deviceWidth() * 0.027,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: const BoxDecoration(
                        border: Border(
                            right: BorderSide(width: 0.4, color: sccBlack))),
                    child: const Text(
                      'IDR',
                      style: TextStyle(
                          color: sccBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // inputType: TextInputType.numberWithOptions(decimal: true),
                  inputformat: [
                    CurrencyTextInputFormatter(
                      decimalRange: 4, //locale: locale.countryCode
                    )
                  ],
                  enabled: widget.formMode != Constant.viewMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is mandatory";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    if (value != null) {
                      submitModel.pricePackage =
                          int.tryParse(value.decimalRpFormatter) ?? 0;
                    }
                  },
                ),
                const SizedBox(height: 20),
                StyledText(
                  text: 'Gas Fee (Per Transaction)<r>*</r> ',
                  style: TextStyle(fontSize: context.scaleFont(16)),
                  tags: {
                    'r': StyledTextTag(
                        style: TextStyle(
                            fontSize: context.scaleFont(16), color: sccDanger)),
                  },
                ),
                const SizedBox(height: 10),
                CustomFormTextField(
                  controller: gasFeeCo,
                  prefix: Container(
                    width: context.deviceWidth() * 0.027,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: const BoxDecoration(
                        border: Border(
                            right: BorderSide(width: 0.4, color: sccBlack))),
                    child: const Text(
                      'IDR',
                      style: TextStyle(
                          color: sccBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  hint: 'input gas fee',

                  // inputType: TextInputType.numberWithOptions(decimal: true),
                  inputformat: [
                    CurrencyTextInputFormatter(
                      decimalRange: 4, //locale: locale.countryCode
                    )
                  ],
                  enabled: widget.formMode != Constant.viewMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is mandatory";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    if (value != null) {
                      submitModel.gasFee =
                          int.tryParse(value.decimalRpFormatter) ?? 0;
                    }
                  },
                ),
                const SizedBox(height: 20),
                StyledText(
                  text: 'Color', //+ (' <r>*</r>'),
                  style: TextStyle(fontSize: context.scaleFont(16)),
                  tags: {
                    'r': StyledTextTag(
                        style: TextStyle(
                            fontSize: context.scaleFont(16), color: sccDanger))
                  },
                ),
                const SizedBox(height: 10),
                ColorDropdown(
                  colorSelected,
                  colorOpts,
                  hintText: "Select Color",
                  enabled: widget.formMode != Constant.viewMode,
                  onChange: (value) {
                    setState(() {
                      colorSelected = value;
                    });
                    submitModel.colorCd = colorSelected!.value;
                  },
                  validator: (value) {
                    if (colorSelected == null ||
                        colorSelected?.value.isEmpty == true) {
                      return "This field is mandatory";
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
                  color: isMobile ? Colors.transparent : Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Package Information",
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
                    Visibility(
                      visible: pkgInfo.isNotEmpty,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: pkgInfo.isNotEmpty ? pkgInfo.length : 1,
                          itemBuilder: (context, index) {
                            if (pkgInfo.isNotEmpty) {
                              return PkgInfoForm(
                                index: index,
                                value: pkgInfo[index],
                                enabled: widget.formMode != Constant.viewMode,
                                removable: pkgInfo.length > 1,
                                onChange: (val) {
                                  pkgInfo[index].packageInfo = val ?? "";
                                },
                                onClose: () {
                                  setState(() {
                                    pkgInfo.removeAt(index);
                                  });
                                },
                                onChangeDesc: (val) {
                                  pkgInfo[index].packageInfoDesc = val ?? "";
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                    ),
                    Visibility(
                      visible: widget.formMode != Constant.viewMode,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          DottedAddButton(
                            text: "Add Package Information",
                            width: context.deviceWidth() * 0.18,
                            onTap: () {
                              setState(() {
                                validateList = false;
                                pkgInfo.add(PackageInfo());
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: validateList,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              'Information list must not empty',
                              style: TextStyle(
                                fontSize: context.scaleFont(16),
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
          const SizedBox(height: 20),
          Visibility(
            visible: widget.formMode != Constant.viewMode,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment:
                  isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
              children: [
                ButtonCancel(
                  text: "Cancel",
                  width: context.deviceWidth() *
                      (context.isDesktop() ? 0.13 : 0.37),
                  borderRadius: 8,
                  onTap: () {
                    widget.onClose();
                  },
                ),
                SizedBox(
                  width: 8.wh,
                ),
                ButtonConfirm(
                  width: context.deviceWidth() *
                      (context.isDesktop() ? 0.13 : 0.37),
                  borderRadius: 8,
                  text:
                      widget.formMode == Constant.editMode ? "Save" : "Submit",
                  onTap: () {
                    setState(() {
                      validateList = pkgInfo.isEmpty;
                    });
                    if (key.currentState!.validate() && !validateList) {
                      setState(() {
                        submitModel.role = List.from(listRole);
                        submitModel.packageInfo = List.from(pkgInfo);
                      });
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return ConfirmSaveDialog(
                              sTitle: "Attribute",
                              sValue: submitModel.packageName,
                              onSave: () {
                                context.closeDialog();
                                widget.onSubmit(submitModel);
                              },
                            );
                          });
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
