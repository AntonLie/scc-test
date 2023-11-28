import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/mst_template_attribute/bloc/template_attribute_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/point.dart';
import 'package:scc_web/model/temp_attr.dart';

import 'package:scc_web/screens/MasterPoint/template_showdialog.dart';
import 'package:scc_web/screens/inventory/scc_typeahead.dart';
import 'package:scc_web/screens/master_template_attr/view_temp_attr_dialog.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/dropzone_widget.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/shared_widgets/ta_dropdown.dart';
import 'package:scc_web/shared_widgets/vcc_checkbox_tile.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:styled_text/styled_text.dart';

class PointForm extends StatefulWidget {
  final List<KeyVal> listPointTyp;
  final List<KeyVal> listTyp;
  final List<KeyVal> listProType;
  final List<KeyVal> listNodeBlock;
  final List<KeyVal> listTemplateAttr;
  final List<KeyVal> listAttr;
  final String formMode;
  final Function() onClose;
  final ViewPointModel? model;
  final Function(ViewPointModel?) onSubmit;
  const PointForm(
      {super.key,
      this.model,
      required this.listPointTyp,
      required this.listTyp,
      required this.listProType,
      required this.onClose,
      required this.listTemplateAttr,
      required this.listAttr,
      required this.onSubmit,
      required this.formMode,
      required this.listNodeBlock});

  @override
  State<PointForm> createState() => _PointFormState();
}

class _PointFormState extends State<PointForm> {
  List<KeyVal> listPointTyp = [];
  List<KeyVal> listTyp = [];
  List<KeyVal> listProType = [];

  String? selectedListPoint;
  List<KeyVal> selectedListNodeBlock = [];
  String? selectedlistTyp;
  String? selectedlistProType;
  late TextEditingController pointName;
  late TextEditingController pointDesc;
  late TextEditingController pointSuffix;
  late TextEditingController maxLiv;
  late TextEditingController maxDate;
  Uint8List? fileBytes;
  String? fileNameIcon;
  String? base64File;
  ViewPointModel submitModel = ViewPointModel();
  // GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isHovered = false;
  bool consume = false;
  bool type = false;
  List<String> attri = [];
  bool validateList = false;
  List<KeyVal> listTemplateAttr = [];
  String? selectedTemplateAttr;
  String? onDate;
  String? inDate;

