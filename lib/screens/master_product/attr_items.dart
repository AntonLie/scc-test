import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/mst_template_attribute/bloc/template_attribute_bloc.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/temp_attr.dart';
import 'package:scc_web/screens/master_template_attr/lov_tmpl_attr_code.dart';
import 'package:scc_web/shared_widgets/lov_container.dart';

class AttributeItemsDialog extends StatefulWidget {
  final Function(AttrCodeClass?) onAttrCdChange;
  // final Function(String?) onAttrNameChange;
  final String? selectedData;

  const AttributeItemsDialog({
    super.key,
    required this.onAttrCdChange,
    this.selectedData,
  });

  @override
  State<AttributeItemsDialog> createState() => _AttributeItemsDialogState();
}

class _AttributeItemsDialogState extends State<AttributeItemsDialog> {
  String? attrCd;

  onTap() {
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
                widget.onAttrCdChange(value);
                // widget.onAttrNameChange(value.attributeName);
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
      // enabled: attrCd != Constant.itemCd &&
      //     attrCd != Constant.blockchainStatus &&
      //     attrCd != Constant.itemId,
      // false,
      hint: 'Select attribute',
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
