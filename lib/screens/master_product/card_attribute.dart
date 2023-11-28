import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/master_product.dart';
import 'package:scc_web/screens/master_product/attr_items.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class ChildCard extends StatefulWidget {
  final Function(String?)? detailAttribute, detailName;
  final String? labelName, labelAttr;
  final int? index;
  final Function(ProductDetail?) detailData;

  const ChildCard({
    super.key,
    this.detailAttribute,
    this.detailName,
    this.index,
    this.labelName,
    this.labelAttr,
    required this.detailData,
  });

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  List<ProductDetail> listDetail = [];
  String? inputData;
  String? selectedData;
  late TextEditingController nameAttribute;
  bool valueChange = false;

  @override
  void initState() {
    nameAttribute = TextEditingController(text: widget.labelName ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: sccBackground,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4.0,
            offset: Offset(2.0, 2.0),
          ),
        ],
        border: Border.all(
          width: 0.05,
        ),
      ),
      width: context.deviceWidth() * 0.23,
      padding: const EdgeInsets.all(12),
      // color: sccBackground,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            StyledText(
              text: 'Name '
                  '<r>*</r>'
                  '',
              style: TextStyle(fontSize: context.scaleFont(14)),
              tags: {
                'r': StyledTextTag(
                  style: TextStyle(
                      fontSize: context.scaleFont(14), color: sccDanger),
                )
              },
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: context.deviceWidth() * 0.21,
              child: CustomFormTextField(
                hint: 'Please choose the attribute first',
                controller: nameAttribute,
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
                  // print("value input data : $value");
                  if (value != null) {
                    setState(() {
                      inputData = value.trim();
                      valueChange = true;
                    });
                  } else if (value == null) {
                    inputData = widget.labelName;
                  }
                  widget.detailName!(inputData);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StyledText(
              text: 'Value '
                  '<r>*</r>'
                  '',
              style: TextStyle(fontSize: context.scaleFont(14)),
              tags: {
                'r': StyledTextTag(
                  style: TextStyle(
                      fontSize: context.scaleFont(14), color: sccDanger),
                )
              },
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: context.deviceWidth() * 0.21,
              child: AttributeItemsDialog(
                selectedData: widget.labelAttr == "" ? null : widget.labelAttr,
                onAttrCdChange: (value) {
                  if (value != null) {
                    setState(() {
                      selectedData = value.attributeCd;

                      inputData = value.attributeName;
                      nameAttribute.text = value.attributeName!;
                      widget.detailName!(value.attributeName!.trim());
                    });
                  } else if (value == null) {
                    selectedData = widget.labelAttr;
                  }
                  widget.detailAttribute!(selectedData);
                  widget.detailData(
                    ProductDetail(labelName: inputData, attrCd: selectedData),
                  );
                },
              ),
            ),
          ]),
    );
  }
}
