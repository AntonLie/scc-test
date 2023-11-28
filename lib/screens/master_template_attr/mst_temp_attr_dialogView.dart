// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/temp_attr.dart';
import 'package:scc_web/screens/master_template_attr/tmpl_attr_view_item.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';

class MstTempViewHeader extends StatelessWidget {
  final String? formMode;
  final TempAttr? model;
  final Function() onCancel;
  const MstTempViewHeader(
      {super.key, this.formMode, this.model, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    // bloc(TemplateAttributeEvent event) {
    //   BlocProvider.of<TemplateAttributeBloc>(context).add(event);
    // }

    return MstTempViewDialog(onCancel: onCancel);
  }
}

class MstTempViewDialog extends StatefulWidget {
  final String? formMode;
  final TempAttr? model;
  final Function() onCancel;

  const MstTempViewDialog(
      {super.key, this.formMode, this.model, required this.onCancel});

  @override
  State<MstTempViewDialog> createState() => _MstTempViewDialogState();
}

class _MstTempViewDialogState extends State<MstTempViewDialog> {
  late ScrollController controller;

  List<TempAttr> listAttr = [];
  List<TempAttDetail> listAttrDetail = [];
  TempAttr submitModel = TempAttr();
  bool validateList = false;

  late TextEditingController tmplAttrCdCo;
  late TextEditingController tmplAttrNameCo;
  late TextEditingController tmplAttrDescCo;

  @override
  void initState() {
    controller = ScrollController();

    if (widget.model != null) {
      submitModel = widget.model!;
      tmplAttrCdCo = TextEditingController(text: widget.model!.tempAttrCd);
      tmplAttrNameCo = TextEditingController(text: widget.model!.tempAttrName);
      tmplAttrDescCo = TextEditingController(text: widget.model!.tempAttrDesc);
      if (widget.model!.templateDetail != null) {
        listAttrDetail.addAll(widget.model!.templateDetail!);
      }
      if (listAttrDetail.every((element) => element.seq != null)) {
        listAttrDetail.sort((a, b) => a.seq!.compareTo(b.seq!));
      }
    }

    if (widget.formMode == Constant.addMode && listAttrDetail.isEmpty) {
      listAttrDetail.add(TempAttDetail());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();

    return Dialog(
      insetPadding: kIsWeb && !isWebMobile
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.15),
              vertical: (context.deviceHeight() * 0.1),
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
              controller: controller,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText.rich(
                      TextSpan(
                        text: "Template Attribute Code",
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: context.scaleFont(16),
                        ),
                        children: [
                          TextSpan(
                            text:
                                widget.formMode == Constant.viewMode ? "" : '*',
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      hint: 'Input Template Attribute Code',
                      controller: tmplAttrCdCo,
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
                      onChanged: (value) =>
                          submitModel.tempAttrCd = value?.trim(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SelectableText.rich(TextSpan(
                        text: "Template Attribute Name",
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: context.scaleFont(16),
                        ),
                        children: [
                          TextSpan(
                              text: widget.formMode == Constant.viewMode
                                  ? ""
                                  : '*',
                              style: const TextStyle(color: Colors.red))
                        ])),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      hint: 'Input Template Attribute Name',
                      controller: tmplAttrNameCo,
                      enabled: widget.formMode != Constant.viewMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is mandatory";
                        } else if (value.trim().length > 100) {
                          return "Only 100 characters for maximum allowed";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) =>
                          submitModel.tempAttrName = value?.trim(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SelectableText(
                      "Template Attribute Description",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: context.scaleFont(16),
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      hint: 'Input Template Attribute Description',
                      controller: tmplAttrDescCo,
                      enabled: widget.formMode != Constant.viewMode,
                      onChanged: (value) =>
                          submitModel.tempAttrDesc = value?.trim(),
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
                      visible: listAttrDetail.isNotEmpty &&
                          widget.formMode == Constant.viewMode,
                      child: TmplAttrChildren(
                        listDetail: listAttrDetail,
                      ),
                    ),
                    Visibility(
                      visible: validateList,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "List Attribute Details must not empty",
                            style: TextStyle(
                              fontSize: context.scaleFont(16), color: sccDanger,
                              overflow: TextOverflow.fade,
                              // fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Visibility(
                      visible: widget.formMode == Constant.viewMode,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonCancel(
                            text: "Close",
                            width: context.deviceWidth() *
                                (context.isDesktop() ? 0.11 : 0.4),
                            marginVertical: !isMobile ? 11 : 8,
                            // onTap: () => widget.onCancel(),
                            onTap: () {
                              widget.onCancel();
                              context.back();
                            },
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.formMode != Constant.viewMode,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonCancel(
                            text: "Cancel",
                            width: context.deviceWidth() *
                                (context.isDesktop() ? 0.11 : 0.4),
                            marginVertical: !isMobile ? 11 : 8,
                            onTap: () => widget.onCancel(),
                          ),
                          SizedBox(
                            width: 8.wh,
                          ),
                          ButtonConfirm(
                            text: widget.formMode == Constant.addMode
                                ? "Submit"
                                : "Save",
                            verticalMargin: !isMobile ? 11 : 8,
                            width: context.deviceWidth() *
                                (context.isDesktop() ? 0.11 : 0.4),
                            onTap: () {
                              if (key.currentState!.validate()) {
                                setState(() {
                                  validateList = listAttrDetail.isEmpty;
                                });
                                if (!validateList) {
                                  submitModel.templateDetail = listAttrDetail;
                                  // widget.onSave(submitModel);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
