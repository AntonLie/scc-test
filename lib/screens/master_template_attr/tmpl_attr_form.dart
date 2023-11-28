import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/mst_template_attribute/bloc/template_attribute_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/temp_attr.dart';
import 'package:scc_web/screens/master_role/tmpl_attr_detail_items.dart';
import 'package:scc_web/screens/master_template_attr/tmpl_attr_view_item.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';

class TempAttrForm extends StatefulWidget {
  final String? formMode;
  final TempAttr? model;
  final Function(TempAttr) onSave;
  final Function() onCancel;
  const TempAttrForm(
      {super.key,
      this.formMode,
      this.model,
      required this.onSave,
      required this.onCancel});

  @override
  State<TempAttrForm> createState() => _TempAttrFormState();
}

class _TempAttrFormState extends State<TempAttrForm> {
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
      if (widget.model!.templateDetail != null) {
        listAttrDetail.addAll(widget.model!.templateDetail!);
      }
      if (listAttrDetail.every((element) => element.seq != null)) {
        listAttrDetail.sort((a, b) => a.seq!.compareTo(b.seq!));
      }
    }
    tmplAttrCdCo = TextEditingController(text: submitModel.tempAttrCd ?? "");
    tmplAttrNameCo =
        TextEditingController(text: submitModel.tempAttrName ?? "");
    tmplAttrDescCo =
        TextEditingController(text: submitModel.tempAttrDesc ?? "");

    if (widget.formMode == Constant.addMode && listAttrDetail.isEmpty) {
      listAttrDetail.add(TempAttDetail());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();

    removeItem(int index) {
      setState(() {
        listAttrDetail = List.from(listAttrDetail)..removeAt(index);
        validateList = listAttrDetail.isEmpty;
      });
    }

    onConfirm(TempAttr val) {
      showDialog(
          context: context,
          builder: (context) {
            return ConfirmSaveDialog(
              sTitle: "Template Attribute",
              sValue: val.tempAttrName,
              onSave: () {
                widget.onSave(val);
                context.closeDialog();
              },
            );
          });
    }

    return Form(
      key: key,
      child: FocusTraversalGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  SelectableText.rich(
                    TextSpan(
                      text: "Template Attribute Code",
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: context.scaleFont(14),
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: widget.formMode == Constant.viewMode ? "" : '*',
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
                        fontSize: context.scaleFont(14),
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                            text:
                                widget.formMode == Constant.viewMode ? "" : '*',
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
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w400,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomFormTextField(
                    hint: 'Input Template Attribute Description',
                    controller: tmplAttrDescCo,
                    maxLine: 5,
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
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isMobile ? Colors.white : sccWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Attribute",
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
                    visible: listAttrDetail.isNotEmpty &&
                        widget.formMode == Constant.viewMode,
                    child: TmplAttrChildren(
                      listDetail: listAttrDetail,
                    ),
                  ),
                  Visibility(
                    visible: listAttrDetail.isNotEmpty &&
                        widget.formMode != Constant.viewMode,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          listAttrDetail.isNotEmpty ? listAttrDetail.length : 0,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        if (listAttrDetail.isNotEmpty) {
                          return BlocProvider(
                            create: (context) => TemplateAttributeBloc(),
                            child: TmplAttrDetailsItems(
                              model: listAttrDetail[index],
                              onAttrCdChange: (value) => listAttrDetail[index]
                                  .attributeCd = value?.trim(),
                              onmandatoryFlagChanged: (value) =>
                                  listAttrDetail[index].mandatoryFlag = value,
                              showOnTraceabilityFlagChanged: (value) =>
                                  listAttrDetail[index].showTraceAbility =
                                      value,
                              onClose: (returnKey) {
                                removeItem(index);
                              },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  // Visibility(
                  //   visible: widget.formMode != Constant.viewMode,
                  //   child: const SizedBox(height: 10),
                  // ),
                  Visibility(
                    visible: widget.formMode != Constant.viewMode,
                    child: DottedAddButton(
                      text: ' Add Attribute Code',
                      width: context.deviceWidth() * 0.155,
                      onTap: () {
                        setState(() {
                          validateList = false;
                          listAttrDetail.add(TempAttDetail());
                        });
                      },
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
                            fontSize: context.scaleFont(14),
                            fontWeight: FontWeight.w400, color: sccDanger,
                            overflow: TextOverflow.fade,
                            // fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
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
                    onTap: () => widget.onCancel(),
                  ),
                  SizedBox(
                    width: 8.wh,
                  ),
                  ButtonConfirm(
                    text:
                        widget.formMode == Constant.addMode ? "Submit" : "Save",
                    width: context.deviceWidth() *
                        (context.isDesktop() ? 0.13 : 0.37),
                    borderRadius: 8,
                    fontWeight: FontWeight.w600,
                    onTap: () {
                      if (key.currentState!.validate()) {
                        setState(() {
                          validateList = listAttrDetail.isEmpty;
                        });
                        if (!validateList) {
                          submitModel.templateDetail = listAttrDetail;
                          onConfirm(submitModel);
                          // showDialog(context: context, builder: builder)
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
    );
  }
}
