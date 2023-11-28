import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/mst_template_attribute/bloc/template_attribute_bloc.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/temp_attr.dart';
import 'package:scc_web/screens/MasterPoint/attribute_lov_dialog.dart';
import 'package:scc_web/shared_widgets/lov_container.dart';

class LovTemplateAttrDialog extends StatefulWidget {
  final Function(TempAttr?) onAttrCdChange;
  final String? selectedTemplateAttr;
  final String? selectedData;
  final String? dataType;

  const LovTemplateAttrDialog({
    super.key,
    required this.onAttrCdChange,
    this.selectedData,
    this.selectedTemplateAttr,
    this.dataType,
  });

  @override
  State<LovTemplateAttrDialog> createState() => _LovTemplateAttrDialogState();
}

class _LovTemplateAttrDialogState extends State<LovTemplateAttrDialog> {
  String? attrCd;

  onTap() {
    showDialog(
      context: context,
      builder: (context) {
        // return Container();
        return BlocProvider(
          create: (context) => TemplateAttributeBloc()
            ..add(ViewAllTemplateAttr(
                paging: Paging(pageNo: 1, pageSize: 5),
                model: TempAttr(
                    tempAttrCd: widget.selectedTemplateAttr ?? "",
                    attrDataTypeCd: "ADT_DT_TM"))),
          child: LovAttrTemplate(
            selectedTemplateAttr: widget.selectedTemplateAttr,
            dataType: widget.dataType,
            onAttrCdSelected: (value) {
              setState(() {
                attrCd = value.attrApiKey;
                widget.onAttrCdChange(value);
              });
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    attrCd = widget.selectedData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LovFormContainer(
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
    );
  }
}
