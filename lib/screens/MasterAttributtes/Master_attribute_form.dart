// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/mst_attr/bloc/mst_attr_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/master_attribute.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';
import 'package:dotted_border/dotted_border.dart';

class MstAttrForm extends StatefulWidget {
  final MstAttribute? model;
  final String? formMode;
  // final String searchUrl, searchMethod, createUrl, createMethod, updateUrl, updateMethod;
  final List<SystemMaster> listAttrDataType;
  final List<SystemMaster> listAttrType;
  final Function() onClose;
  final Function(MstAttrSubmitted) onSuccesSubmit;
  final Paging paging;
  const MstAttrForm(
      {super.key,
      this.model,
      this.formMode,
      required this.listAttrDataType,
      required this.listAttrType,
      required this.onClose,
      required this.onSuccesSubmit,
      required this.paging});

  @override
  State<MstAttrForm> createState() => _MstAttrFormState();
}

class _MstAttrFormState extends State<MstAttrForm> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  MstAttribute submitModel = MstAttribute();
  DropzoneViewController? controllerDz;

  String? typeSelected;

  late TextEditingController attrCdCo;
  late TextEditingController attrNameCo;
  late TextEditingController attrApiKeyCo;
  late TextEditingController attrDataTypeLengthCo;
  late TextEditingController attrDataTypePrecCo;
  late TextEditingController attrDescCo;
  late TextEditingController attrIconName;

  DateTime? validFromSelected;
  DateTime? validToSelected;

  List<KeyVal> attrDataTypeOpt = [];
  List<KeyVal> attrTypeOpt = [];
  List<dynamic> listFiles = [];

  String? attrTypeSelected;
  String? attrDataTypeSelected;
  Uint8List? fileBytes;
  String? fileNameIcon;
  String? base64File;
  bool isHovered = false;
  bool formatValidate = false;

  @override
  void initState() {
    for (var element in widget.listAttrType) {
      if (element.systemCd != null) {
        attrTypeOpt.add(
            KeyVal(element.systemValue ?? "[Undefined]", element.systemCd!));
      }
    }
    for (var element in widget.listAttrDataType) {
      if (element.systemCd != null) {
        attrDataTypeOpt.add(
            KeyVal(element.systemValue ?? "[Undefined]", element.systemCd!));
      }
    }

    if (widget.model != null) {
      submitModel = widget.model!;
    }
    if (submitModel.iconBase64 != null) {
      fileBytes = base64Decode(submitModel.iconBase64!);
    }

    attrCdCo = TextEditingController(text: submitModel.attributeCd);
    attrNameCo = TextEditingController(text: submitModel.attributeName);
    attrApiKeyCo = TextEditingController(text: submitModel.attrApiKey ?? "");
    attrDataTypeLengthCo = TextEditingController(
        text: (submitModel.attrDataTypeLen ?? "").toString());
    attrDataTypePrecCo = TextEditingController(
        text: (submitModel.attrDataTypePrec ?? "").toString());
    attrDescCo = TextEditingController(text: submitModel.attrDesc);
    attrIconName = TextEditingController(text: fileNameIcon);
    attrTypeSelected = submitModel.attrTypeCd;
    attrDataTypeSelected = submitModel.attrDataTypeCd;

    if (widget.formMode == Constant.addMode) {
      attrTypeSelected = attrTypeOpt[0].value;
      submitModel.attrTypeCd = attrTypeSelected;
      attrDataTypeSelected = attrDataTypeOpt[0].value;
      submitModel.attrDataTypeCd = attrDataTypeSelected;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc(MstAttrEvent event) {
      BlocProvider.of<MstAttrBloc>(context).add(event);
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
        BlocListener<MstAttrBloc, MstAttrState>(
          listener: (context, state) {
            if (state is MstAttrError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.error));
            }
            if (state is MstAttrSubmitted) {
              widget.onSuccesSubmit(state);
            }
          },
        ),
      ],
      child: Container(
        // ignore: prefer_const_constructors
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isMobile ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Form(
          key: key,
          child: FocusTraversalGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      StyledText(
                        text:
                            'Attribute Code${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
                        style: TextStyle(
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400),
                        tags: {
                          'r': StyledTextTag(
                            style: TextStyle(
                                fontSize: context.scaleFont(14),
                                fontWeight: FontWeight.w400,
                                color: sccDanger),
                          ),
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomFormTextField(
                        hint: "Input Attribute Code",
                        controller: attrCdCo,
                        // focusNode: focusAttrCd,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: sccFillLoginField)),
                        enabled: widget.formMode == Constant.addMode,
                        onChanged: (value) {
                          submitModel.attributeCd = value?.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is mandatory";
                          } else if (validateCode(value)) {
                            return "Only letters, capitalized letters, numbers, hypen (-), and underscores (_) are allowed";
                          } else if (value.trim().length > 50) {
                            return "Only 50 characters for maximum allowed";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StyledText(
                        text:
                            'Attribute Name${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                        controller: attrNameCo,
                        hint: "Input Attribute Name",
                        // focusNode: focusAttrName,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: sccFillLoginField)),
                        enabled: widget.formMode != Constant.viewMode,
                        onChanged: (value) {
                          submitModel.attributeName = value?.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is mandatory";
                          } else if (value.trim().length > 100) {
                            return "Only 100 characters for maximum allowed";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: StyledText(
                          text:
                              'Attribute API Key${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormTextField(
                        controller: attrApiKeyCo,
                        hint: "Input Attribute Api Key",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: sccFillLoginField)),
                        // focusNode: focusAttrApiKey,
                        enabled: widget.formMode == Constant.addMode,
                        onChanged: (value) {
                          submitModel.attrApiKey = value?.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is mandatory";
                          } else if (validateApiKey(value)) {
                            return "Only letters, capitalized letters, and numbers allowed";
                          } else if (value.trim().length > 50) {
                            return "Only 50 characters for maximum allowed";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: StyledText(
                          text:
                              'Attribute Type Code${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PortalFormDropdown(
                        attrTypeSelected,
                        attrTypeOpt,
                        hintText: "Select Type Code",
                        enabled: attrTypeOpt.isNotEmpty &&
                            widget.formMode != Constant.viewMode,
                        onChange: (value) {
                          setState(() {
                            attrTypeSelected = value;
                            submitModel.attrTypeCd = attrTypeSelected;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: StyledText(
                          text:
                              'Attribute Data Type Code${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PortalFormDropdown(
                        attrDataTypeSelected,
                        attrDataTypeOpt,
                        hintText: "Select Data Type Code",
                        enabled: attrDataTypeOpt.isNotEmpty &&
                            widget.formMode != Constant.viewMode,
                        onChange: (value) {
                          setState(() {
                            attrDataTypeSelected = value;
                            submitModel.attrDataTypeCd = attrDataTypeSelected;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: StyledText(
                          text:
                              'Data Type Length${(widget.formMode != Constant.viewMode) ? '' : ''}',
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
                      ),
                      const SizedBox(height: 10),
                      CustomFormTextField(
                        hint: "Input Data Type Length e.g 10",
                        controller: attrDataTypeLengthCo,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: sccFillLoginField)),
                        // focusNode: focusDataTypeLen,
                        maxLength: 9,
                        inputType: TextInputType.number,
                        enabled: widget.formMode != Constant.viewMode,
                        onChanged: (value) {
                          submitModel.attrDataTypeLen =
                              int.parse((value ?? "0").number);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: StyledText(
                          text:
                              'Data Type Precision ${(widget.formMode != Constant.viewMode) ? '' : ''}',
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
                      ),
                      const SizedBox(height: 10),
                      CustomFormTextField(
                        hint: "Input Data Type Precision e.g 22",
                        controller: attrDataTypePrecCo,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: sccFillLoginField)),
                        // focusNode: focusDataTypePrec,
                        maxLength: 9,
                        inputType: TextInputType.number,
                        enabled: widget.formMode != Constant.viewMode,
                        onChanged: (value) {
                          submitModel.attrDataTypePrec =
                              int.parse((value ?? "0").number);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: StyledText(
                          text:
                              'Description${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                      ),
                      const SizedBox(height: 10),
                      CustomFormTextField(
                        controller: attrDescCo,
                        maxLine: 5,
                        hint: "Input Attribute Description",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: sccFillLoginField)),
                        // focusNode: focusAttrDesc,
                        enabled: widget.formMode != Constant.viewMode,
                        onChanged: (value) {
                          submitModel.attrDesc = value?.trim();
                        },
                        validator: (value) {
                          if (value != null &&
                              value.trim().isNotEmpty &&
                              value.trim().length > 250) {
                            return "Only 250 characters for maximum allowed";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: widget.formMode != Constant.viewMode,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: StyledText(
                                text:
                                    'Upload Icon${(widget.formMode != Constant.viewMode) ? '' : ''}',
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
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      accFileMobile();
                                    },
                                    child: DottedBorder(
                                      color: sccHintText,
                                      strokeWidth: 2,
                                      borderType: BorderType.RRect,
                                      dashPattern: const [10, 7],
                                      radius: const Radius.circular(8),
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        width: context.deviceWidth() * 0.1,
                                        height: context.deviceHeight() * 0.2,
                                        child: (listFiles.isEmpty &&
                                                submitModel.iconBase64 == null)
                                            ? Stack(
                                                children: [
                                                  Visibility(
                                                    visible:
                                                        context.isDesktop(),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: isHovered
                                                            ? sccButtonLightBlue
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: DropzoneView(
                                                        onDrop: accFile,
                                                        onCreated:
                                                            (controller) =>
                                                                controllerDz =
                                                                    controller,
                                                        onHover: () =>
                                                            setState(() {
                                                          isHovered = true;
                                                        }),
                                                        onLeave: () =>
                                                            isHovered = false,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter,
                                                                colors: [
                                                                  sccButtonLightBlue,
                                                                  sccButtonBlue,
                                                                ]),
                                                          ),
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(20),
                                                            child: SvgPicture
                                                                .asset(Constant
                                                                    .cloudUpload),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "Drag and drop or ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: context
                                                                      .scaleFont(
                                                                          10),
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: "Browse",
                                                                style: TextStyle(
                                                                    fontSize: context
                                                                        .scaleFont(
                                                                            10),
                                                                    color:
                                                                        sccButtonBlue),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: SizedBox(
                                                  child:
                                                      Image.memory(fileBytes!),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: context.deviceWidth() * 0.5,
                                    height: context.deviceHeight() * 0.2,
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: context.scaleFont(7),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            SelectableText(
                                              'File Format : .JPG, .PNG, .JPEG',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.scaleFont(14)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: context.scaleFont(7),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            SelectableText(
                                              'File Size Max 1MB.',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.scaleFont(14)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: context.scaleFont(7),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            SelectableText(
                                              'File resolution 100px x 100px.',
                                              style: TextStyle(
                                                  fontSize:
                                                      context.scaleFont(14)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Visibility(
                  visible: widget.formMode == Constant.viewMode,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: isMobile
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.end,
                    children: [
                      ButtonReset(
                        text: "Close",
                        width: context.deviceWidth() *
                            (context.isDesktop() ? 0.11 : 0.35),
                        borderRadius: 8,
                        onTap: () => widget.onClose(),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.formMode != Constant.viewMode,
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
                        marginVertical: !isMobile ? 11 : 8,
                        onTap: widget.onClose,
                      ),
                      SizedBox(
                        width: 8.wh,
                      ),
                      // BlocBuilder<MstAttrBloc, MstAttrState>(
                      //     builder: (context, state) {
                      //   if (state is MstAttrLoading) {
                      //     return const Center(
                      //       child: CircularProgressIndicator(),
                      //     );
                      //   }
                      //   return
                      ButtonConfirm(
                        text: widget.formMode == Constant.editMode
                            ? "Save"
                            : "Submit",
                        borderRadius: 8,
                        verticalMargin: !isMobile ? 11 : 8,
                        onTap: () {
                          if (key.currentState!.validate()) {
                            if (listFiles.isEmpty &&
                                submitModel.iconBase64 != null) {
                              submitModel.fileBase64 =
                                  "${submitModel.attrIconName},${submitModel.iconBase64}";
                            }
                            submitModel.attrDataTypeLen ??= 0;
                            submitModel.attrDataTypePrec ??= 0;
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return ConfirmSaveDialog(
                                    sTitle: "Attribute",
                                    sValue: submitModel.attributeCd,
                                    onSave: () {
                                      context.closeDialog();
                                      bloc(SubmitMstAttr(
                                        submitModel,
                                        widget.formMode,
                                        widget.paging,
                                      ));
                                    },
                                  );
                                });
                            // bloc(SubmitMstAttr(
                            //   submitModel,
                            //   widget.formMode,
                            //   widget.paging,
                            // ));
                          }
                        },
                        width: context.deviceWidth() *
                            (context.isDesktop() ? 0.13 : 0.37),
                      ),
                      // })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
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
        final splitName = fileNameIcon?.split('.');
        String fileName = splitName![0];

        if (result.files.first.size > 1000000) {
          showTopSnackBar(
              context, const UpperSnackBar.error(message: 'File size max 1MB'));
        }

        // print(result);
        setState(() {
          isHovered = false;

          if (listFiles.isNotEmpty) listFiles.clear();

          listFiles.add(fileBytes);
          submitModel.fileBase64 = "$fileNameIcon,$base64File";
          submitModel.attrIconPath = fileNameIcon;
          submitModel.attrIconName = fileName;
          // submitModel.file = fileBytes;

          // print(listFiles);
        });
      } catch (e) {
        showTopSnackBar(context, UpperSnackBar.error(message: e.toString()));
      }
    }
    // else {
    //   showTopSnackBar(
    //       context, const UpperSnackBar.error(message: 'File not supported'));
    // }
  }

  accFile(dynamic file) async {
    fileNameIcon = file.name;
    // final mime = await controllerDz!.getFileMIME(file);
    // final size = await controllerDz!.getFileSize(file);
    // final url = await controllerDz!.createFileUrl(file);
    // final base64FileS = await controllerDz!.getFileData(file);
    // print("name = $fileNameIcon");
    // print("mime = $mime");
    // print("size = $size");
    // print("url = $url");
    // print("base64FileS = $base64FileS");

    if (controllerDz != null &&
        file != null &&
        (fileNameIcon!.split('.').last.contains("png") ||
            fileNameIcon!.split('.').last.contains("jpg") ||
            fileNameIcon!.split('.').last.contains("jpeg"))) {
      try {
        fileBytes = await controllerDz!.getFileData(file);
        base64File = base64Encode(fileBytes!);

        final splitName = fileNameIcon?.split('.');
        String fileName = splitName![0];

        setState(() {
          isHovered = false;
          if (listFiles.isNotEmpty) listFiles.clear();

          listFiles.add(fileBytes);
          submitModel.fileBase64 = "$fileNameIcon,$base64File";
          submitModel.attrIconPath = fileNameIcon;
          submitModel.attrIconName = fileName;
        });
      } catch (e) {
        showTopSnackBar(context, UpperSnackBar.error(message: e.toString()));
      }
    } else {
      showTopSnackBar(
          context, const UpperSnackBar.error(message: 'File not supported'));
    }
  }
}