  List<KeyVal> listAttr = [];
  @override
  void initState() {
    listPointTyp = widget.listPointTyp;
    listTyp = widget.listTyp;
    listProType = widget.listProType;

    if (widget.model != null) {
      submitModel = widget.model!;
    }

    if (submitModel.iconBase64 != null) {
      fileNameIcon = submitModel.iconName;
      base64File = submitModel.iconBase64;
    }
    if (submitModel.nodeBlockchain != null) {
      for (var element in submitModel.nodeBlockchain!) {
        for (var e in widget.listNodeBlock) {
          if (element == e.value) {
            selectedListNodeBlock.add(KeyVal(e.label, e.value));
          }
        }
      }
    }
    selectedListPoint = submitModel.pointTypeCd;
    onDate = submitModel.pointAttrInOutdate;
    inDate = submitModel.pointAttrIndate;
    selectedlistProType = submitModel.pointProductCd;
    selectedlistTyp = submitModel.pointType ?? "ITEM";
    listTemplateAttr = widget.listTemplateAttr;
    selectedTemplateAttr = submitModel.tmplAttrCd;
    listAttr = widget.listAttr;
    if (submitModel.attrKey != null) {
      for (var i in listAttr) {
        for (var element in submitModel.attrKey!) {
          if (element == i.value) {
            attri.add(i.value);
          }
        }
      }
    } else {
      attri.add("");
    }
    if (submitModel.pointType != null) {
      if (submitModel.pointType!.toUpperCase() == 'CONSUME') {
        consume = true;
        type = true;
      }
    }
    pointName = TextEditingController(text: submitModel.pointName ?? "");
    pointSuffix = TextEditingController(text: submitModel.pointCdSuffix ?? "");
    maxLiv = TextEditingController(
        text: ((submitModel.maxLiveness ?? 30)).toString());
    maxDate = TextEditingController(
        text: ((submitModel.maxConsumeDt ?? 48)).toString());
    pointDesc = TextEditingController(text: submitModel.pointDesc ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> key = GlobalKey<FormState>();

    removeItem(int index) {
      setState(() {
        attri = List.from(attri)..removeAt(index);

        validateList = attri.isEmpty;
      });
    }

    return Form(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.formMode == Constant.addMode
                      ? "New Point"
                      : "Edit Point",
                  style: TextStyle(
                    fontSize: context.scaleFont(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(
                  color: sccLightGrayDivider,
                  height: 25,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: context.deviceWidth() * 0.37,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            text: 'Point Type'
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
                          TAFormDropdown(
                            selectedListPoint,
                            listPointTyp,
                            hideKeyboard: false,
                            hintText: 'Selected Point Type',
                            enabled: widget.formMode == Constant.addMode,
                            onChange: (val) {
                              selectedListPoint = val;
                              submitModel.pointTypeCd = val;
                            },
                            onStrChange: (val) {
                              if (val!.isEmpty) {
                                setState(() {
                                  selectedListPoint = val;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is mandatory";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          StyledText(
                            text: 'Type'
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
                          TAFormDropdown(
                            selectedlistTyp,
                            listTyp,
                            hintText: "Select Type",
                            enabled: widget.formMode == Constant.addMode,
                            onChange: (value) {
                              selectedlistTyp = value;
                              submitModel.pointType = value;

                              if (value!.toUpperCase() == 'CONSUME') {
                                setState(() {
                                  consume = true;
                                  type = true;
                                });
                              } else {
                                setState(() {
                                  consume = false;
                                });
                              }
                            },
                            onStrChange: (val) {
                              if (val!.isEmpty) {
                                setState(() {
                                  selectedlistTyp = val;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is mandatory";
                              } else {
                                return null;
                              }
                            },
                          ),
                          Visibility(
                            visible: consume,
                            child: VccCheckboxTile(
                                title: 'Master Consume or bill of Material',
                                enabled: consume,
                                value: type,
                                onChanged: (val) {
                                  setState(() {
                                    type = val;
                                  });
                                }),
                          ),
                          const SizedBox(height: 20),
                          StyledText(
                            text: 'Product Type'
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
                          TAFormDropdown(
                            selectedlistProType,
                            listProType,
                            hideKeyboard: false,
                            hintText: 'Selected Product Type',
                            enabled: widget.formMode == Constant.addMode,
                            onChange: (val) {
                              selectedlistProType = val;
                              submitModel.pointProductCd = val;
                            },
                            onStrChange: (val) {
                              if (val!.isEmpty) {
                                setState(() {
                                  selectedlistProType = val;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is mandatory";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          StyledText(
                            text: 'Node Blockchain'
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
                          SccMultipleTypeAheadKeyVal(
                            selectedItems: selectedListNodeBlock,
                            url: "${dotenv.get('sccMasterMain')}/system",
                            apiKeyLabel: "systemValue",
                            apiKeyValue: "systemCd",
                            hintText: selectedListNodeBlock.isNotEmpty
                                ? ""
                                : "select Node Block",
                            additionalParam: const {
                              "pageSize": "1000",
                              "pageNo": "1",
                              "systemTypeCd": "ENTITY_CODE",
                            },
                            fillColor: sccWhite,
                            onLogout: () {},
                            onError: (value) {
                              showTopSnackBar(
                                  context,
                                  UpperSnackBar.error(
                                      message: value ?? "Error occured"));
                            },
                            onSelectionChange: (value) {
                              setState(() {
                                selectedListNodeBlock = List.from(value);
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
                        ],
                      ),
                    ),
                    SizedBox(
                      width: context.deviceWidth() * 0.38,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            text: 'Point Name'
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
                            hint: 'Input Point Name',
                            controller: pointName,
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
                                submitModel.pointName = value;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          StyledText(
                            text: 'Point Code Suffix'
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
                            hint: 'Input Point Suffix',
                            controller: pointSuffix,
                            enabled: widget.formMode == Constant.addMode,
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
                                submitModel.pointCdSuffix = value;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          StyledText(
                            text: 'Max Liveness (in Seconds)'
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
                            hint: 'Input Max Liveness',
                            controller: maxLiv,
                            inputformat: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                                submitModel.maxLiveness = int.parse(value);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          StyledText(
                            text: 'Maximum Date to Consume (in Hour)'
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
                            controller: maxDate,
                            hint: 'Input Username',
                            inputformat: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                                submitModel.maxConsumeDt = int.parse(value);
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                StyledText(
                  text: 'Point Description'
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
                  hint: 'Input Description',
                  controller: pointDesc,
                  maxLine: 5,
                  onChanged: (value) {
                    if (value != null) {
                      submitModel.pointDesc = value;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is mandatory";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                Dropzone(
                    fileName: fileNameIcon,
                    base64: base64File,
                    formMode: widget.formMode,
                    onSubmit: (val) {
                      setState(() {
                        fileNameIcon = val.attrIconPath;
                        base64File = val.fileBase64;
                      });
                    }),
              ],
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Attribut Key',
                      style: TextStyle(
                        fontSize: context.scaleFont(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      color: sccLightGrayDivider,
                      height: 25,
                      thickness: 2,
                    ),
                    const SizedBox(height: 20),
                    StyledText(
                      text: 'Template Attribute'
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
                    TAFormDropdown(
                      selectedTemplateAttr,
                      listTemplateAttr,
                      hideKeyboard: false,
                      hintText: 'Selected Template Attribute',
                      onChange: (val) {
                        setState(() {
                          selectedTemplateAttr = val;
                        });
                        submitModel.tmplAttrCd = val;
                      },
                      onStrChange: (val) {
                        if (val!.isEmpty) {
                          setState(() {
                            selectedTemplateAttr = val;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is mandatory";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                        visible: selectedTemplateAttr != null &&
                            selectedTemplateAttr!.isNotEmpty &&
                            selectedTemplateAttr != "",
                        child: InkWell(
                          onTap: () {
                            TempAttr model =
                                TempAttr(tempAttrCd: selectedTemplateAttr);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return BlocProvider(
                                      create: (context) =>
                                          TemplateAttributeBloc()
                                            ..add(
                                                ViewTemplateAttr(model: model)),
                                      child: const ViewDialogTempAttr(
                                        point: "",
                                        canUpdate: false,
                                      ));
                                });
                          },
                          child: Row(
                            children: [
                              HeroIcon(
                                HeroIcons.eye,
                                color: sccBlue,
                              ),
                              Text(
                                'View Template Attribute',
                                style: TextStyle(color: sccBlue),
                              )
                            ],
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: context.deviceWidth() * 0.37,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              StyledText(
                                text: 'out date from touch point'
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
                                width: context.deviceWidth() * 0.37,
                                child: LovTemplateAttrDialog(
                                  selectedTemplateAttr: submitModel.tmplAttrCd,
                                  dataType: "ADT_DT_TM",
                                  selectedData: onDate == "" ? null : onDate,
                                  onAttrCdChange: (value) {
                                    setState(() {
                                      onDate = value!.attrApiKey;
                                    });
                                    submitModel.pointAttrInOutdate =
                                        value!.attrApiKey;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: context.deviceWidth() * 0.37,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              StyledText(
                                text: 'In date to touch point'
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
                                width: context.deviceWidth() * 0.37,
                                child: LovTemplateAttrDialog(
                                  selectedTemplateAttr: submitModel.tmplAttrCd,
                                  dataType: "ADT_DT_TM",
                                  selectedData: inDate == "" ? null : inDate,
                                  onAttrCdChange: (value) {
                                    setState(() {
                                      inDate = value!.attrApiKey;
                                    });
                                    submitModel.pointAttrIndate =
                                        value!.attrApiKey;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: context.deviceWidth(),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: attri.isNotEmpty ? attri.length : 1,
                          itemBuilder: (context, index) {
                            if (attri.isNotEmpty) {
                              return PointAddNew(
                                index: index,
                                selectedTemplateAttr: selectedTemplateAttr,
                                attr: (val) {
                                  attri[index] = val!;
                                },
                                attriStr: attri[index],
                                onCLose: (key) {
                                  removeItem(index);
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: validateList,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Text(
                              'Point list must not empty',
                              style: TextStyle(
                                fontSize: context.scaleFont(14),
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DottedAddButton(
                      text: "Add Attribute Key",
                      width: context.deviceWidth() * 0.20,
                      onTap: () {
                        setState(() {
                          validateList = false;

                          attri.add("");
                        });
                      },
                    ),
                  ])),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    // context.push(
                    //     const MasterAdminRoute());
                    widget.onClose();
                  },
                ),
                SizedBox(
                  width: 8.wh,
                ),
                ButtonConfirm(
                  text:
                      widget.formMode == Constant.editMode ? "Save" : "Submit",
                  onTap: () {
                    if (key.currentState!.validate() &&
                        !validateList &&
                        selectedListNodeBlock.isNotEmpty) {
                      submitModel.maxLiveness ??= 30;
                      submitModel.maxConsumeDt ??= 48;
                      submitModel.iconBase64 = "$fileNameIcon,$base64File";
                      setState(() {
                        submitModel.attrKey = attri;
                        submitModel.nodeBlockchain = [];
                      });
                      for (var element in selectedListNodeBlock) {
                        submitModel.nodeBlockchain!.add(element.value);
                      }
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return ConfirmSaveDialog(
                              sTitle: "Attribute",
                              sValue: submitModel.pointName,
                              onSave: () {
                                context.closeDialog();
                                submitModel.pointType ??= "ITEM";
                                submitModel.flagConsume = type;
                                if (submitModel.pointType == "ITEM" ||
                                    submitModel.flagConsume == null) {
                                  submitModel.flagConsume = false;
                                }

                                widget.onSubmit(submitModel);
                              },
                            );
                          });
                    }
                  },
                  width: context.deviceWidth() *
                      (context.isDesktop() ? 0.13 : 0.37),
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PointAddNew extends StatefulWidget {
  final int index;
  final String? selectedTemplateAttr;
  final String? attriStr;
  final Function(String?) attr;
  final Function(Key?) onCLose;
  const PointAddNew({
    super.key,
    required this.attr,
    required this.index,
    required this.onCLose,
    this.selectedTemplateAttr,
    this.attriStr,
  });

  @override
  State<PointAddNew> createState() => _PointAddNewState();
}

class _PointAddNewState extends State<PointAddNew> {
  String? selectedAttr;
  List<String>? attri;
  @override
  void initState() {
    selectedAttr = widget.attriStr;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: context.deviceWidth(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledText(
                  text: 'Attribute Key'
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
                Visibility(
                  visible: widget.index >= 0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => widget.onCLose(widget.key),
                      child: Text(
                        "Remove Point Code",
                        style: TextStyle(
                            color: sccRed, fontSize: context.scaleFont(14)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: context.deviceWidth(),
              child: LovTemplateAttrDialog(
                selectedTemplateAttr: widget.selectedTemplateAttr,
                selectedData: selectedAttr == "" ? null : selectedAttr,
                onAttrCdChange: (value) {
                  setState(() {
                    selectedAttr = value!.attributeCd;
                    widget.attr(selectedAttr);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
