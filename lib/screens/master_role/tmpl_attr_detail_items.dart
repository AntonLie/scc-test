// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/mst_template_attribute/bloc/template_attribute_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/temp_attr.dart';

import 'package:scc_web/screens/master_template_attr/attr_bottom_sheet.dart';
import 'package:scc_web/screens/master_template_attr/lov_tmpl_attr_code.dart';
import 'package:scc_web/shared_widgets/custom_checkbox.dart';
import 'package:scc_web/shared_widgets/lov_container.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class TmplAttrDetailsItems extends StatefulWidget {
  final TempAttDetail model;
  final Function(Key?) onClose;
  final Function(String?) onAttrCdChange;
  final Function(bool) onmandatoryFlagChanged, showOnTraceabilityFlagChanged;

  const TmplAttrDetailsItems({
    Key? key,
    required this.model,
    required this.onClose,
    required this.onAttrCdChange,
    required this.showOnTraceabilityFlagChanged,
    required this.onmandatoryFlagChanged,
  }) : super(key: key);

  @override
  State<TmplAttrDetailsItems> createState() => _TmplAttrDetailsItemsState();
}

class _TmplAttrDetailsItemsState extends State<TmplAttrDetailsItems> {
  late TextEditingController attrCdCo;
  String? attrCd;
  int? seq;

  bool mandatoryFlag = false;
  bool showOnTraceabilityFlag = false;

  @override
  void initState() {
    //seqCo = TextEditingController();
    attrCdCo = TextEditingController(text: widget.model.attributeCd);
    attrCd = widget.model.attributeCd;
    mandatoryFlag = widget.model.mandatoryFlag ?? false;
    showOnTraceabilityFlag = widget.model.showTraceAbility ?? false;
    seq = widget.model.seq ?? 1;

    // int i = 1;
    // model.forEach((element) {});
    //mandatoryFlag = widget.model.mandatoryFlag ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();
  }

  onTap() {
    if (isMobile) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        // isDismissible: categorySelected != null,
        // enableDrag: categorySelected != null,
        builder: (context) {
          return Container(
            height: context.deviceHeight() * 0.8,
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            // child: Container(),
            child: BlocProvider(
              create: (context) => TemplateAttributeBloc()
                ..add(
                    SearchAttributeCd(paging: Paging(pageNo: 1, pageSize: 5))),
              child: AttrBottomSheet(
                onAttrCdSelected: (value) {
                  setState(() {
                    attrCd = value.attributeCd;
                    // attrCdCo.value = attrCdCo.value.copyWith(text: value.attrName);
                    widget.onAttrCdChange(value.attributeCd);
                  });
                },
              ),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          // return Container();
          return BlocProvider(
            create: (context) => TemplateAttributeBloc()
              ..add(SearchAttributeCd(paging: Paging(pageNo: 1, pageSize: 5))),
            child: LovAttributeCd(
              onAttrCdSelected: (value) {
                setState(() {
                  attrCd = value.attributeCd;
                  // attrCdCo.value = attrCdCo.value.copyWith(text: value.attrName);
                  widget.onAttrCdChange(value.attributeCd);
                });
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      // padding: EdgeInsets.all(8),
      width: context.deviceWidth(),
      // decoration: BoxDecoration(
      //   color: VccGray,
      //   borderRadius: BorderRadius.circular(8),
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText(
                text: 'Attribute Code <r>*</r>',
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
              ExcludeFocus(
                child: InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () => widget.onClose(widget.key),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: context.scaleFont(14),
                      fontWeight: FontWeight.w400,
                      color: sccDanger,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LovFormContainer(
            value: attrCd,
            label: attrCd,
            hint: 'Select Attribute',
            onTap: onTap,
            validator: (value) {
              if (attrCd == null) {
                return "This field is mandatory";
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: CustomCheckboxListTile(
                    enabled:
                        true, // widget.formMode != Constant.FORM_MODE_VIEW,
                    value: mandatoryFlag,
                    mandatory: false,
                    title: 'Mandatory',
                    onChanged: (newBool) {
                      setState(() {
                        mandatoryFlag = !mandatoryFlag;
                      });
                      widget.onmandatoryFlagChanged(mandatoryFlag);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
